#import "LSLocationBridge.h"
#import "LSSpoofProvider.h"

CLLocation *LSGetCurrentSpoofedLocation(void) {
    return [[LSSpoofProvider shared] currentLocation];
}

void LSClearCurrentSpoofedLocation(void) {
    [[LSSpoofProvider shared] clear];
}
