#import "LSLocationHookAdapter.h"
#import "LSSpoofProvider.h"
#import "PersistenceManager.h"
#import "RouteSimulator.h"
#import "LSSystemWideBridge.h"

@implementation LSLocationHookAdapter
+ (BOOL)shouldProvideSpoofedLocation {
    PersistenceManager *store = [PersistenceManager shared];
    BOOL requested = [store isSpoofingEnabled] || store.keepLastSpoof;
    LSLiveRouteSnapshot liveRoute = {0};
    BOOL hasSource = [LSRouteSimulator shared].isSimulating ||
                     LSReadLiveRoute(&liveRoute) ||
                     [store hasStoredCoordinate];
    return requested && hasSource;
}
+ (nullable CLLocation *)currentSpoofedLocation {
    return [[LSSpoofProvider shared] currentLocation];
}
@end
