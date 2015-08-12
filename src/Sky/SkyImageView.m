//#import "Headers.h"
#import "SkyImageView.h"

@implementation SkyImageView

+ (instancetype)imageViewWithFrame:(CGRect)frame
{
    SkyImageView *imageView = [[SkyImageView alloc]initWithFrame:frame];
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeRedraw;
    return imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [_image drawInRect:rect];
}

@end
