#import "SkyMessageCell.h"
#import "SkyMessageView.h"
#import "UIColor+Sky.h"

@interface SkyMessageCell ()

@property(strong, nonatomic) SkyMessageView *messageView;
@property(strong, nonatomic) UILabel *timestampLabel;
@property(assign) BOOL hasTimestamp;

@end

@implementation SkyMessageCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier outgoing:(BOOL)outgoing textSize:(CGFloat)textSize
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect bounds = self.contentView.bounds;
        CGRect messageRect = CGRectMake(bounds.origin.x, bounds.origin.y + 14, bounds.size.width, bounds.size.height);
        
        _timestampLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, 14)];
//        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
        _timestampLabel.textAlignment = NSTextAlignmentCenter;
        _timestampLabel.textColor = [UIColor colorFromHexString:@"8E8E93"];
        _timestampLabel.shadowColor = [UIColor colorFromHexString:@"00000000"];
        _timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        _messageView = [[SkyMessageView alloc]initWithFrame:messageRect outgoing:outgoing textSize:textSize];
        
//        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.image = nil;
        self.imageView.hidden = YES;
        self.textLabel.text = nil;
        self.textLabel.hidden = YES;
        self.detailTextLabel.text = nil;
        self.detailTextLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:_timestampLabel];
        [self.contentView addSubview:_messageView];
    }
    return self;
}

- (void)setOutgoing:(BOOL)outgoing
{
    [_messageView setOutgoing:outgoing];
}

- (void)setMessage:(NSString *)message
{
    [_messageView setMessage:message];
}

- (void)setName:(NSString*)name withIconUrl:(NSString*)iconUrl withOutgoing:(BOOL)outgoing{
    [_messageView setName:name withIconUrl:iconUrl withOutgoing:outgoing];
}

- (void)setTimestamp:(NSDate *)timestamp
{
    if (timestamp != nil) {
        _timestampLabel.text = [NSDateFormatter localizedStringFromDate:timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect bounds = self.contentView.bounds;
//    if (_hasTimestamp) {
//        _timestampLabel.frame = CGRectMake(0, 0, bounds.size.width, 14);
//        bounds.origin.y = 14;
//        _messageView.frame = bounds;
//    } else {
//        _messageView.frame = bounds;
//    }
}

@end
