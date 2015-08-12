#import "SkyMessageView.h"
#import "SkyImageView.h"
#import "NSString+Sky.h"
#import "Headers.h"
#import "UIColor+Sky.h"
#import "../PAImageView/PAImageView.h"


@interface SkyMessageView ()

@property(assign, nonatomic) BOOL outgoing;
@property(retain, nonatomic) NSString *message;
@property(retain, nonatomic) NSString *url;
@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSBundle *bundle;
@property(strong, nonatomic) PAImageView *iconView;
@property(strong, nonatomic) SkyImageView *imageView;
@property(strong, nonatomic) UILabel *textView;
@property(strong, nonatomic) UILabel *nameView;

@end

#define IncomingMessage_Background @"IncomingMessage_Background@2x"
#define OutgoingMessage_Background @"OutgoingMessage_Background@2x"

@implementation SkyMessageView

- (instancetype)initWithFrame:(CGRect)frame outgoing:(BOOL)outgoing textSize:(CGFloat)textSize
{
    self = [self initWithFrame:frame];
    if (self) {
        
        _bundle = [[NSBundle alloc] initWithPath:BUNDLE_PATH];
         
        _outgoing = outgoing;
        _imageView = [SkyImageView imageViewWithFrame:CGRectZero];
        _imageView.image = outgoing ? [[UIImage imageWithContentsOfFile:[_bundle pathForResource:OutgoingMessage_Background ofType:@"png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 18, 17, 24)] : [[UIImage imageWithContentsOfFile:[_bundle pathForResource:IncomingMessage_Background ofType:@"png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 24, 17, 18)];
        _imageView.backgroundColor = [UIColor clearColor];
        _nameView = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameView.backgroundColor = [UIColor clearColor];
        _nameView.numberOfLines = 0;
        _nameView.font = [UIFont boldSystemFontOfSize:textSize];
        _nameView.textColor = [UIColor darkGrayColor];
        
        _textView = [[UILabel alloc]initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:textSize];
        _textView.textColor = outgoing ? [UIColor colorFromHexString:@"FFFFFF"] : [UIColor colorFromHexString:@"000000"];
        _textView.numberOfLines = 0;
        
        _iconView = [[PAImageView alloc] initWithFrame:CGRectMake(10, 5, ICON_WIDTH, ICON_WIDTH)
                               backgroundProgressColor:[UIColor whiteColor]
                                         progressColor:[UIColor darkGrayColor]];
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:_imageView];
        [self addSubview:_textView];
        [self addSubview:_iconView];
        [self addSubview:_nameView];
    }
    return self;
}

- (void)setOutgoing:(BOOL)outgoing
{
    [_iconView setHidden:outgoing];
    
    _outgoing = outgoing;
    _imageView.image = outgoing ? [[UIImage imageWithContentsOfFile:[_bundle pathForResource:OutgoingMessage_Background ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(14, 18, 17, 24)] : [[UIImage imageWithContentsOfFile:[_bundle pathForResource:IncomingMessage_Background ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(14, 24, 17, 18)];
    _textView.textColor = outgoing ? [UIColor colorFromHexString:@"FFFFFF"] : [UIColor colorFromHexString:@"000000"];
    [self setNeedsLayout];
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    _textView.text = message;
    [self setNeedsLayout];
}

- (void)setName:(NSString*)name withIconUrl:(NSString*)iconUrl withOutgoing:(BOOL)outgoing{
//    NSLog(@"%s name=%@ iconUrl=%@ outgoing=%d", __FUNCTION__, name, iconUrl, outgoing);
    
    _url = iconUrl;
    _outgoing = outgoing;
    _name = name;
    _nameView.text = name;
    
    if(_outgoing==YES){
        [_iconView setHidden:YES];
        [_nameView setHidden:YES];
    }
    else{
        [_iconView setHidden:NO];
        [_nameView setHidden:NO];
        
        if(_url!=nil && [_url hasPrefix:@"http"]){
	        [_iconView setImageURL:[NSURL URLWithString:iconUrl]];
        }
        else{
            [_iconView updateWithImage:[UIImage imageWithContentsOfFile:[_bundle pathForResource:@"unknown@2x" ofType:@"png"]] animated:NO];
        }
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *backgroundImage = _outgoing ? [[UIImage imageWithContentsOfFile:[_bundle pathForResource:OutgoingMessage_Background ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(14, 18, 17, 24)] : [[UIImage imageWithContentsOfFile:[_bundle pathForResource:IncomingMessage_Background ofType:@"png"]]resizableImageWithCapInsets:UIEdgeInsetsMake(14, 24, 17, 18)];
    
    CGFloat fontSize = _textView.font.pointSize;

    CGSize textSize = [_message messageTextSizeWithWidth:_outgoing?215:215-ICON_WIDTH+10 fontSize:fontSize];
    CGSize backgroundSize = [_message messageBackgroundSizeWithWidth:_outgoing?215:215-ICON_WIDTH+10 fontSize:fontSize];
        
    CGRect backgroundFrame = {CGPointMake(_outgoing ? self.frame.size.width - backgroundSize.width : ICON_WIDTH + 8, _outgoing?2:fontSize + 6), backgroundSize};
    
    CGRect textFrame = CGRectMake(backgroundFrame.origin.x + backgroundImage.capInsets.left - 4, backgroundFrame.origin.y+6, textSize.width + 1, textSize.height + 2);
    
    CGRect nameFrame = CGRectMake(backgroundFrame.origin.x + 8, 4, self.frame.size.width-ICON_WIDTH-20, fontSize + 2);

    _imageView.frame = backgroundFrame;
    _textView.frame = textFrame;
    _nameView.frame = nameFrame;
    
}

@end
