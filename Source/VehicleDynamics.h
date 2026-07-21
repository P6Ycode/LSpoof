#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSVehicleDynamics : NSObject
@property (nonatomic, assign) double targetSpeedMetersPerSecond;
@property (nonatomic, assign, readonly) double currentSpeedMetersPerSecond;
@property (nonatomic, assign) double accelerationMetersPerSecondSquared;
@property (nonatomic, assign) double brakingMetersPerSecondSquared;
- (double)advanceWithDeltaTime:(NSTimeInterval)deltaTime;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
