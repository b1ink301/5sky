#import <UIKit/UIKit.h>

@interface SkyMessageView : UIView

- (instancetype)initWithFrame:(CGRect)frame outgoing:(BOOL)outgoing textSize:(CGFloat)textSize;
- (void)setOutgoing:(BOOL)outgoing;
- (void)setMessage:(NSString *)message;
- (void)setName:(NSString*)name withIconUrl:(NSString*)iconUrl withOutgoing:(BOOL)outgoing;

@end
