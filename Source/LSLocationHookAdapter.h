#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LSLocationHookAdapter : NSObject
+ (nullable CLLocation *)currentSpoofedLocation;
+ (BOOL)shouldProvideSpoofedLocation;
@end
NS_ASSUME_NONNULL_END
