#import "LSSystemWideBridge.h"

#import <errno.h>
#import <math.h>
#import <notify.h>
#import <signal.h>
#import <unistd.h>

static const char *kLSLiveRouteCoordinateNotification = "com.locationspoofer.dylib/live-route-coordinate";
static const char *kLSLiveRouteMotionNotification = "com.locationspoofer.dylib/live-route-motion";
static const char *kLSLiveRouteStatusNotification = "com.locationspoofer.dylib/live-route-status";

static int ls_coordinateToken = NOTIFY_TOKEN_INVALID;
static int ls_motionToken = NOTIFY_TOKEN_INVALID;
static int ls_statusToken = NOTIFY_TOKEN_INVALID;

static void LSRegisterLiveRouteTokens(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notify_register_check(kLSLiveRouteCoordinateNotification, &ls_coordinateToken);
        notify_register_check(kLSLiveRouteMotionNotification, &ls_motionToken);
        notify_register_check(kLSLiveRouteStatusNotification, &ls_statusToken);
    });
}

static uint64_t LSPackCoordinate(CLLocationCoordinate2D coordinate) {
    int32_t latitude = (int32_t)llround(coordinate.latitude * 1000000.0);
    int32_t longitude = (int32_t)llround(coordinate.longitude * 1000000.0);
    return ((uint64_t)(uint32_t)latitude << 32) | (uint32_t)longitude;
}

static CLLocationCoordinate2D LSUnpackCoordinate(uint64_t value) {
    int32_t latitude = (int32_t)(uint32_t)(value >> 32);
    int32_t longitude = (int32_t)(uint32_t)value;
    return CLLocationCoordinate2DMake((double)latitude / 1000000.0,
                                      (double)longitude / 1000000.0);
}

static uint64_t LSPackMotion(CLLocationDirection heading, CLLocationSpeed speed) {
    double normalizedHeading = fmod(heading, 360.0);
    if (normalizedHeading < 0.0) normalizedHeading += 360.0;
    uint32_t headingMilliDegrees = (uint32_t)llround(normalizedHeading * 1000.0);
    uint32_t speedMillimetersPerSecond = (uint32_t)llround(MAX(0.0, speed) * 1000.0);
    return ((uint64_t)headingMilliDegrees << 32) | speedMillimetersPerSecond;
}

void LSPublishLiveRoute(CLLocationCoordinate2D coordinate,
                        CLLocationDirection heading,
                        CLLocationSpeed speed,
                        BOOL paused) {
    if (!CLLocationCoordinate2DIsValid(coordinate)) return;
    LSRegisterLiveRouteTokens();
    if (ls_coordinateToken == NOTIFY_TOKEN_INVALID ||
        ls_motionToken == NOTIFY_TOKEN_INVALID ||
        ls_statusToken == NOTIFY_TOKEN_INVALID) {
        return;
    }

    notify_set_state(ls_coordinateToken, LSPackCoordinate(coordinate));
    notify_set_state(ls_motionToken, LSPackMotion(heading, paused ? 0.0 : speed));

    uint64_t status = (1ULL << 63) |
                      (paused ? (1ULL << 62) : 0) |
                      (uint32_t)getpid();
    notify_set_state(ls_statusToken, status);
    notify_post(kLSLiveRouteStatusNotification);
}

BOOL LSReadLiveRoute(LSLiveRouteSnapshot *snapshot) {
    if (!snapshot) return NO;
    LSRegisterLiveRouteTokens();
    if (ls_coordinateToken == NOTIFY_TOKEN_INVALID ||
        ls_motionToken == NOTIFY_TOKEN_INVALID ||
        ls_statusToken == NOTIFY_TOKEN_INVALID) {
        return NO;
    }

    uint64_t status = 0;
    if (notify_get_state(ls_statusToken, &status) != NOTIFY_STATUS_OK ||
        (status & (1ULL << 63)) == 0) {
        return NO;
    }

    pid_t publisherPID = (pid_t)(uint32_t)status;
    if (publisherPID <= 0 ||
        (kill(publisherPID, 0) != 0 && errno == ESRCH)) {
        return NO;
    }

    uint64_t packedCoordinate = 0;
    uint64_t packedMotion = 0;
    if (notify_get_state(ls_coordinateToken, &packedCoordinate) != NOTIFY_STATUS_OK ||
        notify_get_state(ls_motionToken, &packedMotion) != NOTIFY_STATUS_OK) {
        return NO;
    }

    CLLocationCoordinate2D coordinate = LSUnpackCoordinate(packedCoordinate);
    if (!CLLocationCoordinate2DIsValid(coordinate)) return NO;

    snapshot->active = YES;
    snapshot->paused = (status & (1ULL << 62)) != 0;
    snapshot->coordinate = coordinate;
    snapshot->heading = (CLLocationDirection)(uint32_t)(packedMotion >> 32) / 1000.0;
    snapshot->speed = snapshot->paused
        ? 0.0
        : (CLLocationSpeed)(uint32_t)packedMotion / 1000.0;
    snapshot->publisherPID = publisherPID;
    return YES;
}

void LSClearLiveRoute(void) {
    LSRegisterLiveRouteTokens();
    if (ls_statusToken == NOTIFY_TOKEN_INVALID) return;
    notify_set_state(ls_statusToken, 0);
    notify_post(kLSLiveRouteStatusNotification);
}
