#import "LSLocationHookAdapter.h"
#import "LSSpoofProvider.h"
#import "PersistenceManager.h"
#import "RouteSimulator.h"

@implementation LSLocationHookAdapter
+ (BOOL)shouldProvideSpoofedLocation {
    PersistenceManager *store = [PersistenceManager shared];
    BOOL requested = [store isSpoofingEnabled] || store.keepLastSpoof;
    BOOL hasSource = [LSRouteSimulator shared].isSimulating || [store hasStoredCoordinate];
    return requested && hasSource;
}
+ (nullable CLLocation *)currentSpoofedLocation {
    return [[LSSpoofProvider shared] currentLocation];
}
@end
