#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ICON_WIDTH 38
#define SkyIdentifier @"com.b1ink.5sky"

#define BUNDLE_PATH @"/Library/Application Support/5sky/bundle/5sky.bundle"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_8_0_0
#define kCFCoreFoundationVersionNumber_iOS_8_0_0 1140.10
#endif

#define iOS8() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0_0)

#define NewBulletinPublishedNotification "kr.b1ink.5Sky.NewBulletinPublished"
#define ApplicationsKey @"Applications"
#define BulletinKey @"Bulletin"
#define EnabledKey @"Enabled"
#define TextSizeKey @"TextSize"

#pragma mark - Sky

@class BBBulletin, SkyController;

#pragma mark - SpringBoard

@protocol _SBUIWidgetHost <NSObject>

- (void)invalidatePreferredViewSize;
- (void)requestLaunchOfURL:(NSURL *)url;
- (void)requestPresentationOfViewController:(UIViewController *)viewController presentationStyle:(UIModalPresentationStyle)presentationStyle context:(void *)context completion:(void(^)(void))completion;

@end

@interface _SBUIWidgetViewController : UIViewController <_SBUIWidgetHost>

@property(copy) NSString *widgetIdentifier;
- (CGSize)preferredViewSize;
- (void)invalidatePreferredViewSize;
- (void)hostDidDismiss;
- (void)hostDidPresent;
- (void)hostWillDismiss;
- (void)hostWillPresent;
- (void)requestLaunchOfURL:(NSURL *)url;
- (void)requestPresentationOfViewController:(UIViewController *)viewController presentationStyle:(UIModalPresentationStyle)presentationStyle context:(void *)context completion:(void(^)(void))completion;
@end

@protocol BBWeeAppController <NSObject>
- (UIView *)view;
@optional
- (CGFloat)viewHeight;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)loadPlaceholderView;
- (void)loadFullView;
- (void)unloadView;
- (void)clearShapshotImage;
- (void)loadView;
- (NSURL *)launchURL;
- (NSURL *)launchURLForTapLocation:(CGPoint)tapLocation;
@end

@interface CPDistributedMessagingCenter : NSObject
+ (CPDistributedMessagingCenter*)centerNamed:(NSString*)serverName;
- (id)_initWithServerName:(NSString*)serverName;
- (NSString*)name;
- (unsigned)_sendPort;
- (void)_serverPortInvalidated;
- (BOOL)sendMessageName:(NSString*)name userInfo:(NSDictionary*)info;
- (NSDictionary*)sendMessageAndReceiveReplyName:(NSString*)name userInfo:(NSDictionary*)info;
- (NSDictionary*)sendMessageAndReceiveReplyName:(NSString*)name userInfo:(NSDictionary*)info error:(NSError**)error;
- (void)sendMessageAndReceiveReplyName:(NSString*)name userInfo:(NSDictionary*)info toTarget:(id)target selector:(SEL)selector context:(void*)context;
- (BOOL)_sendMessage:(id)message userInfo:(id)info receiveReply:(id*)reply error:(id*)error toTarget:(id)target selector:(SEL)selector context:(void*)context;
- (BOOL)_sendMessage:(id)message userInfoData:(id)data oolKey:(id)key oolData:(id)data4 receiveReply:(id*)reply error:(id*)error;
- (void)runServerOnCurrentThread;
- (void)runServerOnCurrentThreadProtectedByEntitlement:(id)entitlement;
- (void)stopServer;
- (void)registerForMessageName:(NSString*)messageName target:(id)target selector:(SEL)selector;
- (void)unregisterForMessageName:(NSString*)messageName;
- (void)_dispatchMessageNamed:(id)named userInfo:(id)info reply:(id*)reply auditToken:(id*)token;
- (BOOL)_isTaskEntitled:(id*)entitled;
- (id)_requiredEntitlement;

@end

//@interface BBBulletin : NSObject
//@property(copy, nonatomic) NSString *bulletinID;
//@property(copy, nonatomic) NSString *sectionID;
//@property(copy, nonatomic) NSString *title;
//@property(copy, nonatomic) NSString *subtitle;
//@property(copy, nonatomic) NSString *message;
//@property(retain, nonatomic) NSDictionary *context;
//@end

@class SBAlertView, SBAlertManager, SBActivationContext;

@interface SBAlert : UIViewController
@property(retain, nonatomic) SBAlertManager *alertManager;
@property(assign, nonatomic, getter=_requestedDismissal, setter=_setRequestedDismissal:) BOOL requestedDismissal;
@property(copy, nonatomic) SBActivationContext *activationContext;
@property(nonatomic) _Bool suppressesBanners;
+ (void)registerForAlerts;
- (BOOL)_isLockAlert;
- (void)_removeFromImpersonatedAppIfNecessary;
- (id)_impersonatesApplicationWithBundleID;
- (void)removeFromView;
- (void)alertViewIsReadyToDismiss:(id)dismiss;
- (void)setDisplay:(id)display;
- (void)setAlertDelegate:(id)delegate;
- (id)alertDelegate;
- (BOOL)_shouldDismissSwitcherOnActivation;
- (BOOL)suppressesControlCenter;
- (BOOL)suppressesNotificationCenter;
//- (BOOL)suppressesBanners;

-(BOOL)wantsSupportedInterfaceOrientationsIgnoredDuringDeactivation;
- (void)handleAutoLock;
- (BOOL)handleHeadsetButtonPressed:(BOOL)pressed;
- (BOOL)handleVolumeDownButtonPressed;
- (BOOL)handleVolumeUpButtonPressed;
- (BOOL)handleLockButtonPressed;
- (BOOL)hasTranslucentBackground;
- (BOOL)shouldPendAlertItemsWhileActive;
- (void)handleSlideshowHardwareButton;
- (BOOL)handleMenuButtonHeld;
- (BOOL)handleMenuButtonDoubleTap;
- (BOOL)handleMenuButtonTap;
- (void)animateDeactivation;
- (BOOL)currentlyAnimatingDeactivation;
- (void)didFinishAnimatingOut;
- (void)didFinishAnimatingIn;
- (void)didAnimateLockKeypadOut;
- (void)didAnimateLockKeypadIn;
- (id)legibilitySettings;
- (id)effectiveStatusBarStyleRequest;
- (int)effectiveStatusBarStyle;
- (id)statusBarStyleRequest;
- (int)starkStatusBarStyle;
- (int)statusBarStyle;
- (double)autoLockTime;
- (BOOL)managesOwnStatusBarAtActivation;
- (double)autoDimTime;
- (BOOL)allowsEventOnlySuspension;
- (BOOL)expectsFaceContactInLandscape;
- (BOOL)expectsFaceContact;
- (void)setExpectsFaceContact:(BOOL)contact inLandscape:(BOOL)landscape;
- (void)setExpectsFaceContact:(BOOL)contact;
- (double)accelerometerSampleInterval;
- (void)setAccelerometerSampleInterval:(double)interval;
- (BOOL)orientationChangedEventsEnabled;
- (void)setOrientationChangedEventsEnabled:(BOOL)enabled;
- (id)description;
- (void)deactivate;

- (_Bool)shouldAutorotateToInterfaceOrientation:(long long)arg1;
- (unsigned long long)supportedInterfaceOrientations;
- (long long)interfaceOrientationForActivation;

- (void)activate;
- (int)statusBarStyleOverridesToCancel;
- (void)displayDidDisappear;
- (float)finalAlpha;
- (BOOL)showsSpringBoardStatusBar;
- (BOOL)undimsDisplay;
- (BOOL)allowsStackingOfAlert:(id)alert;
- (void)removeObjectForKey:(id)key;
- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;
- (id)alertDisplayViewWithSize:(CGSize)size;
- (id)deactivationValue:(unsigned)value;
- (BOOL)deactivationFlag:(unsigned)flag;
- (void)setDeactivationSetting:(unsigned)setting value:(id)value;
- (void)setDeactivationSetting:(unsigned)setting flag:(BOOL)flag;
- (void)clearDeactivationSettings;
- (id)activationValue:(unsigned)value;
- (BOOL)activationFlag:(unsigned)flag;
- (void)setActivationSetting:(unsigned)setting value:(id)value;
- (void)setActivationSetting:(unsigned)setting flag:(BOOL)flag;
- (void)clearActivationSettings;
- (void)removeBackgroundStyleWithAnimationFactory:(id)animationFactory;
- (void)setBackgroundStyle:(int)style withAnimationFactory:(id)animationFactory;
- (int)customBackgroundStyle;
- (BOOL)wantsCustomBackgroundStyle;
- (BOOL)isWallpaperTunnelActive;
- (void)setWallpaperTunnelActive:(BOOL)active;
- (BOOL)displayFlag:(unsigned)flag;
- (id)displayValue:(unsigned)value;
- (void)setDisplaySetting:(unsigned)setting value:(id)value;
- (void)setDisplaySetting:(unsigned)setting flag:(BOOL)flag;
- (void)clearDisplaySettings;
- (void)dismissAlert;
- (void)clearDisplay;
- (SBAlertView *)display;
- (void)didRotateFromInterfaceOrientation:(int)interfaceOrientation;
- (void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation duration:(double)duration;
- (void)willRotateToInterfaceOrientation:(int)interfaceOrientation duration:(double)duration;
- (void)didMoveToParentViewController:(id)parentViewController;
- (void)viewDidDisappear:(BOOL)view;
- (void)viewWillDisappear:(BOOL)view;
- (void)viewDidAppear:(BOOL)view;
- (void)viewWillAppear:(BOOL)view;
- (void)loadView;
- (BOOL)wantsFullScreenLayout;
- (id)_screen;
- (void)_setTargetScreen:(id)screen;
- (void)dealloc;
- (id)init;
- (BOOL)isRemote;
- (BOOL)matchesRemoteAlertService:(id)service options:(id)options;
- (id)effectiveViewController;
@end

@interface SkyAlert : SBAlert
@end

@interface SkyIconAlert : SBAlert
@end

@interface SBAlertView : UIView
- (void)alertWindowViewControllerResizedFromContentFrame:(CGRect)contentFrame toContentFrame:(CGRect)contentFrame2;
- (void)setAlert:(id)alert;
- (BOOL)shouldAddClippingViewDuringRotation;
- (void)didRotateFromInterfaceOrientation:(int)interfaceOrientation;
- (void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation duration:(double)duration;
- (void)willRotateToInterfaceOrientation:(int)interfaceOrientation duration:(double)duration;
- (BOOL)isSupportedInterfaceOrientation:(int)orientation;
- (void)layoutForInterfaceOrientation:(int)interfaceOrientation;
- (BOOL)isAnimatingOut;
- (BOOL)shouldAnimateIn;
- (void)setShouldAnimateIn:(BOOL)animateIn;
- (BOOL)isReadyToBeRemovedFromView;
- (void)alertDisplayBecameVisible;
- (void)alertDisplayWillBecomeVisible;
- (void)dismiss;
- (id)alert;
- (id)initWithFrame:(CGRect)frame;
@end

@class SBAlert, SBFAnimationFactory;
@protocol SBAlertDelegate <NSObject>
- (void)alertWantsToForceWallpaperTunnelUpdate:(SBAlert *)arg1;
- (void)alertIsReadyToBeRemovedFromView:(SBAlert *)arg1;
- (void)alertIsReadyToBeDeactivated:(SBAlert *)arg1;
- (void)alertWillDismiss:(SBAlert *)arg1;
- (void)alert:(SBAlert *)arg1 requestsBackgroundStyleChangeWithAnimationFactory:(SBFAnimationFactory *)arg2;
@end

@protocol SBAlertManagerDelegate <NSObject>
-(double)sceneLevelForAlerts;
-(CGRect)sceneFrameForAlerts:(UIScreen *)arg1;;
@optional
-(id)alertManager:(id)manager newAlertWindowForScene:(id)scene;
-(BOOL)alertManager:(id)manager shouldDeactivateDismissedAlert:(id)alert;
@end

@interface SBAlertWindow : UIWindow
+ (double)windowLevel;
@end

@interface SBAlertManager : NSObject
//@property(assign, nonatomic) id delegate;
@property(readonly, nonatomic) SBAlertWindow *alertWindow;
- (void)alertIsReadyToBeRemovedFromView:(id)view;
- (void)alertIsReadyToBeDeactivated:(id)beDeactivated;
- (void)alert:(id)alert requestsBackgroundStyleChangeWithAnimationFactory:(id)animationFactory;
- (void)_makeAlertWindowOpaque:(BOOL)opaque;
- (void)_resetAlertWindowOpacity;
- (void)_removeFromView:(id)view;
- (void)_deactivate:(id)deactivate;
- (void)_activate:(id)activate;
- (void)removeObserver:(id)observer;
- (void)addObserver:(id)observer;
- (id)debugDescription;
- (id)description;
- (void)applicationFinishedAnimatingBeneathAlert;
- (void)applicationWillAnimateActivation;
- (void)deactivateAlertsAfterLaunch;
- (void)setAlertsShouldDeactivateAfterLaunch;
- (void)deactivateAll;
- (void)deactivate:(SBAlert *)deactivate;
- (void)activate:(SBAlert *)activate;
- (NSArray *)allAlerts;
- (BOOL)containsAlert:(id)alert;
- (id)stackedAlertsIncludingActiveAlert:(BOOL)alert;
- (BOOL)hasStackedAlerts;
- (id)activeAlert;
- (id)windows;
- (id)windowForAlert:(id)alert;
- (id)activeAlertWindow;
- (id)topMostWindow;
- (id)screen;
- (void)dealloc;
- (id)init;
- (id)initWithScreen:(UIScreen *)screen;
- (id)initWithScreen:(UIScreen *)screen delegate:(id)delegate;
@property(nonatomic) id <SBAlertManagerDelegate> delegate;
@end

@interface SBOrientationLockManager : NSObject
+ (instancetype)sharedInstance;
- (void)updateLockOverrideForCurrentDeviceOrientation;
- (BOOL)lockOverrideEnabled;
- (void)enableLockOverrideForReason:(NSString *)reason forceOrientation:(UIInterfaceOrientation)orientation;
- (void)enableLockOverrideForReason:(NSString *)reason suggestOrientation:(UIInterfaceOrientation)orientation;
- (void)setLockOverrideEnabled:(BOOL)enabled forReason:(NSString *)reason;
- (UIInterfaceOrientation)userLockOrientation;
- (BOOL)isLocked;
- (void)unlock;
- (void)lock;
@end

@interface SPSearchResult : NSObject
@property(nonatomic) NSUInteger identifier;
@property(retain, nonatomic) NSString *title;
@end

@interface SPSearchResultSection : NSObject
@property(retain, nonatomic) NSString *displayIdentifier;
@property(retain, nonatomic) NSMutableArray *results;
- (SPSearchResult *)resultsAtIndex:(NSUInteger)index;
@end

@interface SPSearchAgent : NSObject
@property(retain, nonatomic) NSArray *searchDomains;
@property(readonly, nonatomic) BOOL queryComplete;
@property(readonly, nonatomic) NSUInteger resultCount;
- (SPSearchResultSection *)sectionAtIndex:(NSUInteger)index;
- (NSString *)queryString;
- (BOOL)setQueryString:(NSString *)queryString;
@end

@interface UIApplication (Private)
- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
@end

//@interface UIAlertView (Private)
//- (void)popupAlertAnimated:(BOOL)animated;
//- (void)dismissAnimated:(BOOL)animated;
//- (UIInterfaceOrientation)_currentOrientation;
//- (void)layout;
//- (void)_layoutPopupAlertWithOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
//- (void)_keyboardDidHide:(NSNotification *)keyboard;
//- (void)_keyboardWillHide:(NSNotification *)keyboard;
//- (void)_keyboardWillShow:(NSNotification *)keyboard;
//- (void)_repopup;
//- (void)_repopupNoAnimation;
//- (BOOL)_needsKeyboard;
//- (BOOL)requiresPortraitOrientation;
//@end

@interface UITextEffectsWindow : UIWindow
+ (UITextEffectsWindow *)sharedTextEffectsWindow;
@end

@interface UIPeripheralHostView : UIView
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface MPKnockoutButton : UIButton
@end

@interface UINavigationButton : UIButton
@property(assign, nonatomic) UIBarButtonItemStyle style;
@end

@interface UIPopoverController (Private)
- (void)_updateDimmingViewTransformForInterfaceOrientationOfHostingWindow:(UIWindow *)hostingWindow;
@end

@interface SBWindowContextHostWrapperView : UIView
@property(nonatomic, strong) UIColor *backgroundColorWhileNotHosting;
@property(nonatomic, strong) UIColor *backgroundColorWhileHosting;
@end

@interface FBWindowContextHostWrapperView : UIView
@property(nonatomic, strong) UIColor *backgroundColorWhileNotHosting;
@property(nonatomic, strong) UIColor *backgroundColorWhileHosting;
@end


@interface FBWindowContextHostView : UIView
@end

@interface FBWindowContextHostManager : NSObject{
    FBWindowContextHostView *_hostView;
}
- (FBWindowContextHostWrapperView *)hostViewForRequester:(NSString *)requester enableAndOrderFront:(BOOL)enableAndOrderFront;
- (void)disableHostingForRequester:(NSString *)requester;
@end

@interface SBWindowContextHostManager : NSObject
- (SBWindowContextHostWrapperView *)hostViewForRequester:(NSString *)requester enableAndOrderFront:(BOOL)enableAndOrderFront;
- (void)disableHostingForRequester:(NSString *)requester;
@end

@interface FBScene : NSObject
//@property(readonly, retain, nonatomic) FBProcess *clientProcess; // @synthesize clientProcess=_clientProcess;
//@property(readonly, retain, nonatomic) FBSSceneClientSettings *clientSettings; // @synthesize clientSettings=_clientSettings;
//@property(readonly, retain, nonatomic) FBSSceneSettings *settings; // @synthesize settings=_settings;
@property(readonly, retain, nonatomic) FBWindowContextHostManager *contextHostManager; // @synthesize contextHostManager=_contextHostManager;
//@property(readonly, retain, nonatomic) FBWindowContextManager *contextManager; // @synthesize contextManager=_contextManager;
//@property(readonly, retain, nonatomic) FBSDisplay *display; // @synthesize display=_display;
@property(readonly, copy, nonatomic) NSString *identifier; // @synthesize identifier=_identifier;
@end

@interface SBApplication : NSObject
- (NSString *)displayName;
- (FBScene*)mainScene;
- (SBWindowContextHostManager *)mainScreenContextHostManager;
@property(readonly, nonatomic) int pid;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)applicationWithDisplayIdentifier:(NSString *)identifier;
- (id)applicationWithBundleIdentifier:(id)bundleIdentifier;
@end

@interface SpringBoard : UIApplication
+ (SpringBoard *)sharedApplication;
- (UIInterfaceOrientation)_frontMostAppOrientation;
- (void)_openURLCore:(NSURL *)url display:(id)display animating:(BOOL)animating sender:(id)sender additionalActivationFlags:(id)flags activationHandler:(id)handler; // iOS 7
- (void)_openURLCore:(NSURL *)url display:(id)display animating:(BOOL)animating sender:(id)sender additionalActivationFlags:(id)flags; // iOS 6
@end

@interface SBBulletinBannerItem : NSObject
- (BBBulletin *)seedBulletin;
@end

@protocol SBUIBannerSource <NSObject>
-(id)newBannerViewForContext:(id)context;
-(id)dequeueNextBannerItemForTarget:(id)target;
-(id)peekNextBannerItemForTarget:(id)target;
@optional
-(void)bannerViewDidDismiss:(id)bannerView forReason:(int)reason;
-(void)bannerViewWillDismiss:(id)bannerView forReason:(int)reason;
-(void)bannerViewDidAppear:(id)bannerView;
-(void)bannerViewWillAppear:(id)bannerView;
@end

@interface SBUIBannerItem : NSObject
- (BBBulletin *)pullDownNotification;
@end

@interface SBUIBannerContext : NSObject
@property(readonly, assign, nonatomic) SBUIBannerItem *item;
@end

@interface SBBannerButtonViewController
-(void)_buttonPressed:(id)arg1;
@end

@interface SBBannerContainerViewController // ios8
- (id)_bulletin;
- (void)_handleBannerTapGesture:(id)arg1;
@end

@interface SBBannerController : NSObject
- (void)_setBannerSticky:(_Bool)arg1;
- (void)bannerViewControllerDidReceiveRaiseGesture:(id)arg1;
- (void)modallyPresentBannerWithContext:(id)context;
- (void)handleSystemDismissGestureWithState:(int)state position:(CGPoint)position velocity:(float)velocity;
- (void)_updateGestureHandlerWithState:(int)state type:(int)type;
- (void)bannerViewController:(SBBannerContainerViewController *)arg1 willSelectActionWithContext:(NSDictionary *)arg2;
- (void)bannerViewControllerDidSelectAction:(SBBannerContainerViewController *)arg1;;
- (void)_handleBannerPanGesture:(id)gesture;
- (void)_handleBannerTapGesture:(UITapGestureRecognizer *)gestureRecognizer;
- (SBBulletinBannerItem *)currentBannerItem; // iOS 6
- (SBUIBannerContext *)currentBannerContextForSource:(id<SBUIBannerSource>)source; // iOS 7
- (void)_presentBannerForContext:(id)arg1 reason:(long long)arg2;
@end

@interface SBBulletinBannerController : NSObject <SBUIBannerSource>
+ (instancetype)sharedInstance;
@end

@interface SBNotificationCenterController : NSObject
- (BOOL)handleActionForBulletin:(BBBulletin *)bulletin;// iOS 7
- (BOOL)handleAction:(id)action forBulletin:(id)bulletin withCompletion:(id)completion;// iOS 8
@end

@interface SBBulletinListController : UIViewController // iOS 6
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (BBBulletin *)_bulletinAtIndexPath:(NSIndexPath *)indexPath;
- (void)positionListViewAtY:(CGFloat)y;
@end

@interface SBAlertItem : NSObject
@end

@interface SBBulletinModalAlert : SBAlertItem {
    BBBulletin *_bulletin;
}
@end

@interface CKAlertItem : SBAlertItem
@end

@interface CKMessageAlertItem : CKAlertItem {
    BBBulletin *_bulletin;
}
@end

@interface SBAlertItemsController : NSObject
- (void)activateAlertItem:(SBAlertItem *)alertItem;
@end

@interface SBBulletinSoundController : NSObject
+ (instancetype)sharedInstance;
- (BOOL)playSoundForBulletin:(BBBulletin *)bulletin;
@end

@interface TPBottomLockBar : UIView
- (void)unlock;
- (void)relock;
- (void)slideBack:(BOOL)animated;
@end

@interface SBBulletinLockBar : TPBottomLockBar
@end

@interface SBAwayListActionContext : NSObject
- (NSString *)bulletinID;
@end

@interface SBAwayBulletinCell : UITableViewCell
- (SBAwayListActionContext *)actionContext;
@end

@interface SBAwayBulletinListItem : NSObject
- (BBBulletin *)bulletinWithID:(NSString *)bulletinID;
@end

@interface SBUnlockActionContext : NSObject
@property(retain, nonatomic) NSString *identifier;
@property(assign, nonatomic) BOOL requiresUnlock;
@end

@interface SBAwayBulletinListController : NSObject
- (SBAwayBulletinListItem *)_listItemContainingBulletinID:(NSString *)bulletinID;
- (void)observer:(id)observer removeBulletin:(BBBulletin *)bulletin;
- (SBAwayListActionContext *)visibleActionContext;
@end

@interface SBAwayView : UIView
- (SBAwayBulletinListController *)bulletinController;
@end

@interface SBLockScreenView : SBAlertView
@end

@interface SBLockScreenNotificationListController : NSObject
- (void)noteUnlockActionChanged:(id)arg1;
- (void)unlockUIWithActionContext:(SBUnlockActionContext *)actionContext;
- (SBAwayBulletinListItem *)_listItemContainingBulletinID:(NSString *)bulletinID;
@end

@interface SBLockScreenViewController : SBAlert
- (SBLockScreenNotificationListController *)_notificationController;
- (void)setPasscodeLockVisible:(BOOL)visible animated:(BOOL)animated completion:(id)completion;
- (void)lockScreenView:(SBLockScreenView *)view didEndScrollingOnPage:(NSInteger)page;
@end

@interface SBLockScreenManager : NSObject // iOS 7
@property(readonly, assign, nonatomic) SBLockScreenViewController *lockScreenViewController;
+ (instancetype)sharedInstance;
- (BOOL)isUILocked;
- (void)unlockUIFromSource:(NSInteger)source withOptions:(id)options;
- (void)_finishUIUnlockFromSource:(NSInteger)source withOptions:(id)options;
@end

@interface SBLockScreenManager (sky)
- (void)sky_unlockAndOpenApplication:(NSString *)applicationIdentifier;
@end

@interface SBBacklightController : NSObject // iOS 7
+ (instancetype)sharedInstance;
- (void)resetLockScreenIdleTimer;
- (void)resetLockScreenIdleTimerWithDuration:(double)duration;
@end

@interface SBAwayController : NSObject // iOS 6
+ (SBAwayController *)sharedAwayController;
- (SBAwayView *)awayView;
- (BOOL)isLocked;
- (void)restartDimTimer;
- (void)restartDimTimer:(float)seconds;
- (void)dimScreen:(BOOL)animated;
- (void)unlockWithSound:(BOOL)sound;
- (void)willAnimateToggleDeviceLockWithStyle:(int)style toVisibility:(BOOL)visibility withDuration:(double)duration;
- (void)_finishUnlockWithSound:(BOOL)sound unlockSource:(int)source isAutoUnlock:(BOOL)autoUnlock;
- (UIView *)awayViewFakeStatusBar;
@end

@interface SBAwayController (sky)
- (void)sky_unlockAndOpenApplication:(NSString *)applicationIdentifier;
@end

@interface SBIconController : NSObject
+ (instancetype)sharedInstance;
- (void)setIsEditing:(BOOL)editing;
- (BOOL)isEditing;
@end

@interface SBUIController : NSObject
+ (instancetype)sharedInstance;
- (BOOL)clickedMenuButton;
- (void)mb_addChatHeadWindowForApp:(NSString *)appName;
- (void)mb_removeChatHeadWindow;
@end

@interface SBStatusBarDataManager : NSObject
+ (instancetype)sharedDataManager;
- (void)resetData;
@end

@interface BBServer : NSObject
+ (instancetype)sharedInstance;
- (NSSet *)_allBulletinsForSectionID:(NSString *)sectionID;
- (void)publishBulletin:(BBBulletin *)bulletin destinations:(int)destinations alwaysToLockScreen:(BOOL)lockScreen;
- (void)removeBulletinID:(NSString *)bulletinID fromListSection:(NSString *)sectionID; // iOS 6
- (void)removeBulletinID:(NSString *)bulletinID fromSection:(NSString *)sectionID inFeed:(unsigned)feed; // iOS 7
@end

@interface BBServer (sky)
+ (instancetype)sharedInstance;
@end

@interface SBIcon : NSObject
- (NSInteger)badgeValue;
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBApplicationIcon : SBLeafIcon
- (void)setBadge:(NSString *)badge;
@end

@interface SBIconModel : NSObject
- (SBApplicationIcon *)applicationIconForDisplayIdentifier:(NSString *)identifier;
- (id)applicationIconForBundleIdentifier:(id)arg1;

@end

//@interface SBIconController : NSObject {
//    SBIconModel *_iconModel;
//}
//+ (instancetype)sharedInstance;
//@end

#pragma mark - Preferences

typedef enum PSCellType {
    PSGroupCell,
    PSLinkCell,
    PSLinkListCell,
    PSListItemCell,
    PSTitleValueCell,
    PSSliderCell,
    PSSwitchCell,
    PSStaticTextCell,
    PSEditTextCell,
    PSSegmentCell,
    PSGiantIconCell,
    PSGiantCell,
    PSSecureEditTextCell,
    PSButtonCell,
    PSEditTextViewCell,
} PSCellType;

@interface PSSpecifier : NSObject {
@public
    id target;
    SEL getter;
    SEL setter;
    SEL action;
    Class detailControllerClass;
    PSCellType cellType;
    Class editPaneClass;
    UIKeyboardType keyboardType;
    UITextAutocapitalizationType autoCapsType;
    UITextAutocorrectionType autoCorrectionType;
    int textFieldType;
@private
    NSString* _name;
    NSArray* _values;
    NSDictionary* _titleDict;
    NSDictionary* _shortTitleDict;
    id _userInfo;
    NSMutableDictionary* _properties;
}
@property(retain) NSMutableDictionary* properties;
@property(retain) NSString* identifier;
@property(retain) NSString* name;
@property(retain) id userInfo;
@property(retain) id titleDictionary;
@property(retain) id shortTitleDictionary;
@property(retain) NSArray* values;
+(id)preferenceSpecifierNamed:(NSString*)title target:(id)target set:(SEL)set get:(SEL)get detail:(Class)detail cell:(PSCellType)cell edit:(Class)edit;
+(PSSpecifier*)groupSpecifierWithName:(NSString*)title;
+(PSSpecifier*)emptyGroupSpecifier;
+(UITextAutocapitalizationType)autoCapsTypeForString:(PSSpecifier*)string;
+(UITextAutocorrectionType)keyboardTypeForString:(PSSpecifier*)string;
-(id)propertyForKey:(NSString*)key;
-(void)setProperty:(id)property forKey:(NSString*)key;
-(void)removePropertyForKey:(NSString*)key;
-(void)loadValuesAndTitlesFromDataSource;
-(void)setValues:(NSArray*)values titles:(NSArray*)titles;
-(void)setValues:(NSArray*)values titles:(NSArray*)titles shortTitles:(NSArray*)shortTitles;
-(void)setupIconImageWithPath:(NSString*)path;
-(NSString*)identifier;
-(void)setTarget:(id)target;
-(void)setKeyboardType:(UIKeyboardType)type autoCaps:(UITextAutocapitalizationType)autoCaps autoCorrection:(UITextAutocorrectionType)autoCorrection;
@end

@interface PSViewController : UIViewController
@end

@interface PSListController : PSViewController {
    NSArray *_specifiers;
}
@property(readonly, retain) PSSpecifier *specifier;
@property(retain) NSArray *specifiers;
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)plistName target:(id)target;
- (void)addSpecifiersFromArray:(NSArray*)array animated:(BOOL)animated;
- (void)removeSpecifier:(PSSpecifier*)specifier animated:(BOOL)animated;
@end

@interface PSListItemsController : PSListController
@end

#pragma mark - DoodleMessage

@protocol DoodleViewControllerDelegate;
@interface DoodleViewController : UIViewController
- (id)initWithDelegate:(id<DoodleViewControllerDelegate>)delegate;
@end

@protocol DoodleViewControllerDelegate <NSObject>
@required
- (void)doodle:(DoodleViewController *)doodleViewController didFinishWithImage:(UIImage *)image;
@end

#pragma mark - Ayra

@interface AyraCenterWindow : UIWindow
@end

@interface AyraCenterListCell : SBAwayBulletinCell
+(CGFloat)optionsRowHeight;
-(void)lockBarStartedTracking:(id)arg1;
-(void)lockBarSlidBackToOrigin:(id)arg1;
-(BOOL)_createsLockBarEarly;
-(id)delegate;
-(void)setDelegate:(id)arg1;
-(void)_ayra_deleteButtonTapped;
-(void)_ayra_openButtonTapped;
-(void)willTransitionToState:(unsigned)arg1;
-(void)_setShowOptionButtons:(BOOL)arg1 touchContentView:(BOOL)arg2;
-(void)setShowOptionButtons:(BOOL)arg1;
-(void)setIsClearable:(BOOL)arg1;
-(void)prepareForReuse;
-(void)_ayra_swipeRecognizerFired;
-(id)initWithReuseIdentifier:(id)arg1;
@end

@interface AyraCenterDataSource : NSObject {
    NSMutableArray *bulletins;
}
- (AyraCenterListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didDeleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didLaunchRowAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark - IntelliScreenX

@interface IntelliScreenX : NSObject
+ (instancetype)sharedInstance;
- (void)openBulletin:(BBBulletin *)bulletin withOrigin:(NSInteger)origin canUnlock:(BOOL)unlock;
- (void)removeBulletin:(BBBulletin *)bulletin;
@end

@interface IntelliScreenXSelectHandler : NSObject
@property (nonatomic,retain) BBBulletin *currentBulletin;
- (NSInteger)buttonCount;
- (NSString *)titleForButton:(NSInteger)index;
- (UIImage *)imageForButton:(NSInteger)index;
- (void)buttonClicked:(UIButton *)button;
- (UIImage *)openImage;
- (UIImage *)unreadImage;
- (UIImage *)replyImage;
@end

@interface IntelliScreenXDefaultHandler : IntelliScreenXSelectHandler
@end

#pragma mark - LockInfo

@interface LIBulletinListController : SBBulletinListController
- (void)observer:(id)observer removeBulletin:(BBBulletin *)bulletin;
@end

@interface LIWidgetController : NSObject
@property(retain, nonatomic) LIBulletinListController *bulletinController;
@end

@interface LIController : NSObject
@property(retain, nonatomic) LIWidgetController *widgetController;
+ (instancetype)sharedInstance;
@end

#pragma mark - Velox

@interface NotificationsFolderView : UIView {
    NSString *appID;
	NSMutableArray *notifications;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
