//#import "Headers.h"
#include "SkyMessage.h"
#import <UIKit/UIKit.h>

@protocol SkyMessagesViewDelegate;

@interface SkyMessagesView : UITableView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SkyMessagesViewDelegate>)delegate textSize:(CGFloat)textSize;
- (void)setApplication:(NSString *)applicationIdentifier user:(NSNumber *)userIdentifier;
- (void)refreshData;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (NSString*)lastThumbnailUrl;
- (void)addText:(NSString*)text;
- (void)clear;

@property(retain, nonatomic) NSMutableArray *messages;

@end

@protocol SkyMessagesViewDelegate <NSObject>

- (void)messagesView:(SkyMessagesView *)messagesView didSelectMessage:(SkyMessage*)message;

@end
