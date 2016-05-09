#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (Sky)

+ (CALayer *)borderLayerWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (CALayer *)shadowLayerWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

@end
