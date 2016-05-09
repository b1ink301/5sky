#import <UIKit/UIKit.h>

@interface UIView (Sky)

+ (UIView *)mainViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;
+ (UIView *)topbarViewViewWithFrame:(CGRect)frame;
+ (UIView *)bottombarViewWithFrame:(CGRect)frame;
+ (UILabel *)titleLabelWithTitle:(NSString *)title;
+ (UITextField *)titleField;
+ (UIButton *)buttonWithApplicationIcon:(NSString *)applicationIdentifier;
+ (UIButton *)buttonWithTitle:(NSString *)title;
+ (UIButton *)sendButtonWithTitle:(NSString *)title;
+ (UIButton *)lightButton;
+ (UIButton *)photoButton;
- (NSArray *)findViewsUsingBlock:(BOOL (^)(UIView *))block;

@end
