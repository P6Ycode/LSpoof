#import "LSSpoofProvider.h"
#import "LSLocationState.h"

@implementation LSSpoofProvider

+ (instancetype)shared {
    static LSSpoofProvider *provider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provider = [LSSpoofProvider new];
    });
    return provider;
}

- (CLLocation *)currentLocation {
    return [LSLocationState.shared currentLocation];
}

@end
