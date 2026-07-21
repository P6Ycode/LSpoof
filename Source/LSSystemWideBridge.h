#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <sys/types.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    BOOL active;
    BOOL paused;
    CLLocationCoordinate2D coordinate;
    CLLocationDirection heading;
    CLLocationSpeed speed;
    pid_t publisherPID;
} LSLiveRouteSnapshot;

FOUNDATION_EXPORT void LSPublishLiveRoute(CLLocationCoordinate2D coordinate,
                                          CLLocationDirection heading,
                                          CLLocationSpeed speed,
                                          BOOL paused);
FOUNDATION_EXPORT BOOL LSReadLiveRoute(LSLiveRouteSnapshot *snapshot);
FOUNDATION_EXPORT void LSClearLiveRoute(void);

NS_ASSUME_NONNULL_END
