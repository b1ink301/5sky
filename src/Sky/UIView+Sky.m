#import "Headers.h"
#import "UIView+Sky.h"
#import "SkyImageView.h"
#import "UIColor+Sky.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Sky)

+ (UIView *)mainViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius
{
    SkyImageView *view = [SkyImageView imageViewWithFrame:frame];
    
    view.image = [UIImage imageWithContentsOfFile:[[[NSBundle alloc] initWithPath:BUNDLE_PATH] pathForResource:@"Main_Background@2x" ofType:@"png"]];
    view.backgroundColor = [UIColor whiteColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.userInteractionEnabled = YES;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    return view;
}

+ (UIView *)topbarViewViewWithFrame:(CGRect)frame
{
    SkyImageView *view = [SkyImageView imageViewWithFrame:frame];
    view.image = [UIImage imageWithContentsOfFile:[[[NSBundle alloc] initWithPath:BUNDLE_PATH] pathForResource:@"Topbar_Background@2x" ofType:@"png"]];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    view.userInteractionEnabled = YES;
    
    UIImage *shadowImage = [UIImage imageWithContentsOfFile:[[[NSBundle alloc] initWithPath:BUNDLE_PATH] pathForResource:@"Topbar_Shadow@2x" ofType:@"png"]];
    SkyImageView *shadowView = [SkyImageView imageViewWithFrame:CGRectMake(0, frame.size.height, frame.size.width, shadowImage.size.height)];
    shadowView.image = shadowImage;
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:shadowView];
    return view;
}

+ (UIView *)bottombarViewWithFrame:(CGRect)frame
{
    NSBundle* bundle = [[NSBundle alloc] initWithPath:BUNDLE_PATH];
    
    SkyImageView *view = [SkyImageView imageViewWithFrame:frame];  
    view.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Bottombar_Background@2x" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 19, 0)];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    view.userInteractionEnabled = YES;
    UIImage *shadowImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Bottombar_Shadow@2x" ofType:@"png"]];
    SkyImageView *shadowView = [SkyImageView imageViewWithFrame:CGRectMake(0, -shadowImage.size.height, frame.size.width, shadowImage.size.height) ];
    shadowView.image = shadowImage;
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:shadowView];
    return view;
}

+ (UILabel *)titleLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    label.clipsToBounds = NO;
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"000000"];
    label.shadowColor = [UIColor colorFromHexString:@"00000000"];
    return label;
}

+ (UITextField *)titleField
{
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectZero];
    field.backgroundColor = [UIColor clearColor];
    field.borderStyle = UITextBorderStyleNone;
    field.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.clearsOnBeginEditing = YES;
    field.font = [UIFont systemFontOfSize:6];
    field.textAlignment = NSTextAlignmentCenter;
    field.textColor = 0x000000;
    return field;
}

+ (UIButton *)buttonWithApplicationIcon:(NSString *)applicationIdentifier
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage _applicationIconImageForBundleIdentifier:applicationIdentifier format:0 scale:[UIScreen mainScreen].scale]forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
{
    NSBundle* bundle = [[NSBundle alloc] initWithPath:BUNDLE_PATH];
     
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [button setBackgroundImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Button_Normal@2x" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Button_Highlighted@2x" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"007AFF"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"007AFF99"] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorFromHexString:@"00000000"] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorFromHexString:@"00000000"] forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)photoButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithContentsOfFile:[[[NSBundle alloc] initWithPath:BUNDLE_PATH] pathForResource:@"PhotoButton@2x" ofType:@"png"]] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)sendButtonWithTitle:(NSString *)title
{
    NSBundle* bundle = [[NSBundle alloc] initWithPath:BUNDLE_PATH];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [button setBackgroundImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"SendButton_Normal@2x" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"SendButton_Highlighted@2x" ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"007AFF"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"007AFF99"] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorFromHexString:@"00000000"] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorFromHexString:@"00000000"] forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)lightButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    return button;
}


- (NSArray *)findViewsUsingBlock:(BOOL (^)(UIView *))block
{
    NSMutableArray *views = [NSMutableArray array];
    if (block(self)) {
        [views addObject:self];
    }
    for (UIView *view in self.subviews) {
        [views addObjectsFromArray:[view findViewsUsingBlock:block]];
    }
    return views;
}

@end
