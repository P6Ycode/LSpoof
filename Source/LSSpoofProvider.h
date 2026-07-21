#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSSpoofProvider : NSObject

@property (class, nonatomic, readonly) LSSpoofProvider *shared;

- (CLLocation *)currentLocation;

@end

NS_ASSUME_NONNULL_END
