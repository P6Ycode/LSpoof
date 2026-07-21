#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSVehicleDynamics : NSObject

@property (nonatomic, assign) double targetSpeedMetersPerSecond;
@property (nonatomic, assign, readonly) double currentSpeedMetersPerSecond;
@property (nonatomic, assign, readonly) BOOL isStopped;

- (void)setTargetSpeedMetersPerSecond:(double)speed;
- (double)advanceWithDeltaTime:(double)deltaTime;
- (void)stop;
- (void)resume;

@end

NS_ASSUME_NONNULL_END
