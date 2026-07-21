#import "LSLocationBridge.h"
#import "LSLocationState.h"

CLLocation *LSGetCurrentSpoofedLocation(void) {
    return [[LSLocationState shared] currentLocation];
}
