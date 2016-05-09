#import <UIKit/UIKit.h>

@interface SkyMessageCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier outgoing:(BOOL)outgoing textSize:(CGFloat)textSize;
- (void)setOutgoing:(BOOL)outgoing;
- (void)setMessage:(NSString *)message;
- (void)setTimestamp:(NSDate *)timestamp;
- (void)setName:(NSString*)name withIconUrl:(NSString*)iconUrl withOutgoing:(BOOL)outgoing;

@end
