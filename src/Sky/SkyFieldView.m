#import "Headers.h"
#import "SkyFieldView.h"
#import "SkyImageView.h"
#import "UIColor+Sky.h"

// Workaround for broken UITextView in iOS 7. See https://github.com/jaredsinclair/JTSTextView


@interface SkyFieldView ()

@property(strong, nonatomic) JTSTextView *textView;

@end

@implementation SkyFieldView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate>)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        _textView = [[JTSTextView alloc]initWithFrame:CGRectMake(1, 3, frame.size.width-5, frame.size.height-10)] ;
        _textView.delegate = delegate;
        _textView.backgroundColor = [UIColor colorFromHexString:@"FAFAFA"];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor colorFromHexString:@"000000"];
        _textView.scrollEnabled = NO;
        _textView.scrollsToTop = NO;
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(12, 0, 6, 6);

        _textView.textViewDelegate = (id<JTSTextViewDelegate>)delegate;
        _textView.textContainerInset = UIEdgeInsetsMake(13, 4, 0, 4);
        
        SkyImageView *backgroundView = [SkyImageView imageViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backgroundView.image = [[UIImage imageWithContentsOfFile:[[[NSBundle alloc] initWithPath:BUNDLE_PATH] pathForResource:@"Field_Background@2x" ofType:@"png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 12, 19, 18)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textView];
        [self addSubview:backgroundView];
        
        [_textView setText:@""];
        [_textView simpleScrollToCaret];
    }
    return self;
}

@end
