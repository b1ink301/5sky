#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SkyMessage : NSObject <NSSecureCoding>

@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *iconUrl;
@property(nonatomic, retain) id media;
@property(nonatomic, assign) BOOL outgoing;
@property(nonatomic, retain) NSDate *timestamp;
@property(nonatomic, assign) CGFloat height;

@end
