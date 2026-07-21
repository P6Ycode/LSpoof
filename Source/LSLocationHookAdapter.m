#import "LSLocationHookAdapter.h"
#import "LSSpoofProvider.h"
#import "PersistenceManager.h"

@implementation LSLocationHookAdapter

+ (BOOL)shouldProvideSpoofedLocation {
    return [[PersistenceManager shared] isSpoofingEnabled] ||
           [[PersistenceManager shared] keepLastSpoof];
}

+ (CLLocation *)currentSpoofedLocation {
    return [[LSSpoofProvider shared] currentLocation];
}

@end
