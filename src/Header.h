#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <substrate.h>
#import <CaptainHook/CaptainHook.h>
#import "sky/SkyController.h"

#define KAKAOTALK @"com.iwilab.KakaoTalk"
#define KAKAOTALK_MSG_SEND @"kr.b1ink.5skyprefs.MsgSend.KakaoTalk"
#define KAKAOTALK_MSG_HEAD_ICON @"kr.b1ink.5skyprefs.Msg.HeadIcon.KakaoTalk"
#define KAKAOTALK_MSG_SEND_IMAGE @"kr.b1ink.5skyprefs.MsgSend.Image.KakaoTalk"
#define KAKAOTALK_MSG_RECEIVED "kr.b1ink.5skyprefs.MsgReceived.KakaoTalk"
#define KAKAOTALK_REQUEST_PHOTO_URL @"kr.b1ink.5skyprefs.Request.Photo.URL.KakaoTalk"
#define KAKAOTALK_REQUEST_MESSAGES @"kr.b1ink.5skyprefs.Request.Messages.KakaoTalk"
#define KAKAOTALK_REQUEST_TITLE @"kr.b1ink.5skyprefs.Request.Title.KakaoTalk"
#define KAKAOTALK_REQUEST_HOME @"kr.b1ink.5skyprefs.Request.Home.KakaoTalk"

#define WHOAU_PREFS_CHANGED "kr.b1ink.5skyprefs.settingsChanged"
#define WHOAU_NOTICE_SHOW_ICON "kr.b1ink.show.headIcon"

#define SpringBoardIdentifier @"com.apple.springboard"
#define BackBoardIdentifier @"com.apple.backboardd"

typedef NS_ENUM(NSUInteger, BKSProcessAssertionReason)
{
    kProcessAssertionReasonAudio = 1,
    kProcessAssertionReasonLocation,
    kProcessAssertionReasonExternalAccessory,
    kProcessAssertionReasonFinishTask,
    kProcessAssertionReasonBluetooth,
    kProcessAssertionReasonNetworkAuthentication,
    kProcessAssertionReasonBackgroundUI,
    kProcessAssertionReasonInterAppAudioStreaming,
    kProcessAssertionReasonViewServices
};
typedef NS_ENUM(NSUInteger, ProcessAssertionFlags)
{
    ProcessAssertionFlagNone = 0,
    ProcessAssertionFlagPreventSuspend = 1 << 0,
    ProcessAssertionFlagPreventThrottleDownCPU = 1 << 1,
    ProcessAssertionFlagAllowIdleSleep = 1 << 2,
    ProcessAssertionFlagWantsForegroundResourcePriority = 1 << 3
};


@interface BBContent : NSObject
-(id)message;
-(id)subtitle;
-(id)title;
@end

@interface SBLockScreenActionContext : NSObject
@property(nonatomic) BBBulletin *bulletin; // @synthesize bulletin=_bulletin;
@end

@interface _NSInlineData : NSData {
    unsigned short _length;
}
- (unsigned long long)length;
- (const void*)bytes;
//- (id)copyWithZone:(struct _NSZone { }*)arg1;
- (bool)_isCompact;
- (id)initWithBytes:(const void*)arg1 length:(unsigned long long)arg2;
@end

@interface BBBulletin : NSObject

@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,copy) NSString * sectionID;

+(id)bulletinWithBulletin:(id)arg1;
-(void)setButtons:(NSArray *)buttons;
-(void)setMessage:(NSString *)msg;
-(NSDictionary*)context;
-(BBContent*)content;
@end

@interface UIApplication (sky)
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
-(id)_accessibilityFrontMostApplication;
@end

@interface ChatsViewController : UIViewController
- (id)tableView;
    //- (void)tableView:(id)fp8 didSelectRowAtIndexPath:(id)fp12;
- (id)fetchedResults;
- (void)viewDidLoad;
//- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface Chat : NSObject
-(id)lastMessageID;
-(id)displayTitleInChatRoom;
-(id)displayTitle;
-(id)thumbnailURL;
-(id)thumbnailImage;
-(id)largeThumbnailURL;
+(id)chatOfID:(id)fp8;
+(id)fetchByID:(id)anId;
-(id)addChatMessages:(id)messages;
-(BOOL)removeSendingMsgClientMsgID:(id)anId;
-(BOOL)existSendingMsgClientMsgID:(id)anId;

@property(retain, nonatomic) NSNumber* lastMessageID;
@end

@interface ChattingViewController : UIViewController
-(void)sendText:(NSString*)msg;
-(void)didReadChat:(int)count;
-(id)chat;
-(id)getMessageWith:(id)fp8;
//-(void)sendImage:(id)fp8;
-(void)updateChatRoom;
-(void)update;
-(void)update:(BOOL)fp8;
-(void)didSendMessage:(id)fp8;
@end

@interface ChatMessage : NSObject
- (id)thumbnailUrl;
- (id)userId;
- (id)chatId;
@end

@interface SimpleURLCache : NSObject
- (id)url;
@end

@interface User : NSObject
+(id)userOfID:(id)fp8;
+(id)fetchByID:(id)anId;
-(id)thumbnailURL;
-(id)userName;
-(id)talkName;
-(BOOL)isFriend;
-(BOOL)isMe;
@end

@interface TalkAppDelegate : NSObject
+ (id)sharedDelegate;
- (id)currentTopController;
- (id)currentVisibleController;
@end

@interface AppNavigationController : UINavigationController
- (void)moveToChats;
-(id)currentChattingViewControllerWithChat:(id)chat;
+ (id)defaultController;
- (void)moveToChatRoomAtID:(long long)fp8;
- (void)showChattingList;
-(id)currentChattingViewController;
@end

@interface KAOMsgDatabase : NSObject
+ (id)sharedInstance;
- (id)findAllRecordsWithQuery:(NSString*)query;
@end

@interface KAODatabaseCrypto : NSObject
+ (id)decryptWithUserId:(id)fp8 source:(id)fp12 version:(id)fp16;
+ (id)encryptWithUserId:(id)fp8 source:(id)fp12 version:(id)fp16;
+ (id)decryptWithUserId:(id)fp8 source:(id)fp12;
+ (id)encryptWithUserId:(id)fp8 source:(id)fp12;
+ (id)makeKeyWithUserId:(id)fp8;
+ (id)currentVersion;

@end

@interface AsyncWriteManager : NSObject {
    NSMutableArray* _sendingQueue;
    BOOL writeDone;
    NSMutableDictionary* _messageStatusTimers;
    NSMutableDictionary* _errorMessages;
}
@property(retain, nonatomic) NSMutableDictionary* errorMessages;
@property(assign, nonatomic) BOOL writeDone;
+(id)sharedManager;
-(void)addErrorMessage:(id)message;
-(void)messageStatusTimerFired:(id)fired;
-(void)clearMessageStatusTimers;
-(void)removeMessageStatusTimerWithClientMsgId:(id)clientMsgId;
-(void)addMessageStatusTimerWithMessage:(id)message;
-(void)sendSendingMessage;
-(void)loadSendingAndErrorMessagesFromDB;
-(id)fetchSendingMessageFromDB;
-(id)errorChatIds;
-(void)clearErrorMessagesOfClientMsgId:(id)clientMsgId;
-(void)clearErrorMessagesOfChatId:(id)chatId;
-(id)sendingChatIds;
-(void)sendErrorToResponderUserMessage:(id)responderUserMessage;
-(void)changeOldSendingMessagetoError;
-(void)addSendingQueue:(id)queue;
-(id)init;
@end

@protocol SendingDelegateResponse;

@interface SendingDelegate : NSObject {
    Chat* chat;
    id<SendingDelegateResponse> responder;
    NSMutableDictionary* connections;
}
@property(readonly, copy) NSString* debugDescription;
@property(readonly, copy) NSString* description;
@property(readonly, assign) Class superclass;
@property(readonly, assign) unsigned hash;
@property(assign, nonatomic) id<SendingDelegateResponse> responder;
@property(retain, nonatomic) Chat* chat;
+(void)reset;
+(void)removeChat:(id)chat;
+(void)stopAll;
+(BOOL)hasDelegate:(id)delegate;
+(id)delegateWithChat:(id)chat;
-(BOOL)isUploadMessage:(id)message;
-(void)dealloc;
-(void)messageRequestDidFail:(id)messageRequest withError:(id)error;
-(void)messageRequestDidCancel:(id)messageRequest;
-(void)messageRequestDidFinish:(id)messageRequest withChatRoom:(id)chatRoom chatLogs:(id)logs;
-(void)messageRequestDidFinish:(id)messageRequest locoChatLogObjectV2:(id)a2;
-(void)didSendWithChatRoom:(id)chatRoom chatLogs:(id)logs message:(id)message;
-(BOOL)cancel:(id)cancel;
-(void)send:(id)send sinceID:(id)anId;
-(void)send:(id)send sinceID:(id)anId legacyOnly:(BOOL)only;
-(void)removeChat;
-(void)stopAllRequests;
-(id)init;
@end

@interface TextMessage : NSObject {
}
@property(assign, nonatomic) BOOL asyncWriteMessage;
@property(readonly, assign, nonatomic) NSNumber* clientMsgId;
+(id)messageWithText:(id)text withExtra:(id)extra;
+(id)messageWithText:(id)text;
-(id)updateChatId:(id)anId;
-(id)updateUserId:(id)anId;
-(id)updateMessage:(id)message;
-(BOOL)save;
-(void)updateChatsViewController;
-(id)updateStatus:(int)status;
-(id)newMessageForTransmittionWithChatId:(id)chatId;
@end

@interface UIWindow (sky)
+ (void)setAllWindowsKeepContextInBackground:(_Bool)arg1;
@end

@interface BKSProcessAssertion
- (id)initWithPID:(int)arg1 flags:(unsigned int)arg2 reason:(unsigned int)arg3 name:(id)arg4 withHandler:(id)arg5;
- (id)initWithBundleIdentifier:(id)arg1 flags:(unsigned int)arg2 reason:(unsigned int)arg3 name:(id)arg4 withHandler:(id)arg5;
- (void)invalidate;
@property(readonly, nonatomic) BOOL valid;
@end

@interface UtilManager : NSObject

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isLockEnabled;
@property (nonatomic, assign) BOOL isShowHead;
@property (nonatomic, assign) BOOL isCloseAfterSend;
@property (nonatomic, retain) NSNumber* chatId;
@property (nonatomic, retain) SkyController* CurrentSkyController;

//@property (nonatomic, retain) FBWindowContextHostView *hostView;
//@property (nonatomic, assign) CGAffineTransform orgTransform;
//@property (nonatomic, retain) BKSProcessAssertion *keepAlive;
+(id)sharedManager;
@end

