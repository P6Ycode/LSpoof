#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT CLLocation * _Nullable LSGetCurrentSpoofedLocation(void);
FOUNDATION_EXPORT void LSClearCurrentSpoofedLocation(void);
NS_ASSUME_NONNULL_END
