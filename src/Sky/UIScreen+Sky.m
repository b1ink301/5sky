#import "Headers.h"
//#import "interface.h"
#import "UIScreen+Sky.h"

@implementation UIScreen (Sky)

- (UIInterfaceOrientation)frontMostAppOrientation
{
    UIInterfaceOrientation orientation = ((SpringBoard *)[NSClassFromString(@"SpringBoard")sharedApplication])._frontMostAppOrientation;
    return orientation;
}

- (CGRect)viewFrame
{
    UIInterfaceOrientation orientation = self.frontMostAppOrientation;
    CGSize screenSize = self.bounds.size;
    CGSize viewSize = UIInterfaceOrientationIsPortrait(orientation) ? screenSize : CGSizeMake(screenSize.height, screenSize.width);
    CGRect viewFrame = {CGPointZero, viewSize};
    return viewFrame;
}

@end
