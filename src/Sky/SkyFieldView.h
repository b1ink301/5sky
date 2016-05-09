#import <UIKit/UIKit.h>
#import "../JTSTextView/JTSTextView.h"

@interface SkyFieldView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate>)delegate;
- (JTSTextView *)textView;

@end
