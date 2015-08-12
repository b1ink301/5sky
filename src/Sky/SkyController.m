#import "../Header.h"
#import "../SVPullToRefresh/SVPullToRefresh.h"
#import "SkyController.h"
#import "UIView+Sky.h"
#import "UIScreen+Sky.h"
#import "SkyMessagesView.h"
#import <objcipc/objcipc.h>
#import "CALayer+Sky.h"
#import "SkyFieldView.h"
#import "SkyImageViewerController.h"

@interface SkyController () <UITextViewDelegate, SkyMessagesViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SBAlertManagerDelegate>

@property(retain) NSString *applicationIdentifier;
@property(retain) NSString *appTitle;
@property(retain) NSNumber *chatId;
@property(assign) CGFloat textSize;
//@property(assign) UIInterfaceOrientation orientation;

@property(copy) void (^dismissHandler)(void);

@property(strong, nonatomic) UIView *shadowView;
@property(strong, nonatomic) CALayer *borderLayer;
@property(strong, nonatomic) CALayer *shadowLayer;
@property(strong, nonatomic) UIView *mainView;
@property(strong, nonatomic) UIView *topbarView;
@property(strong, nonatomic) UIView *bottombarView;
@property(strong, nonatomic) SkyMessagesView *messagesView;

@property(strong, nonatomic) UIButton *applicationButton;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UIButton *closeButton;
@property(strong, nonatomic) UIButton *cancelButton;

@property(strong, nonatomic) SkyFieldView *fieldView;
@property(strong, nonatomic) UIButton *sendButton;
@property(strong, nonatomic) UIButton *photoButton;
@property(strong, nonatomic) UIActionSheet *photoActionSheet;
@property(strong, nonatomic) UIImagePickerController *photoPicker;
@property(strong, nonatomic) UIPopoverController *photoPickerPopover;
@property(retain) id mediaMessageContent;

@property(strong, nonatomic) SkyImageViewerController *imageViewer;

@property(strong, nonatomic) SkyAlert *alert;
@property(strong, nonatomic) UIViewController *presentedController;

@property(strong, nonatomic) SBAlertManager *alertManager;

@end

@implementation SkyController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"%s",__FUNCTION__);
    // Return YES for supported orientations
    return YES;
}

-(BOOL)shouldAutorotate{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    NSLog(@"%s",__FUNCTION__);
//    return UIInterfaceOrientationLandscapeLeft|UIDeviceOrientationPortrait;
//}

-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"%s",__FUNCTION__);
    
//    [UIViewController attemptRotationToDeviceOrientation];
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
    
    [self showMessagesView:NO];
}

- (instancetype)initWithApplication:(NSString *)applicationIdentifier params:(NSDictionary *)params dismissHandler:(void (^)(void))dismissHandler
{
    NSLog(@"%s",__FUNCTION__);
    
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _applicationIdentifier = applicationIdentifier;
        _textSize = _textSize >= 14 ? _textSize : 14;
        _dismissHandler = dismissHandler;
        
        _appTitle = [params objectForKey:@"title"];
        _chatId = [params objectForKey:@"chatId"];
    }
    return self;
}

- (SBAlertManager *)sharedAlertManager
{
    NSLog(@"%s",__FUNCTION__);
//    static SBAlertManager *alertManager;
    
    if (_alertManager == nil) {

        if (iOS8()) {
            _alertManager = [[NSClassFromString(@"SBAlertManager") alloc]initWithScreen:[UIScreen mainScreen] delegate:self];
        }
        else {
            _alertManager = [[NSClassFromString(@"SBAlertManager") alloc]initWithScreen:[UIScreen mainScreen]];
        }
    }
    return _alertManager;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"%s", __FUNCTION__);
    
    [self loadView];
}

- (void)loadView{
    NSLog(@"%s",__FUNCTION__);
    
    _shadowView = [[UIView alloc]initWithFrame:CGRectZero];
    _shadowView.layer.anchorPoint = CGPointMake(0.5, 0);
    _shadowView.layer.position = CGPointMake([UIScreen mainScreen].viewFrame.size.width/2, -300);
    _shadowView.layer.bounds = (CGRect){CGPointZero, CGSizeMake(300, 250)};
    _borderLayer = [CALayer borderLayerWithSize:CGSizeMake(300, 250) cornerRadius:4];
    _shadowLayer = [CALayer shadowLayerWithSize:CGSizeMake(300, 250) cornerRadius:4];
    _mainView = [UIView mainViewWithFrame:CGRectMake(0, 0, 300, 250) cornerRadius:4];
    _topbarView = [UIView topbarViewViewWithFrame:CGRectMake(0, 0, 300, 44)];
    _bottombarView = [UIView bottombarViewWithFrame:CGRectMake(0, 210, 300, 40)];
    _messagesView = [[SkyMessagesView alloc]initWithFrame:CGRectMake(0, 44, 300, 166) delegate:self textSize:_textSize];
    [_messagesView setApplication:_applicationIdentifier user:_chatId];
    
    __weak SkyMessagesView *weakSelf = _messagesView;
    [_messagesView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    } position:SVPullToRefreshPositionBottom];

    _applicationButton = [UIView buttonWithApplicationIcon:_applicationIdentifier];
    _applicationButton.frame = CGRectMake(7, 7, 30, 30);
    _applicationButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [_applicationButton addTarget:self action:@selector(applicationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    {
	    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
	    lpgr.minimumPressDuration = 1.0; //seconds
    	[_applicationButton addGestureRecognizer:lpgr];
    }
    
    _titleLabel = [UIView titleLabelWithTitle:_appTitle];
    _titleLabel.frame = CGRectMake(74, 7, 152, 30);
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.6;
    _closeButton = [UIView buttonWithTitle:@"닫기"];
    _closeButton.frame = CGRectMake(240, 7, 60, 30);
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    _fieldView = [[SkyFieldView alloc]initWithFrame:CGRectMake(6, 0, 229, 40) delegate:self];
    _sendButton = [UIView sendButtonWithTitle:@"보내기"];
    _sendButton.frame = CGRectMake(235, 8, 59, 26);
    _sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];

//    if(NO){
//        _imageViewer = [[SkyImageViewerController alloc]init];
//    	_photoButton = [UIView photoButton];
//    	_photoButton.frame = CGRectMake(6, 8, 26, 27);
//    	_photoButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
//    	[_photoButton addTarget:self action:@selector(photoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    	[_bottombarView addSubview:_photoButton];
//    }
    
    [_topbarView addSubview:_applicationButton];
    [_topbarView addSubview:_closeButton];
    [_topbarView addSubview:_titleLabel];
    [_bottombarView addSubview:_fieldView];
    [_bottombarView addSubview:_sendButton];
    [_mainView addSubview:_messagesView];
    [_mainView addSubview:_topbarView];
    [_mainView addSubview:_bottombarView];
    [_shadowLayer addSublayer:_borderLayer];
    [_shadowView.layer addSublayer:_shadowLayer];
    [_shadowView addSubview:_mainView];

    self.view = [[UIView alloc]initWithFrame:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? [UIScreen mainScreen].bounds : [UIScreen mainScreen].viewFrame];
    
    [self.view addSubview:_shadowView];
}

- (NSString*)lastThumbnailUrl{
    return [_messagesView lastThumbnailUrl];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    NSLog(@"%s",__FUNCTION__);

    [_applicationButton removeGestureRecognizer:gestureRecognizer];
    
//    notify_post(WHOAU_NOTICE_SHOW_ICON);
    
    [self dismiss];
}

-(BOOL)enabledForOrientation:(UIInterfaceOrientation)orientation {
    NSLog(@"%s",__FUNCTION__);
    
    return YES;
}

- (void)present{
    NSLog(@"%s",__FUNCTION__);
    
    BOOL isLocked = NO;
    
//    UIInterfaceOrientation orientation = [UIScreen mainScreen].frontMostAppOrientation;
//    [[UIApplication sharedApplication] setStatusBarOrientation:orientation];
    
    SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance];
    if (lockscreenManager.isUILocked) {
        SBLockScreenViewController *lockscreenViewController = lockscreenManager.lockScreenViewController;
        [lockscreenViewController setPasscodeLockVisible:NO animated:NO completion:NULL];
        isLocked = YES;
    }
    
//    SBOrientationLockManager* orientationLockManager = [NSClassFromString(@"SBOrientationLockManager")sharedInstance];
//    
//    [orientationLockManager setLockOverrideEnabled:YES forReason:SkyIdentifier];
//    [orientationLockManager updateLockOverrideForCurrentDeviceOrientation];
    
    SBAlertManager *alertManager = [self sharedAlertManager];
    
    for (SBAlert *alert in alertManager.allAlerts) {
        if ([alert isKindOfClass:NSClassFromString(@"SkyAlert")]) {
            [alertManager deactivate:alert];
            break;
        }
    }
    _alert = [[NSClassFromString(@"SkyAlert") alloc] init];
    
    [_alert setOrientationChangedEventsEnabled:YES];
    
//    [_alert didRotateFromInterfaceOrientation:[UIScreen mainScreen].frontMostAppOrientation];
    
    [alertManager activate:_alert];
    
    if(iOS8()){
        alertManager.alertWindow.windowLevel = UIWindowLevelAlert-1.0f;
//        alertManager.alertWindow.screen = [UIScreen mainScreen];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillHideNotification object:nil];
    
    [_alert.display addSubview:self.view];
    
    [self performSelector:@selector(keyboardFrameChanged:) withObject:nil afterDelay:0.1];
}

- (void)dismiss{
    NSLog(@"%s",__FUNCTION__);
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        [self.messagesView clear];
        
        if (_dismissHandler != nil) {
            _dismissHandler();
        }
        
        SBAlertManager *alertManager = [self sharedAlertManager];
        for (SBAlert *alert in alertManager.allAlerts) {
            if ([alert isKindOfClass:NSClassFromString(@"SkyAlert")]) {
                [alertManager deactivate:alert];
                break;
            }
        }
        
        [_alert clearDisplay];
        [_alert dismissAlert];
        _alert = nil;
        _alertManager = nil;
        
//        [(SBOrientationLockManager *)[NSClassFromString(@"SBOrientationLockManager")sharedInstance]setLockOverrideEnabled:NO forReason:SkyIdentifier];

        SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance];
        if (lockscreenManager.isUILocked) {
            SBBacklightController *backlightController = (SBBacklightController *)[NSClassFromString(@"SBBacklightController")sharedInstance];
            [backlightController resetLockScreenIdleTimerWithDuration:10];
        }
        
//        NSDictionary* responseInfoDict = @{@"chatId" : _chatId};
//        
//        [OBJCIPC sendMessageToAppWithIdentifier:KAKAOTALK messageName:KAKAOTALK_REQUEST_HOME dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
//            NSLog(@"whoau : Received reply from KakaoTalk(KAKAOTALK_REQUEST_HOME): %@", response);
//        }];
    }];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    NSLog(@"%s",__FUNCTION__);
//    [super viewDidAppear:animated];
//    
//    [self showMessagesView:NO];
//}

- (void)showMessagesView:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    
    [_fieldView.textView becomeFirstResponder];
    [_messagesView refreshData];
    [self SkyMarkRead:_applicationIdentifier chatId:_chatId];
}

-(void)SkyMarkRead:(NSString *)application chatId:(NSNumber *)chatId{
    if (chatId == nil/* || _bulletins.count == 0*/) {
        return;
    }

    BBServer *bbServer = (BBServer *)[NSClassFromString(@"BBServer")sharedInstance];
    NSSet *bulletinsSet = [bbServer _allBulletinsForSectionID:application];
    NSMutableArray *readBulletins = [NSMutableArray array];
    for (BBBulletin *bulletin in bulletinsSet) {
        if ([_chatId isEqualToNumber:chatId]) {
            [readBulletins addObject:bulletin];
        }
    }
    
    {
        SBAwayBulletinListController *awayBulletinController = [NSClassFromString(@"SBAwayController")sharedAwayController].awayView.bulletinController;
        LIBulletinListController *lockinfoBulletinListController = ((LIController *)[NSClassFromString(@"LIController")sharedInstance]).widgetController.bulletinController;
        
        for (BBBulletin *bulletin in readBulletins) {
            [bbServer removeBulletinID:bulletin.bulletinID fromSection:bulletin.sectionID inFeed:0xFF];
            [awayBulletinController observer:nil removeBulletin:bulletin];
            [lockinfoBulletinListController observer:nil removeBulletin:bulletin];
        }
    }
    
    {
        SBIconModel * const iconModel = CHIvar([NSClassFromString(@"SBIconController")sharedInstance], _iconModel, SBIconModel * const);
        SBApplicationIcon *applicationIcon;
        
        if(iOS8()){
            applicationIcon = [iconModel applicationIconForBundleIdentifier:application];
        }
        else{
            applicationIcon = [iconModel applicationIconForDisplayIdentifier:application];
        }
        
        NSInteger unreadCount = applicationIcon.badgeValue - readBulletins.count;
//        NSInteger unreadCount = applicationIcon.badgeValue - 1;
        if (unreadCount < 0) { unreadCount = 0; }
        [applicationIcon setBadge:unreadCount > 0 ? @(unreadCount).stringValue : @""];
    }
    
    [readBulletins removeAllObjects];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    NSLog(@"%s",__FUNCTION__);
    if (viewControllerToPresent == nil) {
        return;
    }
    [self.view endEditing:YES];
    _presentedController = viewControllerToPresent;
    CGRect startFrame = [UIScreen mainScreen].viewFrame, endFrame = startFrame;
    startFrame.origin.y += endFrame.size.height;
    if (flag) {
        viewControllerToPresent.view.frame = startFrame;
        [viewControllerToPresent viewWillAppear:YES];
        [self.view addSubview:viewControllerToPresent.view];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewControllerToPresent.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [viewControllerToPresent viewDidAppear:YES];
            if (completion) {
                completion();
            }
        }];
    } else {
        viewControllerToPresent.view.frame = endFrame;
        [viewControllerToPresent viewWillAppear:NO];
        [self.view addSubview:viewControllerToPresent.view];
        [viewControllerToPresent viewDidAppear:NO];
        if (completion) {
            completion();
        }
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    NSLog(@"%s",__FUNCTION__);
    if (_presentedController == nil) {
        return;
    }
    CGRect startFrame = [UIScreen mainScreen].viewFrame, endFrame = startFrame;
    endFrame.origin.y += startFrame.size.height;
    if (flag) {
        _presentedController.view.frame = startFrame;
        [_presentedController viewWillDisappear:YES];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _presentedController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [_presentedController.view removeFromSuperview];
            [_presentedController viewDidDisappear:YES];
            _presentedController = nil;
            if (completion) {
                completion();
            }
        }];
    } else {
        [_presentedController viewWillDisappear:NO];
        [_presentedController.view removeFromSuperview];
        [_presentedController viewDidDisappear:NO];
        _presentedController = nil;
        if (completion) {
            completion();
        }
    }
}

- (void)keyboardFrameChanged:(NSNotification *)notification{
    NSLog(@"%s",__FUNCTION__);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(keyboardFrameChanged:) object:nil];    
    UIInterfaceOrientation orientation = [UIScreen mainScreen].frontMostAppOrientation;
    
    NSLog(@"5sky %s UIInterfaceOrientation = %ld",__FUNCTION__, (long)orientation);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
//            [UIView animateWithDuration:.5 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(orientation == UIInterfaceOrientationLandscapeLeft ? -M_PI_2 : M_PI_2);
            
//            }];
        }
        else{
//            [UIView animateWithDuration:.5 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0.0);
//            }];
            
        }
        
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.frame = [UIScreen mainScreen].viewFrame;
    }
    
    CGFloat xMargin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10 : 100;
    CGFloat yMargin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10 : 50;
    CGFloat topMargin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(orientation)) ? 0 : 10;
    CGSize viewSize = [UIScreen mainScreen].viewFrame.size;
    CGSize keyboardSize = notification ? [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].size : CGSizeZero;
    CGFloat keyboardHeight = [notification.name isEqualToString:UIKeyboardWillHideNotification] ? 0 : (UIInterfaceOrientationIsPortrait(orientation) ? keyboardSize.height : keyboardSize.width);
    CGFloat width = viewSize.width - xMargin * 2;
    CGFloat height = viewSize.height - yMargin * 2 - topMargin - keyboardHeight;
    CGRect startFrame;
    if (_shadowView.frame.origin.y == yMargin + topMargin) {
        startFrame = _shadowView.frame;
    } else {
        startFrame = CGRectMake(xMargin, - (height + topMargin), width, height);
    }
    CGRect endFrame = CGRectMake(xMargin, yMargin + topMargin, width, height);
    CGRect startBounds = {CGPointZero, startFrame.size};
    CGRect endBounds = {CGPointZero, endFrame.size};
    CGPathRef startPath = [UIBezierPath bezierPathWithRoundedRect:startBounds cornerRadius:4].CGPath;
    CGPathRef endPath = [UIBezierPath bezierPathWithRoundedRect:endBounds cornerRadius:4].CGPath;

    _shadowView.frame = startFrame;
    _borderLayer.shadowPath = startPath;
    _shadowLayer.shadowPath = startPath;

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shadowView.frame = endFrame;
    } completion:^(BOOL finished) {
        [_messagesView scrollToBottomAnimated:NO];
//        [_contactsView scrollToTopAnimated:YES];
    }];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnimation.fromValue = (__bridge id)startPath;
    shadowAnimation.toValue = (__bridge id)endPath;
    [_borderLayer addAnimation:shadowAnimation forKey:nil];
    [_shadowLayer addAnimation:shadowAnimation forKey:nil];
    [CATransaction commit];
    _borderLayer.shadowPath = endPath;
    _shadowLayer.shadowPath = endPath;
}

- (void)newBulletinPublished:chatid{
    NSLog(@"%s",__FUNCTION__);
    if ([chatid isEqualToNumber:_chatId]) {
        [self reload];
    }
}

- (void)reload{
    [_messagesView refreshData];
    [self SkyMarkRead:_applicationIdentifier chatId:_chatId];
}

- (void)messagesView:(SkyMessagesView *)messagesView didSelectMessage:(SkyMessage*)message
{
//    id media = message.media;
//    if ([media isKindOfClass:UIImage.class]) {
//        [_fieldView.textView endEditing:YES];
//        [_imageViewer viewImage:media inView:self.view];
//    } else if ([media isKindOfClass:NSURL.class]) {
//        SkyMoviePlayerController *moviePlayer = [[SkyaMoviePlayerController alloc]initWithContentURL:media];
//        [moviePlayer playInView:self.view];
//    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%s",__FUNCTION__);
    CGFloat mainHeight = _mainView.bounds.size.height;
    CGFloat maxViewHeight = mainHeight - _topbarView.bounds.size.height;
    CGFloat textHeight = textView.contentSize.height;
    CGFloat viewHeight = MAX(40, MIN(textHeight + 4, maxViewHeight));

    textView.scrollEnabled = (viewHeight == maxViewHeight);
    CGRect startFrame = _bottombarView.frame, endFrame = startFrame;
    endFrame.origin.y = mainHeight - viewHeight;
    endFrame.size.height = viewHeight;
    UIEdgeInsets startInset = _messagesView.contentInset, endInset = startInset;
    endInset.bottom += endFrame.size.height - startFrame.size.height;
    CGPoint startOffset = _messagesView.contentOffset, endOffset = startOffset;
    endOffset.y += endFrame.size.height - startFrame.size.height;
    endOffset.y = MAX(endOffset.y, 0.0f);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _bottombarView.frame = endFrame;
        _messagesView.contentInset = endInset;
        _messagesView.scrollIndicatorInsets = endInset;
        _messagesView.contentOffset = endOffset;
    } completion:NULL];
}

- (void)applicationButtonAction:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    [self dismiss];
    
    [self SkyOpenApp:_applicationIdentifier];
}

- (void)closeButtonAction:(UIButton *)button
{
    NSLog(@"%s",__FUNCTION__);
    [self dismiss];
}

- (void)photoButtonAction:(UIButton *)button
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [_fieldView.textView endEditing:YES];
    }
    _photoActionSheet = [[UIActionSheet alloc]init];
    _photoActionSheet.delegate = self;
    if (_mediaMessageContent == nil) {
        _photoActionSheet.tag = 0;
        [_photoActionSheet addButtonWithTitle:@"CAMERA"];
        [_photoActionSheet addButtonWithTitle:@"LIBRARY"];
    } else {
        _photoActionSheet.tag = 1;
        [_photoActionSheet addButtonWithTitle:@"VIEW"];
        [_photoActionSheet addButtonWithTitle:@"REMOVE"];
    }
    _photoActionSheet.cancelButtonIndex = [_photoActionSheet addButtonWithTitle:@"CANCEL"];
    [_photoActionSheet showFromRect:[button convertRect:button.bounds toView:self.view] inView:self.view animated:YES];
    _photoPicker = [[UIImagePickerController alloc]init];
    _photoPicker.delegate = self;
    NSMutableArray *mediaTypes = [NSMutableArray array];
    
//    if (SkyCanSendPhoto(_applicationIdentifier)) { [mediaTypes addObject:(NSString *)kUTTypeImage]; }
//    if (SkyCanSendMovie(_applicationIdentifier)) { [mediaTypes addObject:(NSString *)kUTTypeMovie]; }
    
//    [mediaTypes addObject:(NSString *)kUTTypeImage];
    
    _photoPicker.mediaTypes = mediaTypes;
    _photoPicker.allowsEditing = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _photoPickerPopover = [[UIPopoverController alloc]initWithContentViewController:_photoPicker];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 0:
            switch (buttonIndex) {
                case 0: {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        _photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                            [self presentViewController:_photoPicker animated:YES completion:NULL];
                        } else {
                            [_photoPickerPopover presentPopoverFromRect:[_photoButton convertRect:_photoButton.bounds toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                        }
                    } else {
                        [[[UIAlertView alloc]initWithTitle:nil message:@"CAMERA_NOT_AVAILABLE" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                    }
                    break;
                }
                case 1: {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        _photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                            [self presentViewController:_photoPicker animated:YES completion:NULL];
                        } else {
                            [_photoPickerPopover presentPopoverFromRect:[_photoButton convertRect:_photoButton.bounds toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                        }
                    } else {
                        [[[UIAlertView alloc]initWithTitle:nil message:@"LIBRARY_NOT_AVAILABLE" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (buttonIndex) {
                case 0: {
                    if ([_mediaMessageContent isKindOfClass:UIImage.class]) {
                        [_fieldView.textView endEditing:YES];
                        [_imageViewer viewImage:_mediaMessageContent inView:self.view];
                    } else if ([_mediaMessageContent isKindOfClass:NSURL.class]) {
//                        SkyMoviePlayerController *moviePlayer = [[SkyMoviePlayerController alloc]initWithContentURL:_mediaMessageContent];
//                        [moviePlayer playInView:self.view];
                    }
                    break;
                }
                case 1: {
                    _mediaMessageContent = nil;
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    if ([info[UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeImage]) {
//        _mediaMessageContent = info[UIImagePickerControllerOriginalImage];
//    } else if ([info[UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeMovie]) {
//        _mediaMessageContent = info[UIImagePickerControllerMediaURL];
//    }
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self dismissViewControllerAnimated:YES completion:NULL];
//    } else {
//        [_photoPickerPopover dismissPopoverAnimated:YES];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [_photoPickerPopover dismissPopoverAnimated:YES];
    }
}

- (void)sendButtonAction:(UIButton *)button{
    NSString *text = _fieldView.textView.text;
    if (text.length == 0) {
        return;
    }
    
    self.fieldView.textView.text = @"";
    [self.fieldView.textView simpleScrollToCaret];
    
    NSDictionary* responseInfoDict = @{@"reply" : text, @"chatId" : _chatId};
    
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:KAKAOTALK suspended:YES];
    [OBJCIPC sendMessageToAppWithIdentifier:KAKAOTALK messageName:KAKAOTALK_MSG_SEND dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
        NSLog(@"5sky : Received reply from KakaoTalk: %@", response);
        
        [_messagesView addText:text];
        
        if([[UtilManager sharedManager] isCloseAfterSend]){
            [self dismiss];
        }
    }];    
}

-(void)SkyOpenApp:(NSString *)application{    
    SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager") sharedInstance];
    if (lockscreenManager.isUILocked) {
        [lockscreenManager sky_unlockAndOpenApplication:application];
    } else {
        [[UIApplication sharedApplication]launchApplicationWithIdentifier:application suspended:NO];
    }
}

- (double)sceneLevelForAlerts{
    NSLog(@"5sky : %s", __FUNCTION__);
    return UIWindowLevelAlert;
}

+ (double)sceneLevelForAlerts{
    return UIWindowLevelAlert;
}

- (CGRect)sceneFrameForAlerts:(UIScreen*)screen{
    NSLog(@"5sky : %s", __FUNCTION__);
    
    return [screen bounds];
}

+ (CGRect)sceneFrameForAlerts:(UIScreen*)screen{
    NSLog(@"5sky : %s %@", __FUNCTION__, screen);

//    UIInterfaceOrientation orientation = [UIScreen mainScreen].frontMostAppOrientation;
//    
//    NSLog(@"%s UIInterfaceOrientation = %d",__FUNCTION__, orientation);
//    
//    CGRect bounds = screen.bounds;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(orientation)) {
//        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
//    }
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        bounds = [UIScreen mainScreen].viewFrame;
//    }
    
    return [screen bounds];
//    return bounds;
}

@end
