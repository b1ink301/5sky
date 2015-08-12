#import "../Header.h"
#import <objcipc/objcipc.h>
#import "SkyMessagesView.h"
#import "SkyMessageCell.h"
#import "NSString+Sky.h"
#import "UIColor+Sky.h"
#import "../SVPullToRefresh/SVPullToRefresh.h"

@interface SkyMessagesView () <UITableViewDataSource, UITableViewDelegate>{
}

@property(retain) id<SkyMessagesViewDelegate> messagesViewDelegate;
@property(assign) CGFloat textSize;

@property(retain) NSString *applicationIdentifier;
@property(retain) NSNumber *chatId;

//@property(retain) NSOperationQueue *operationQueue;

@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation SkyMessagesView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SkyMessagesViewDelegate>)delegate textSize:(CGFloat)textSize
{
    self = [self initWithFrame:frame];
    if (self) {
        _messagesViewDelegate = delegate;
        _textSize = textSize;
//        _operationQueue = [[NSOperationQueue alloc]init];
//        _operationQueue.maxConcurrentOperationCount = 1;
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activityIndicator.hidesWhenStopped = YES;
        [_activityIndicator stopAnimating];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_activityIndicator];
        
//        [self registerClass:[SkyMessageCell class] forCellReuseIdentifier:@"SkyMessageCell-0"];
//        [self registerClass:[SkyMessageCell class] forCellReuseIdentifier:@"SkyMessageCell-1"];
        
    }
    return self;
}

- (void)setApplication:(NSString *)applicationIdentifier user:(NSNumber *)chatid
{
    _applicationIdentifier = applicationIdentifier;
    _chatId = chatid;
}

- (NSString *)displayedContentForMessage:(SkyMessage*)message
{
    NSMutableString *displayedContent = [NSMutableString string];
    NSString *text = message.text;
    id media = message.media;
    if (text.length > 0) {
        [displayedContent appendString:text];
    }
    if (media != nil) {
        if (displayedContent.length > 0) {
            [displayedContent appendString:@"\n"];
        }
        if ([media isKindOfClass:UIImage.class]) {
            [displayedContent appendString:[NSString stringWithFormat:@"[%@]%@", @"PHOTO", @"TAP_TO_VIEW"]];
        } else if ([media isKindOfClass:NSURL.class]) {
            [displayedContent appendString:[NSString stringWithFormat:@"[%@]%@", @"MOVIE",@"TAP_TO_VIEW"]];
        } else {
            [displayedContent appendString:[NSString stringWithFormat:@"%@", media]];
        }
    }
    return displayedContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkyMessage* message = self.messages[indexPath.row];
    
    NSString *cellReuseIdentifier = [NSString stringWithFormat:@"SkyMessageCell-%d", message.outgoing];
    SkyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[SkyMessageCell alloc]initWithReuseIdentifier:cellReuseIdentifier outgoing:message.outgoing textSize:_textSize];
    }
    
    [cell setName:message.name withIconUrl:message.iconUrl withOutgoing:message.outgoing];
//    [cell setMessage:[self displayedContentForMessage:message]];
    [cell setMessage:message.text];
    [cell setTimestamp:message.timestamp];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkyMessage* message = _messages[indexPath.row];
    
    if(message.height>0){
        return message.height;
    }
    
    CGFloat height = [message.text messageCellHeightWithWidth:message.outgoing==NO?215-ICON_WIDTH-10:215 fontSize:_textSize];
    if (message.timestamp != nil) {
        height += 16;
    }
    
    if(message.outgoing==NO)
        height += 22;
    
    message.height = height;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_messagesViewDelegate messagesView:self didSelectMessage:_messages[indexPath.row]];
}

- (void)clear{
    [_messages removeAllObjects];
    [self reloadData];
}

- (void)requestData{
    NSDictionary* responseInfoDict = @{@"chatId" : _chatId, @"isDelay" : @"1"};
    
    [OBJCIPC sendMessageToAppWithIdentifier:KAKAOTALK messageName:KAKAOTALK_REQUEST_MESSAGES dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
        NSLog(@"whoau : Received reply from KakaoTalk(KAKAOTALK_REQUEST_PHOTO_URL): %@", response);
        
        [_messages removeAllObjects];
        _messages = [response objectForKey:@"data"];
        
//        [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self reloadData];
        
        [self scrollToBottomAnimated:NO];
        [_activityIndicator stopAnimating];
        [self.pullToRefreshView stopAnimating];    
    }];
}

- (NSString*)lastThumbnailUrl{
    NSLog(@"%s ",__FUNCTION__);
    
    NSString* url = nil;
    NSInteger count = [_messages count] - 1;
    
    while (YES) {
        
        if(count<0){
            break;
        }
        
        SkyMessage* item = [_messages objectAtIndex:count];
        
        if([item outgoing]==NO){
            url = [item iconUrl];
            break;
        }
        
        count--;
    }
    
    if(url==nil)
        url = @"";
    
    return url;
}

- (void)addText:(NSString*)text{    
    NSString* name = nil;
    for(SkyMessage *tmp in _messages){
        if([tmp outgoing]){
            name = [tmp name];
            break;
        }
    }
    
    NSInteger count = [_messages count];
    
    SkyMessage *item = [[SkyMessage alloc]init];
    item.text = text;
    item.name = name;
    item.outgoing = YES;
    item.timestamp = [NSDate date];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:count inSection:0];
    
    [self beginUpdates];
    [_messages addObject:item];
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
    
    [self scrollToBottomAnimated:YES];
}

- (void)refreshData{
    NSLog(@"%s ",__FUNCTION__);
    
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:KAKAOTALK suspended:YES];
    
    [self performSelector:@selector(requestData) withObject:nil afterDelay:0.2];
}

- (void)scrollToBottomAnimated:(BOOL)animated{
    NSInteger rows = [self numberOfRowsInSection:0];
    if(rows > 0) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

@end
