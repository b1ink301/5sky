//
//  whoau.mm
//  whoau
//
//  Created by b1ink on 2014. 1. 28..
//  Copyright (c) 2014년 __MyCompanyName__. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import "Header.h"
#import "Sky/SkyMessage.h"
#import <objcipc/objcipc.h>

//#define UserDefaultsChangedNotification CFSTR("kr.b1ink.5skyprefs.settingsChanged")

//static CGFloat const MEZoomAnimationScaleFactor = 0.9;

@interface UtilManager() {
    
}
@end

@implementation UtilManager

+ (id)sharedManager {
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:SpringBoardIdentifier]){
        static UtilManager *instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init];
        });
        return instance;
    }
    else{
        return nil;
    }
}

- (void)loadSettings{
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:SpringBoardIdentifier]){
        if(iOS8()){
            CFStringRef appID = CFSTR("kr.b1ink.5skyprefs");
            
            CFPreferencesAppSynchronize(appID);
            CFPropertyListRef keyList = CFPreferencesCopyAppValue(CFSTR("isEnabled"), appID);
            
            if (!keyList) {
                self.isEnabled = YES;
            }
            else{
                self.isEnabled = CFBooleanGetValue(keyList);
            }
            
            if(self.isEnabled){
                
                keyList = CFPreferencesCopyAppValue(CFSTR("isLockEnabled"), appID);
                if (!keyList) {
                    self.isLockEnabled = YES;
                }
                else{
                    self.isLockEnabled = CFBooleanGetValue(keyList);
                }
                
                keyList = CFPreferencesCopyAppValue(CFSTR("isCloseAfterSend"), appID);
                if (!keyList) {
                    self.isCloseAfterSend = YES;
                }
                else{
                    self.isCloseAfterSend = CFBooleanGetValue(keyList);
                }

            }
            else{
                self.isLockEnabled = NO;
                self.isCloseAfterSend = NO;
            }
        }
        else{
            NSString* plist = [NSString stringWithFormat:@"/User/Library/Preferences/kr.b1ink.5skyprefs.plist"];
            NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:plist];
            
            if (settings != nil){
                self.isEnabled = [[settings objectForKey:@"isEnabled"] boolValue];
            }
            else{
                self.isEnabled = YES;
            }
        }
        
        NSLog(@"5sky: %s isEnabled = %@", __FUNCTION__, self.isEnabled?@"YES":@"NO");
    }
}

- (BOOL)dismissSkyController{
    if([[UtilManager sharedManager]CurrentSkyController]!=nil) {
        _isShowHead = NO;
        [[[UtilManager sharedManager]CurrentSkyController] dismiss];
        return YES;
    }
    
    return NO;
}

-(void)presentSkyControllerWithChatId:(NSNumber*)chatId{
    
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:SpringBoardIdentifier]){
        if(_isShowHead==NO){
            _isShowHead = YES;
            
            NSLog(@"5sky: %s", __FUNCTION__);
            
            [[UIApplication sharedApplication] launchApplicationWithIdentifier:KAKAOTALK suspended:YES];
            
            NSDictionary* responseInfoDict = @{@"chatId" : chatId};
            
            [OBJCIPC sendMessageToAppWithIdentifier:KAKAOTALK messageName:KAKAOTALK_REQUEST_TITLE dictionary:responseInfoDict replyHandler:^(NSDictionary *response) {
                NSLog(@"5sky : Received reply from KakaoTalk: %@", response);
                
                NSString* title = [response objectForKey:@"title"];
                
                if(title==nil){
                    title = @"";
                }
                
                NSDictionary *dic = @{@"title":title, @"chatId":chatId};
                
                _CurrentSkyController = [[SkyController alloc] initWithApplication:KAKAOTALK params:dic dismissHandler:^{
                    _CurrentSkyController = nil;
                    _isShowHead = NO;
                }];
                
                [_CurrentSkyController present];
                
            }];
        }
    }
}

-(void)initQuickReply:(NSNumber*)chatid{
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:SpringBoardIdentifier]){
        NSLog(@"5sky : initQuickReply chatid = %@", chatid);
        
        self.chatId = chatid;
        
        if(_CurrentSkyController!=nil) {
            [_CurrentSkyController newBulletinPublished:chatid];
        }
        else{
            [self presentSkyControllerWithChatId:_chatId];
        }
    }
}

+ (NSNumber*)getChatIdWithBBBulletin:(BBBulletin*)bulletin{
        NSData* data = bulletin.context[@"localNotification"];
        UILocalNotification *noti = nil;
        NSNumber* chatid = nil;
        
        if(data)
            noti = (UILocalNotification*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(noti){
            chatid = noti.userInfo[@"cid"];
            NSLog(@"5sky : handleAction UILocalNotification = [%@]", noti);
        }
        
        if(chatid==nil){
            chatid = bulletin.context[@"userInfo"][@"cid"];
            
            if(chatid)
                NSLog(@"5sky : handleAction bulletin.context[userInfo][cid] = [%@]", chatid);
        }
        
        if(chatid==nil){
            chatid = bulletin.context[@"cid"];
            
            if(chatid)
                NSLog(@"5sky : handleAction bulletin.context[cid] = [%@]", chatid);
        }
        
        if(chatid==nil){
            chatid = bulletin.context[@"remoteNotification"][@"cid"];
            
            if(chatid)
                NSLog(@"5sky : handleAction bulletin.context[remoteNotification][cid] = [%@]", chatid);
        }
        
        return chatid;
}

+ (NSMutableDictionary*)paramsInChatRoom:(NSNumber*)chatId{
    NSLog(@"5sky %s", __FUNCTION__);
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    AppNavigationController* appNavigationController = (AppNavigationController*)[NSClassFromString(@"AppNavigationController") defaultController];
    [appNavigationController moveToChats];
    
    Class TalkAppDelegate = NSClassFromString(@"TalkAppDelegate");
    
    id viewController = [[TalkAppDelegate sharedDelegate] currentVisibleController];
    
    if([viewController isKindOfClass:NSClassFromString(@"ChatsViewController")]){
        
        [appNavigationController moveToChatRoomAtID:[chatId longLongValue]];
        
        viewController = [[TalkAppDelegate sharedDelegate] currentVisibleController];
        
        if([viewController isKindOfClass:NSClassFromString(@"ChattingViewController")]){
            ChattingViewController* chattingViewContorller = (ChattingViewController*)viewController;
            
//            [chattingViewContorller updateChatRoom];
            
            Chat *chat = [chattingViewContorller chat];
            
            NSString* displayTitleInChatRoom = [chat displayTitleInChatRoom];
            NSNumber* lastMessageId = [chat lastMessageID];
            ChatMessage* message = [chattingViewContorller getMessageWith:lastMessageId];
            NSNumber* uid = [message userId];
            User* user = [NSClassFromString(@"User") fetchByID:uid];
            NSString* thumbnailURL = [user thumbnailURL];
            
            if(displayTitleInChatRoom==nil){
                displayTitleInChatRoom = @"";
            }
            
            if(thumbnailURL==nil){
                thumbnailURL = @"";
            }
            
            [dic setObject:displayTitleInChatRoom forKey:@"title"];
            [dic setObject:thumbnailURL forKey:@"thumbnailURL"];
            [dic setObject:chatId forKey:@"chatId"];
            
            [chattingViewContorller didReadChat:1];
//            [chattingViewContorller updateChatRoom];
        }
    }
    
    return dic;
}

@end

static BBServer *BulletinBoardServer = nil;
CHDeclareClass(BBServer)
CHClassMethod(0, BBServer *, BBServer, sharedInstance){
    return BulletinBoardServer;
}

CHOptimizedMethod(0, self, id, BBServer, init){
    self = CHSuper(0, BBServer, init);
    if (self) {
        BulletinBoardServer = self;
    }
    return self;
}

CHOptimizedMethod(3, self, void, BBServer, publishBulletin, BBBulletin *, bulletin, destinations, NSInteger, destinations, alwaysToLockScreen, BOOL, alwaysToLockScreen){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    CHSuper(3, BBServer, publishBulletin, bulletin, destinations, destinations, alwaysToLockScreen, alwaysToLockScreen);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        if([[bulletin sectionID] isEqualToString:KAKAOTALK] ) {            
            if([[UtilManager sharedManager]CurrentSkyController]!=nil){
                NSNumber* chatid = [UtilManager getChatIdWithBBBulletin:bulletin];
                
                if(chatid){
                    NSLog(@"5sky : publishBulletin chatid = %@", chatid);
                    
                    [[[UtilManager sharedManager]CurrentSkyController] newBulletinPublished:chatid];
                }
            }
        }
    });
}

CHDeclareClass(SBNotificationCenterController)
//ios7
CHOptimizedMethod(1, self, BOOL, SBNotificationCenterController, handleActionForBulletin, BBBulletin *, bulletin){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    if([[UtilManager sharedManager] isEnabled] && [[bulletin sectionID] isEqualToString:KAKAOTALK]){
        
        NSNumber* chatid = bulletin.context[@"userInfo"][@"cid"];
        
        [[UtilManager sharedManager] initQuickReply:chatid];
        
        return YES;
    }
    else {
        return CHSuper(1, SBNotificationCenterController, handleActionForBulletin, bulletin);
    }
}

//- (BOOL)handleAction:(id)action forBulletin:(id)bulletin withCompletion:(id)completion;// iOS 8
CHOptimizedMethod(3, self, BOOL, SBNotificationCenterController, handleAction, id, action, forBulletin, BBBulletin *, bulletin , withCompletion, id, completion){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    if([[UtilManager sharedManager] isEnabled] && [[bulletin sectionID] isEqualToString:KAKAOTALK]){
        
        NSLog(@"5sky : handleAction bulletin.context - [%@]", bulletin.context);
        
        NSNumber* chatid = [UtilManager getChatIdWithBBBulletin:bulletin];
        
        if(chatid!=nil){
            //            [[UtilManager sharedManager] initQuickReply:[NSNumber numberWithLongLong:76061162113054L]];
            [[UtilManager sharedManager] initQuickReply:chatid];
            
            return YES;
        }
    }
    
    return CHSuper(3, SBNotificationCenterController, handleAction, action, forBulletin, bulletin, withCompletion, completion);
    
}

CHDeclareClass(SBAlert);
CHDeclareClass(SkyAlert);
CHMethod(1, SBAlertView *, SkyAlert, alertDisplayViewWithSize, CGSize, size){
    return [[NSClassFromString(@"SBAlertView") alloc]initWithFrame:(CGRect){CGPointZero, size}];
}

CHDeclareClass(SBBannerContainerViewController)
CHOptimizedMethod(1, self, void, SBBannerContainerViewController, _handleBannerTapGesture, UITapGestureRecognizer *, gestureRecognizer){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    BOOL isRunOrig = YES;
    if([[UtilManager sharedManager] isEnabled]){
        BBBulletin *bulletin = [self _bulletin];
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded && [[bulletin sectionID] isEqualToString:KAKAOTALK]){
            NSNumber* chatid = [UtilManager getChatIdWithBBBulletin:bulletin];
            
            if(chatid){
                [[UtilManager sharedManager] initQuickReply:chatid];
                isRunOrig = NO;
            }
        }
    }
    
    if(isRunOrig) {
        CHSuper(1, SBBannerContainerViewController, _handleBannerTapGesture, gestureRecognizer);
    }
}

CHDeclareClass(SBBannerController)
CHOptimizedMethod(1, self, void, SBBannerController, _handleBannerTapGesture, UITapGestureRecognizer *, gestureRecognizer){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    BOOL isRunOrig = YES;
    if([[UtilManager sharedManager] isEnabled]){
        BBBulletin *bulletin = [self currentBannerContextForSource:(SBBulletinBannerController *)[NSClassFromString(@"SBBulletinBannerController")sharedInstance]].item.pullDownNotification;
        
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded && [[bulletin sectionID] isEqualToString:KAKAOTALK]){
            
            NSNumber* chatid = bulletin.context[@"userInfo"][@"cid"];
            
            if(chatid){
                [[UtilManager sharedManager] initQuickReply:chatid];
                isRunOrig = NO;
            }
        }
    }
    
    if(isRunOrig) {
        CHSuper(1, SBBannerController, _handleBannerTapGesture, gestureRecognizer);
    }
}

static NSString *ApplicationIdentifierToOpen;

CHDeclareClass(SBLockScreenManager)
CHMethod(2, void, SBLockScreenManager, _finishUIUnlockFromSource, NSInteger, source, withOptions, id, options){
    CHSuper(2, SBLockScreenManager, _finishUIUnlockFromSource, source, withOptions, options);
    if (ApplicationIdentifierToOpen != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            
            if([ApplicationIdentifierToOpen hasPrefix:@"Run5sky_"]){
                NSArray* array = [ApplicationIdentifierToOpen componentsSeparatedByString:@"_"];
                
                if(array && [array count]>1){
                    NSString* tmp = [array objectAtIndex:1];
                    NSNumber* chatid = @([tmp longLongValue]);
                    
                    if(chatid){
                        [[UtilManager sharedManager] initQuickReply:chatid];
                    }
                    
                    NSLog(@"5sky : %s ApplicationIdentifierToOpen = %@, %@", __FUNCTION__, ApplicationIdentifierToOpen, chatid);
                }
            }
            else{
                [[UIApplication sharedApplication]launchApplicationWithIdentifier:ApplicationIdentifierToOpen suspended:NO];
            }
            ApplicationIdentifierToOpen = nil;
        });
    }
}

CHMethod(1, void, SBLockScreenManager, sky_unlockAndOpenApplication, NSString *, applicationIdentifier){
    ApplicationIdentifierToOpen = [applicationIdentifier copy];
    [self unlockUIFromSource:0 withOptions:nil];
}

CHDeclareClass(SBLockScreenViewController)
CHMethod(2, void, SBLockScreenViewController, lockScreenView, SBLockScreenView *, view, didEndScrollingOnPage, NSInteger, page){
    CHSuper(2, SBLockScreenViewController, lockScreenView, view, didEndScrollingOnPage, page);
    if (page == 1) {
        ApplicationIdentifierToOpen = nil;
    }
}

CHDeclareClass(SBLockScreenNotificationListController)
CHOptimizedMethod(1, self, void, SBLockScreenNotificationListController, noteUnlockActionChanged, SBLockScreenActionContext*, arg1){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    BOOL isRunOrig = YES;
    
    if([[UtilManager sharedManager] isEnabled]){
        BBBulletin *bulletin = arg1.bulletin;
        if([[bulletin sectionID] isEqualToString:KAKAOTALK]){
            
            NSNumber* chatid = [UtilManager getChatIdWithBBBulletin:bulletin];
            
            if(chatid){
                SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance];
                if (lockscreenManager.isUILocked && [[UtilManager sharedManager] isLockEnabled]==NO){
                    ApplicationIdentifierToOpen = [NSString stringWithFormat:@"Run5sky_%lld", [chatid longLongValue]];
                    NSLog(@"5sky : %s ApplicationIdentifierToOpen = %@", __FUNCTION__, ApplicationIdentifierToOpen);
                }
                else {
                    [[UtilManager sharedManager] initQuickReply:chatid];
                }
                isRunOrig = NO;
            }
        }
    }
    
    if(isRunOrig)
        CHSuper(1, SBLockScreenNotificationListController, noteUnlockActionChanged, arg1);
}

CHOptimizedMethod(1, self, void, SBLockScreenNotificationListController, unlockUIWithActionContext, SBUnlockActionContext *, actionContext){
    NSLog(@"5sky : %s", __FUNCTION__);
    
    BOOL isRunOrig = YES;
    
    if([[UtilManager sharedManager] isEnabled]){
        NSString *bulletinID = actionContext.identifier;
        BBBulletin *bulletin = [[self _listItemContainingBulletinID:bulletinID]bulletinWithID:bulletinID];
        if([[bulletin sectionID] isEqualToString:KAKAOTALK]){
            NSNumber* chatid = [UtilManager getChatIdWithBBBulletin:bulletin];
            if(chatid){
                
                SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance];
                if (lockscreenManager.isUILocked && [[UtilManager sharedManager] isLockEnabled]==NO){
                    ApplicationIdentifierToOpen = [NSString stringWithFormat:@"Run5sky_%lld", [chatid longLongValue]];
                    NSLog(@"5sky : %s ApplicationIdentifierToOpen = %@", __FUNCTION__, ApplicationIdentifierToOpen);
                }
                else {
                    [[UtilManager sharedManager] initQuickReply:chatid];
                }
                
                isRunOrig = NO;
            }
        }
    }
    
    if(isRunOrig)
        CHSuper(1, SBLockScreenNotificationListController, unlockUIWithActionContext, actionContext);
}

CHDeclareClass(UIWindow)
CHOptimizedMethod(1, self, void, UIWindow, sendEvent, UIEvent *, event){
    CHSuper(1, UIWindow, sendEvent, event);
    if ([[UtilManager sharedManager] isLockEnabled] && [[UtilManager sharedManager]CurrentSkyController]!=nil) {
        SBLockScreenManager *lockscreenManager = (SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance];
        if (lockscreenManager.isUILocked) {
            SBBacklightController *backlightController = (SBBacklightController *)[NSClassFromString(@"SBBacklightController")sharedInstance];
            [backlightController resetLockScreenIdleTimerWithDuration:60];
        }
    }
}

//CHOptimizedMethod0(self, void, UIWindow, makeKeyAndVisible){
//    NSLog(@"5sky : UIWindow makeKeyAndVisible");
//    CHSuper0(UIWindow, makeKeyAndVisible);
//    
//    // Create the Chat Head window once, and only when in SpringBoard
//    if (![self isKindOfClass:[MBChatHeadWindow class]] &&
//        [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:SpringBoardIdentifier]){
//        
//        MBChatHeadWindow *messageBoxWindow = [MBChatHeadWindow sharedInstance];
//        
//        if(messageBoxWindow!=nil && [messageBoxWindow.subviews count]==0){
//            messageBoxWindow.windowLevel = 10; //10 1 below UIKeyboard //UIWindowLevelStatusBar;
//            messageBoxWindow.hidden = NO;
//            messageBoxWindow.backgroundColor = [UIColor clearColor];
//        }
//    }
//}

CHDeclareClass(SBUIController)
CHOptimizedMethod(0, self, BOOL, SBUIController, clickedMenuButton){
    if([[UtilManager sharedManager]dismissSkyController]) {
        return YES;
    }
    else {
        return CHSuper(0, SBUIController, clickedMenuButton);
    }
}

CHDeclareClass(SBAlertManager)
CHOptimizedMethod(1, self, void, SBAlertManager, activate, SBAlert *, alert){
    if (![alert isKindOfClass:NSClassFromString(@"SkyAlert")]) {
        [[UtilManager sharedManager]dismissSkyController];
    }
    CHSuper(1, SBAlertManager, activate, alert);
}

CHDeclareClass(SpringBoard);
CHOptimizedMethod(6, self, void, SpringBoard, _openURLCore, NSURL *, url, display, id, display, animating, BOOL, animating, sender, id, sender, additionalActivationFlags, id, flags, activationHandler, id, handler)
{
    [[UtilManager sharedManager]dismissSkyController];
    
    CHSuper(6, SpringBoard, _openURLCore, url, display, display, animating, animating, sender, sender, additionalActivationFlags, flags, activationHandler, handler);
}

CHDeclareClass(SBUnlockActionContext)
CHOptimizedMethod(0, self, BOOL, SBUnlockActionContext, requiresUnlock){
    if([[UtilManager sharedManager] isEnabled]){
        
        SBLockScreenNotificationListController *notificationController = ((SBLockScreenManager *)[NSClassFromString(@"SBLockScreenManager")sharedInstance]).lockScreenViewController._notificationController;
        NSString *bulletinID = self.identifier;
        BBBulletin *bulletin = [[notificationController _listItemContainingBulletinID:bulletinID]bulletinWithID:bulletinID];
        if([[bulletin sectionID] isEqualToString:KAKAOTALK]){
            return NO;
        }
    }
    
    return CHSuper(0, SBUnlockActionContext, requiresUnlock);
}


static void ChangedPrefsExternallyPostedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    NSLog(@"5sky : ChangedPrefsExternallyPostedNotification");
    
    [[UtilManager sharedManager] loadSettings];
}

static TextMessage* textMessage = nil;

CHConstructor // code block that runs immediately upon load
{
    @autoreleasepool{
        
        NSString *applicationIdentifier = [NSBundle mainBundle].bundleIdentifier;
        
        if ([SpringBoardIdentifier isEqualToString:applicationIdentifier]){
            
            NSLog(@"5sky : CHConstructor %@", applicationIdentifier);
            
            [[UIApplication sharedApplication] launchApplicationWithIdentifier:KAKAOTALK suspended:YES];
            [[UtilManager sharedManager] loadSettings];
            
            CHLoadLateClass(BBServer);
            CHHook(0, BBServer, sharedInstance);
            CHHook(0, BBServer, init);
            CHHook(3, BBServer, publishBulletin, destinations, alwaysToLockScreen);
            
            CHLoadLateClass(UIWindow);
//            CHHook(0, UIWindow, makeKeyAndVisible);
            CHHook(1, UIWindow, sendEvent);
            
            CHLoadLateClass(SBNotificationCenterController);
            if(iOS8()){
                CHHook(3, SBNotificationCenterController, handleAction, forBulletin, withCompletion); //io8
                
                CHLoadLateClass(SBBannerContainerViewController);
                CHHook(1, SBBannerContainerViewController, _handleBannerTapGesture); //ios8
            }
            else{
                CHHook(1, SBNotificationCenterController, handleActionForBulletin); // ios7
                
                CHLoadLateClass(SBBannerController);
                CHHook(1, SBBannerController, _handleBannerTapGesture); //ios7
            }
            
            CHLoadLateClass(SBAlert);
            CHRegisterClass(SkyAlert, SBAlert) {
                CHHook(1, SkyAlert, alertDisplayViewWithSize);
            }
            
            CHLoadLateClass(SBUIController);
            CHHook(0, SBUIController, clickedMenuButton);
            CHLoadLateClass(SBAlertManager);
            CHHook(1, SBAlertManager, activate);
            
            CHLoadLateClass(SpringBoard);
            CHHook(6, SpringBoard, _openURLCore, display, animating, sender, additionalActivationFlags, activationHandler);
            
            CHLoadLateClass(SBLockScreenManager);
            CHHook(2, SBLockScreenManager, _finishUIUnlockFromSource, withOptions);
            CHHook(1, SBLockScreenManager, sky_unlockAndOpenApplication);
            CHLoadLateClass(SBLockScreenViewController);
            CHHook(2, SBLockScreenViewController, lockScreenView, didEndScrollingOnPage);
            
            CHLoadLateClass(SBLockScreenNotificationListController);
            CHHook(1, SBLockScreenNotificationListController, unlockUIWithActionContext);
            CHHook(1, SBLockScreenNotificationListController, noteUnlockActionChanged);
            
            CHLoadLateClass(SBUnlockActionContext);
            CHHook(0, SBUnlockActionContext, requiresUnlock);

            
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                            NULL,
                                            ChangedPrefsExternallyPostedNotification,
                                            CFSTR(WHOAU_PREFS_CHANGED),
                                            NULL,
                                            CFNotificationSuspensionBehaviorCoalesce);
            
        }
        else if ([KAKAOTALK isEqualToString:applicationIdentifier]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:KAKAOTALK_MSG_SEND handler:^NSDictionary *(NSDictionary *message) {
                    NSLog(@"5sky KAKAOTALK_MSG_SEND = %@", message);
                    
                    NSString* reply = [message objectForKey:@"reply"];
                    NSNumber* chatId = [message objectForKey:@"chatId"];
                    
                    NSLog(@"5sky : KAKAOTALK_MSG_SEND chatId = %@, reply = %@", chatId, reply);
                    
                    AppNavigationController *appNav = [NSClassFromString(@"AppNavigationController") defaultController];
                    [appNav moveToChats];
                    
                    Class TalkAppDelegate = objc_getClass("TalkAppDelegate");
                    id viewController = [[TalkAppDelegate sharedDelegate] currentVisibleController];
                    if([viewController isKindOfClass:NSClassFromString(@"ChatsViewController")]){
                        [appNav moveToChatRoomAtID:[chatId longLongValue]];
                    }
                    
                    viewController = [[TalkAppDelegate sharedDelegate] currentVisibleController];
                    
                    if([viewController isKindOfClass:NSClassFromString(@"ChattingViewController")]){
                        ChattingViewController* chattingViewContorller = (ChattingViewController*)viewController;
                        [chattingViewContorller sendText:reply];
                        [chattingViewContorller didReadChat:1];
                        
                        NSLog(@"5sky : KAKAOTALK_MSG_SEND sendText");
                    }
                    
                    return message;
                }];
                
                {
                    [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:KAKAOTALK_REQUEST_HOME handler:^NSDictionary *(NSDictionary *message) {
                        NSLog(@"5sky KAKAOTALK_REQUEST_HOME = %@", message);
                        
                        AppNavigationController *appNav = [NSClassFromString(@"AppNavigationController") defaultController];
                        [appNav moveToChats];
                        
                        return message;
                    }];
                }
                
                {
                    [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:KAKAOTALK_REQUEST_TITLE handler:^NSDictionary *(NSDictionary *message) {
                        NSLog(@"5sky KAKAOTALK_REQUEST_TITLE = %@", message);
                        
                        NSNumber* chatId = [message objectForKey:@"chatId"];
                        Chat* chat = [NSClassFromString(@"Chat") fetchByID:chatId];
                        
                        NSString *displayTitleInChatRoom = [chat displayTitleInChatRoom];

                        NSDictionary* responseInfoDict = @{@"chatId" : chatId, @"title" : displayTitleInChatRoom};
                        return responseInfoDict;
                    }];
                }
                
                
                [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:KAKAOTALK_REQUEST_MESSAGES handler:^NSDictionary *(NSDictionary *message) {
                    NSLog(@"5sky KAKAOTALK_REQUEST_MESSAGES = %@", message);
                    
                    NSNumber* chatId = [message objectForKey:@"chatId"];
                    NSString *query = [NSString stringWithFormat:@"select thumbnailUrl, userId, message, readAt, attachment from message where chatid=%@ order by sentAt desc limit 10", chatId];
                    NSArray* data = [(KAOMsgDatabase*)[NSClassFromString(@"KAOMsgDatabase") sharedInstance] findAllRecordsWithQuery:query];
                    
                    NSMutableArray* array = [NSMutableArray array];
                    NSMutableDictionary* users = [NSMutableDictionary dictionary];
                    
                    NSString * thumbnailUrl;
                    NSString * name;
                    for(NSDictionary* dic in data){
                        NSString* msg = [NSClassFromString(@"KAODatabaseCrypto") decryptWithUserId:[dic objectForKey:@"userId"] source:[dic objectForKey:@"message"]];
                        NSNumber* user_id = [dic objectForKey:@"userId"];
                        NSNumber* date = [dic objectForKey:@"readAt"];
                        
                        User* user = [users objectForKey:[user_id stringValue]];
                        if(user==nil){
                            user = [NSClassFromString(@"User") fetchByID:user_id];
                            [users setValue:user forKey:[user_id stringValue]];
                        }
                        
                        thumbnailUrl = [user thumbnailURL];
                        name = [user userName];
                        
                        SkyMessage *message = [[SkyMessage alloc]init];
                        [message setText:msg];
                        [message setOutgoing:[user isMe]];
                        [message setTimestamp:[NSDate dateWithTimeIntervalSinceReferenceDate:[date doubleValue]]];
                        [message setIconUrl:[user isMe]?@"":thumbnailUrl];
                        [message setName:name];
                        
                        [array insertObject:message atIndex:0];
                    }
                    
                    NSDictionary* responseInfoDict = @{@"chatId" : chatId, @"data" : array};
                    
                    return responseInfoDict;
                }];
                
            });
            
            NSLog(@"5sky : Hooked KAKAOTALK load");
        }
    }
}
