#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLocationHookAdapter : NSObject

+ (CLLocation *)currentSpoofedLocation;
+ (BOOL)shouldProvideSpoofedLocation;

@end

NS_ASSUME_NONNULL_END
