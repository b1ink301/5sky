#import <UIKit/UIKit.h>
#import "Headers.h"

@interface SkyController : UIViewController<SBAlertManagerDelegate>

- (instancetype)initWithApplication:(NSString *)applicationIdentifier params:(NSDictionary *)params dismissHandler:(void (^)(void))dismissHandler;
- (void)present;
- (void)dismiss;
- (void)newBulletinPublished:chatid;
- (NSString*)lastThumbnailUrl;

@end
