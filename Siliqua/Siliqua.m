// Siliqua Source. Created by LaughingQuoll. Copyright 2017.
// Special Thanks to finngaida for adding quad tap action ability.

// Collect our headers. We don't need many.

#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>
#import "MediaRemote.h"

@interface NSTimer (Private){ //yea don't use these. No point
}
+ (id)scheduledTimerWithTimeInterval:(double)arg1 invocation:(id)arg2 repeats:(BOOL)arg3;
+ (id)scheduledTimerWithTimeInterval:(double)arg1 repeats:(BOOL)arg2 block:(id /* block */)arg3;
+ (id)scheduledTimerWithTimeInterval:(double)arg1 target:(id)arg2 selector:(SEL)arg3 userInfo:(id)arg4 repeats:(BOOL)arg5;
@end
@interface BluetoothDevice
- (unsigned int)doubleTapAction;
- (bool)setDoubleTapAction:(unsigned int)arg;
-(BOOL)magicPaired;
@end

@interface MPMusicPlayerController
+ (id)systemMusicPlayer;
- (void)play;
- (void)skipToNextItem;
@end

@interface SBHomeScreenViewController
- (BOOL)justTapped;
- (void)setJustTapped:(BOOL)value;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (UIImage *)artwork;
- (BOOL)isPlaying;
- (BOOL)play;
- (BOOL)Pause;
- (BOOL)hasTrack;
- (BOOL)_sendMediaCommand:(unsigned)command;
- (BOOL)skipFifteenSeconds:(int)seconds;
-(void)increaseVolume;
-(void)decreaseVolume;
-(BOOL)_sendMediaCommand:(unsigned)arg1 ;
-(void)_changeVolumeBy:(float)arg1 ;
@end

bool Enabled;
bool dtPausePlay;
bool dtSkip;
bool dtRewind;
bool dtSkip15;
bool dtRewind15;
bool dtIncreaseVolume;
bool dtDecreaseVolume;
bool dtToggleSiri;

bool qtPausePlay;
bool qtSkip;
bool qtRewind;
bool qtSkip15;
bool qtRewind15;
bool qtIncreaseVolume;
bool qtDecreaseVolume;
bool qtToggleSiri;

@interface SBAssistantController
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
+(BOOL)isAssistantVisible;
-(long long)participantState;
-(void)dismissAssistantView:(long long)arg1 forAlertActivation:(id)arg2 ;


+(BOOL)isAssistantRunningHidden;
+(BOOL)isAssistantVisible;

@end

static BOOL justTapped = NO;

static BOOL isShowingAss(){ //;)
    SBAssistantController *assistantController = [objc_getClass("SBAssistantController") sharedInstance];
    if ([objc_getClass("SBAssistantController") respondsToSelector:@selector(participantState)]){
        if ((int)[assistantController participantState] == 1)
            return NO;
        return YES;
    } else {
        if (![objc_getClass("SBAssistantController") isAssistantVisible])
            return NO;
        return YES;
    }
}

CHDeclareClass(SBHomeScreenViewController);
CHOptimizedMethod0(new, void, SBHomeScreenViewController, viewDidLoad)
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedDoubleTapNotificationFromAirPods:) name:@"com.laughingquoll.runairpodsdoubletappedaction" object:nil];
}
CHOptimizedMethod1(new, void, SBHomeScreenViewController, recivedDoubleTapNotificationFromAirPods, NSNotification*, notification)
{
    if ([[notification name] isEqualToString:@"com.laughingquoll.runairpodsdoubletappedaction"]) {
        // Credits to Finn Gaida who created quad tap for me :P
        if (justTapped) {
            // quad tap action
            
            if(qtPausePlay){
                MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
            }
            
            if(qtSkip){
                MRMediaRemoteSendCommand(kMRNextTrack, 0);
            }
            
            if(qtRewind){
                MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
            }
            
            if(qtSkip15){
                // Both don't seem to work, looking for alternatives?
                // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:+15];
                // MRMediaRemoteSendCommand(kMRSkipFifteenSeconds, 0);
                [[objc_getClass("SBMediaController") sharedInstance] _sendMediaCommand:17];
            }
            
            if(qtRewind15){
                // Both don't seem to work, looking for alternatives?
                // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:-15];
                // MRMediaRemoteSendCommand(kMRGoBackFifteenSeconds, 0);
                [[objc_getClass("SBMediaController") sharedInstance] _sendMediaCommand:18];
            }
            
            if(qtIncreaseVolume){
                [[objc_getClass("SBMediaController") sharedInstance] _changeVolumeBy:0.1];
            }
            
            if(qtDecreaseVolume){
                [[objc_getClass("SBMediaController") sharedInstance] _changeVolumeBy:-0.1];
            }
            
            if(qtToggleSiri){
                SBAssistantController *assistantController = [objc_getClass("SBAssistantController") sharedInstance];
                if(!isShowingAss()){
                    //if((int)[assistantController participantState] == 1){
                    [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
                    [assistantController handleSiriButtonUpEventFromSource:1];
                } else {
                    [assistantController dismissAssistantView:1 forAlertActivation:nil];
                }
            }
            
            //[timer invalidate];
            justTapped = NO;
        } else {
            justTapped = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if(dtPausePlay){
                    MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
                }
                
                if(dtSkip){
                    MRMediaRemoteSendCommand(kMRNextTrack, 0);
                }
                
                if(dtRewind){
                    MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
                }
                
                if(dtSkip15){
                    // Both don't seem to work, looking for alternatives?
                    // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:+15];
                    // MRMediaRemoteSendCommand(kMRSkipFifteenSeconds, 0);
                    [[objc_getClass("SBMediaController") sharedInstance] _sendMediaCommand:17];
                }
                
                if(dtRewind15){
                    // Both don't seem to work, looking for alternatives?
                    // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:-15];
                    // MRMediaRemoteSendCommand(kMRGoBackFifteenSeconds, 0);
                    [[objc_getClass("SBMediaController") sharedInstance] _sendMediaCommand:18];
                }
                
                if(dtIncreaseVolume){
                    [[objc_getClass("SBMediaController") sharedInstance] _changeVolumeBy:0.1];
                }
                
                if(dtDecreaseVolume){
                    [[objc_getClass("SBMediaController") sharedInstance] _changeVolumeBy:-0.1];
                }
                
                if(dtToggleSiri){
                    SBAssistantController *assistantController = [objc_getClass("SBAssistantController") sharedInstance];
                    if(!isShowingAss()){
                        //if((int)[assistantController participantState] == 1){
                        [assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
                        [assistantController handleSiriButtonUpEventFromSource:1];
                    } else {
                        [assistantController dismissAssistantView:1 forAlertActivation:nil];
                    }
                }
                
                justTapped = NO;
            });
        }
    }
}

CHDeclareClass(BluetoothManager);
CHOptimizedMethod1(self, void, BluetoothManager, _postNotificationWithArray, id, arg1)
{
    if(Enabled){
        NSString *stringOne = @"BluetoothHandsfreeInitiatedVoiceCommand";
        NSString *stringTwo = @"BluetoothHandsfreeEndedVoiceCommand";
        NSString *stringThree = @"BluetoothDeviceDisconnectSuccessNotification";
        // Check for the first string.
        if ( [arg1 containsObject:stringOne] ) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"com.laughingquoll.runairpodsdoubletappedaction"
             object:self];
        } else {
            // Check for the second string.
            if ( [arg1 containsObject:stringTwo] ) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"com.laughingquoll.runairpodsdoubletappedaction"
                 object:self];
                // It wasn't any of the two strings so we just allow it to do whatever.
            } else {
                // Unfinished feature, add an action when AirPods become connected.
                if([arg1 containsObject:stringThree] ) {
                    NSLog(@"AirPods just became connected");
                }
                return CHSuper1(BluetoothManager, _postNotificationWithArray, arg1);
            }
        }
    } else {
         CHSuper1(BluetoothManager, _postNotificationWithArray, arg1);
    }
}

static void settingsChangedSiliqua(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    @autoreleasepool {
        NSDictionary *SiliquaPrefs = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.laughingquoll.siliquaprefs.plist"]?:[NSDictionary dictionary] copy];
        Enabled = (BOOL)[[SiliquaPrefs objectForKey:@"enabled"]?:@YES boolValue];

        // Our Double Tap Preferences
        dtPausePlay = (BOOL)[[SiliquaPrefs objectForKey:@"dtPausePlay"]?:@NO boolValue];
        dtSkip = (BOOL)[[SiliquaPrefs objectForKey:@"dtSkip"]?:@NO boolValue];
        dtRewind = (BOOL)[[SiliquaPrefs objectForKey:@"dtRewind"]?:@NO boolValue];
        dtSkip15 = (BOOL)[[SiliquaPrefs objectForKey:@"dtSkip15"]?:@NO boolValue];
        dtRewind15 = (BOOL)[[SiliquaPrefs objectForKey:@"dtRewind15"]?:@NO boolValue];
        dtIncreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"dtIncreaseVolume"]?:@NO boolValue];
        dtDecreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"dtDecreaseVolume"]?:@NO boolValue];
        dtToggleSiri = (BOOL)[[SiliquaPrefs objectForKey:@"dtToggleSiri"]?:@NO boolValue];

        // Our Quad Tap Preferences
        qtPausePlay = (BOOL)[[SiliquaPrefs objectForKey:@"qtPausePlay"]?:@NO boolValue];
        qtSkip = (BOOL)[[SiliquaPrefs objectForKey:@"qtSkip"]?:@NO boolValue];
        qtRewind = (BOOL)[[SiliquaPrefs objectForKey:@"qtRewind"]?:@NO boolValue];
        qtSkip15 = (BOOL)[[SiliquaPrefs objectForKey:@"qtSkip15"]?:@NO boolValue];
        qtRewind15 = (BOOL)[[SiliquaPrefs objectForKey:@"qtRewind15"]?:@NO boolValue];
        qtIncreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"qtIncreaseVolume"]?:@NO boolValue];
        qtDecreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"qtDecreaseVolume"]?:@NO boolValue];
        qtToggleSiri = (BOOL)[[SiliquaPrefs objectForKey:@"qtToggleSiri"]?:@NO boolValue];
    }
}
__attribute__((constructor)) static void initialize_Siliqua()
{
    @autoreleasepool {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedSiliqua, CFSTR("com.laughingquoll.SiliquaPrefs/changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        settingsChangedSiliqua(NULL, NULL, NULL, NULL, NULL);
        
        CHLoadLateClass(SBHomeScreenViewController);
        CHHook0(SBHomeScreenViewController, viewDidLoad);
        CHHook1(SBHomeScreenViewController, recivedDoubleTapNotificationFromAirPods);
        
        CHLoadLateClass(BluetoothManager);
        CHHook1(BluetoothManager, _postNotificationWithArray);
        
    }
}
