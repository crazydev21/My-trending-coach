//
//  VideoChatViewController.m
//  My Trending Coach App
//
//  Created by Nisarg on 01/02/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//


#import "VideoChatViewController.h"
#import <OpenTok/OpenTok.h>

#import "UIViewController+MJPopupViewController.h"
#import "FeedBackView.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"



@interface VideoChatViewController ()
<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate, MJSecondPopupDelegate,SharedClassDelegate>

@end

@implementation VideoChatViewController
{
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
    AVAudioPlayer *player;
    NSString *kApiKey,*kSessionId,*kToken;
}

// *** Fill the following variables using your own Project info  ***
// ***          https://dashboard.tokbox.com/projects            ***

//
//// Replace with your OpenTok API key
//static NSString *const kApiKey = @"45650272";
//// Replace with your generated session ID
//static NSString *const kSessionId = @"2_MX40NTY1MDI3Mn5-MTQ4MzEwNDI2ODg3Nn5nYXF5NXpKa21LcGk1UVg3UzZsK1owQTd-fg";
//// Replace with your generated token
//static NSString *const kToken = @"T1==cGFydG5lcl9pZD00NTY1MDI3MiZzaWc9NjM2ZWNkN2MxZDg4ZTBlMDJhNWI0ZGYzNDM0NzdlYmNjM2NmZDZjNzpzZXNzaW9uX2lkPTJfTVg0ME5UWTFNREkzTW41LU1UUTRNekV3TkRJMk9EZzNObjVuWVhGNU5YcEthMjFMY0drMVVWZzNVelpzSzFvd1FUZC1mZyZjcmVhdGVfdGltZT0xNDgzMTA0MzcxJm5vbmNlPTAuNDQ2MTgyOTM0MjgzMjI4NjQmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTQ4NTY5NjM3MA==";
////// Change to NO to subscribe to streams other than your own.
//

//
//static NSString *const kApiKey = @"45494712";
//// Replace with your generated session ID
//static NSString *const kSessionId = @"2_MX40NTQ5NDcxMn5-MTQ1NTI3NjU0ODE0OX5mRW9HNFRNKzNxZHdpWVoxZFg0TUZOcnJ-UH4";
//// Replace with your generated token
//static NSString *const kToken = @"T1==cGFydG5lcl9pZD00NTQ5NDcxMiZzaWc9NWQ0OGEyY2Q4ZmU5MWExMGE4YzNjOWIyNTJlNzhjMDQzZTlhYTczMjpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTJfTVg0ME5UUTVORGN4TW41LU1UUTFOVEkzTmpVME9ERTBPWDVtUlc5SE5GUk5Lek54WkhkcFdWb3haRmcwVFVaT2NuSi1VSDQmY3JlYXRlX3RpbWU9MTQ1NTI3NjU1OSZub25jZT0wLjc3NzkwNDg0OTk3NzYzOTgmZXhwaXJlX3RpbWU9MTQ1Nzg2ODUxMiZjb25uZWN0aW9uX2RhdGE9";



static NSString* const kTextChatType = @"TextChat";

static bool subscribeToSelf = NO;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    _IBLabelMinute.text = @"00:00";
    
    /* Use this code to play an audio file */
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Message"  ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
   // player.numberOfLoops = -1; //Infinite
    
    [self LoadData];
    
  }

-(void)LoadData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared TalkBox:_strAppointmentID userid: [[NSUserDefaults standardUserDefaults] stringForKey:@"id"] usertype: [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
}



-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails_All Detail  :   %@",dicUserDetials);
    
    NSString *code = [[NSString alloc] init];
    code = [dicUserDetials valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [dicUserDetials valueForKey:@"message"];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    data = [dicUserDetials valueForKey:@"data"];

    
    int codevalue = [code intValue];
    if (codevalue == 1)
    {
        _IBLabelMinute.text = @"00:00";
        kApiKey = [[NSString alloc] init];
        kApiKey = [data valueForKey:@"apikey"];
        
        kSessionId = [[NSString alloc] init];
        kSessionId = [data valueForKey:@"session_id"];
        
        kToken = [[NSString alloc] init];
        kToken = [data valueForKey:@"token"];
        
  
        
        @try
        {
            NSLog(@"remain_time==%@",[dicUserDetials valueForKey:@"remain_time"]);
            NSString *timeString = [dicUserDetials valueForKey:@"remain_time"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"mm:ss";
            NSDate *timeDate = [formatter dateFromString:timeString];
            
            formatter.dateFormat = @"mm";
            int minutes = [[formatter stringFromDate:timeDate] intValue];
            formatter.dateFormat = @"ss";
            int seconds = [[formatter stringFromDate:timeDate] intValue];
            
            Seconds = seconds + minutes * 60;
            NSLog(@"Seconds==%ld",(long)Seconds);
        }
        @catch (NSException *exception)
        {
            
        }

        appDelegate.isstartSession = YES;
        
        // Step 1: As the view comes into the foreground, initialize a new instance
        // of OTSession and begin the connection process.
        _session = [[OTSession alloc] initWithApiKey:kApiKey
                                           sessionId:kSessionId
                                            delegate:self];
        [self doConnect];
        
        //    NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 120.0];
        //    timer = [[NSTimer alloc] initWithFireDate: d
        //                                     interval: 1
        //                                       target: self
        //                                     selector:@selector(TimesUp:)
        //                                     userInfo:nil repeats:YES];
        //
        //    NSRunLoop *runner = [NSRunLoop currentRunLoop];
        //    [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        //    [timer release];
        
        [self performSelector:@selector(ViewLoading) withObject:nil afterDelay:1.0];
        OTError *error = nil;
        [_session connectWithToken:kToken error:&error];
        if (error)
        {
            [self showAlert:[error localizedDescription]];
        }
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }

}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
//                                                        message:string
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil] ;
//        [alert show];
    });
}


-(void) ViewLoading
{

    _IBViewLoad.alpha = 1.0;
    [_IBSpinner startAnimating];
    
    
    NSString *Login = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Coach"])
    {
        _IBLabelLoad.text = @"You are trying to connect with Player Please Wait...";
      //  [appDelegate startLoadingview:@"You are trying to connect with Player Please Wait..."];
    }
    else
    {
        _IBLabelLoad.text = @"You are trying to connect with Coach Please Wait...";
        //[appDelegate startLoadingview:@"You are trying to connect with Coach Please Wait..."];
    }
    
}

-(void)stopLoadingview
{
    [_IBSpinner stopAnimating];
    //[objSpinKit stopAnimating];
    _IBViewLoad.alpha = 0.0;
}

-(void)TimesUp:(NSTimer *)timer
{
    if (_session && _session.sessionConnectionStatus == OTSessionConnectionStatusConnected)
    {
        // disconnect session
        NSLog(@"disconnecting....");
        [_session disconnect:nil];
        [self performSelector:@selector(DiscardView) withObject:nil afterDelay:2];
        return;
    }
}

-(void)DiscardView
{
    
    appDelegate.isstartSession = NO;
    [self stopLoadingview];
    
    [appDelegate stopLoadingview];
    [appDelegate stopLoadingview];
    [timerexpire invalidate];
    timerexpire = nil;
//    [timer invalidate];
//    timer = nil;
    
    
    appDelegate.isEndLiveStream = YES;
    NSString *Login = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Coach"])
    {
        [appDelegate showAlertMessage:@"Session Expired. \nYou could not connect with player."];
        
        [self dismissViewControllerAnimated:NO completion:nil];
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
    }
    else
    {
        [appDelegate showAlertMessage:@"Coach could not be Connected. \nPlease try again later."];
       // [self.navigationController popViewControllerAnimated:YES];
        
        [self dismissViewControllerAnimated:NO completion:nil];
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
    }
    
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice]
                                      userInterfaceIdiom])
    {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - OpenTok methods

/**
 * Asynchronously begins the session connect process. Some time later, we will
 * expect a delegate method to call us back with the results of this action.
 */
- (void)doConnect
{
    OTError *error = nil;
    
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Sets up an instance of OTPublisher to use with this session. OTPubilsher
 * binds to the device camera and microphone, and will provide A/V streams
 * to the OpenTok session.
 */
- (void)doPublish
{
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                     name:[[UIDevice currentDevice] name]];
    
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    [_UIViewVideo addSubview:_publisher.view];
    [_publisher.view setFrame:CGRectMake(5, _UIViewVideo.frame.size.height -130, 70, 70)];
}

/**
 * Cleans up the publisher and its view. At this point, the publisher should not
 * be attached to the session any more.
 */
- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
    // this is a good place to notify the end-user that publishing has stopped.
}

/**
 * Instantiates a subscriber for the given stream and asynchronously begins the
 * process to begin receiving A/V content for this stream. Unlike doPublish,
 * this method does not add the subscriber to the view hierarchy. Instead, we
 * add the subscriber only after it has connected and begins receiving data.
 */
- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

/**
 * Cleans the subscriber from the view hierarchy, if any.
 * NB: You do *not* have to call unsubscribe in your controller in response to
 * a streamDestroyed event. Any subscribers (or the publisher) for a stream will
 * be automatically removed from the session during cleanup of the stream.
 */
- (void)cleanupSubscriber
{
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

# pragma mark - OTSession delegate callbacks

//- (void)sessionDidConnect:(OTSession*)session
//{
//    NSLog(@"sessionDidConnect (%@)", session.sessionId);
//    
//    // Step 2: We have successfully connected, now instantiate a publisher and
//    // begin pushing A/V streams into OpenTok.
//    [self doPublish];
//}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    
    
//    _IBLabelMinute = [[MZTimerLabel alloc] initWithLabel:_IBLabelCounter andTimerType:MZTimerLabelTypeTimer];
//    timerExample.timeFormat = @"ss";
//    [timerExample setCountDownTime:1*60]; //** Or you can use [timer3 setCountDownToDate:aDate];
//    [timerExample start];
//    // _IBLabelCounter.hidden = NO;
//    _IBLabelCounter.text = @"59";
    
 

}


- (void)session:(OTSession*)mySession
streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Player"])
    {
        if (OneTimeTag == NO)
        {
            OneTimeTag =YES;
        }
        else
        {
            [_session disconnect:nil];
            [self session:_session streamDestroyed:stream];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Coach is busy now, please try later."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil] ;
            alert.tag = 1;
            [alert show];
            
        }
        
    }

//    
    // Step 3a: (if NO == subscribeToSelf): Begin subscribing to a stream we
    // have seen on the OpenTok session.
    if (nil == _subscriber && !subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}


- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    
    if (_session && _session.sessionConnectionStatus ==
        OTSessionConnectionStatusConnected) {
        // disconnect session
        
        [timerexpire invalidate];
        timerexpire = nil;
        [timer invalidate];
        timer = nil;

        NSLog(@"disconnecting....");
        [_session disconnect:nil];
        [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:2.0];
        return;
    }

}

- (void)  session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
    
    
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self stopLoadingview];
            [appDelegate stopLoadingview];
            [appDelegate stopLoadingview];
            [timerexpire invalidate];
            timerexpire = nil;
            [timer invalidate];
            timer = nil;
            
            appDelegate.isstartSession = NO;
           
            appDelegate.isEndLiveStream = YES;
           [self dismissViewControllerAnimated:NO completion:nil];
//            MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//            appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
            
            
        }
        
    }
    // NSLog(@"ava=%@",Aryavailability);
}
- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
    }
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
    //[self endCallAction:nil];
    
    
    [timerexpire invalidate];
    timerexpire = nil;
    [timer invalidate];
    timer = nil;
    
    appDelegate.isstartSession = NO;
    [self cleanupSubscriber];
    NSLog(@"disconnecting....");
    [_session disconnect:nil];
    [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:2];
    return;
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
//    [timer invalidate];
//    timer = nil;
     [self stopLoadingview];
    [appDelegate stopLoadingview];
    [appDelegate stopLoadingview];
    self.userNameLabel.text = _subscriber.stream.name;
    
    
    
    _IBLabelMinute = [[MZTimerLabel alloc] initWithLabel:_IBLabelMinute andTimerType:MZTimerLabelTypeTimer];
    _IBLabelMinute.timeFormat = @"mm:ss";
    [_IBLabelMinute setCountDownTime:Seconds]; //** Or you can use [timer3 setCountDownToDate:aDate];
    //[_IBLabelMinute start];

//    [_IBLabelMinute setCountDownTime:30];
//    _IBLabelMinute.timeFormat = @"mm:ss";
    _IBLabelMinute.endedBlock = ^(NSTimeInterval countTime) {
        //oh my gosh, it's awesome!!
        NSLog(@"Time out");
        if (_session && _session.sessionConnectionStatus ==
            OTSessionConnectionStatusConnected) {
            // disconnect session
            NSLog(@"disconnecting....");
            [_session disconnect:nil];
            [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:1.0];
            return;
        }

    };
    [_IBLabelMinute start];
    
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    assert(_subscriber == subscriber);
    [_subscriber.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,
                                          [[UIScreen mainScreen]bounds].size.height)];
    [_IBViewBackground addSubview:_subscriber.view];
    
//    NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 1800.0];
//    timerexpire = [[NSTimer alloc] initWithFireDate: d
//                                     interval: 1
//                                       target: self
//                                     selector:@selector(TimerExpired:)
//                                     userInfo:nil repeats:YES];
//    
//    NSRunLoop *runner = [NSRunLoop currentRunLoop];
//    [runner addTimer:timerexpire forMode: NSDefaultRunLoopMode];
//    [timerexpire release];
}




//-(void)TimerExpired:(NSTimer *)timer
//{
//    if (_session && _session.sessionConnectionStatus ==
//        OTSessionConnectionStatusConnected) {
//        // disconnect session
//        NSLog(@"disconnecting....");
//        [_session disconnect:nil];
//        [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:1.0];
//        return;
//    }
//}

-(void)ExpiredView
{
    [timerexpire invalidate];
    timerexpire = nil;
    
    
    appDelegate.isstartSession = NO;
    
    appDelegate.isEndLiveStream = YES;
    
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Coach"])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
    }
    else
    {
        NSLog(@"appDelegate.strCoachId ==%@",appDelegate.strCoachId);
        //[self.navigationController popViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:NO completion:nil];
        
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];

//        FeedBackView *detailViewController = [[FeedBackView alloc] initWithNibName:@"FeedBackView" bundle:nil];
//        detailViewController.delegate = self;
//        [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationFade];

    }
    

}


- (void)subscriber:(OTSubscriberKit*)subscriber
didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
    
    
    
    //[self endCallAction:nil];
    
    [timerexpire invalidate];
    timerexpire = nil;
    [timer invalidate];
    timer = nil;
    
    appDelegate.isstartSession = NO;
    [self cleanupSubscriber];
    NSLog(@"disconnecting....");
    [_session disconnect:nil];
    [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:2];
    return;
}


# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
streamCreated:(OTStream *)stream
{
    // Step 3b: (if YES == subscribeToSelf): Our own publisher is now visible to
    // all participants in the OpenTok session. We will attempt to subscribe to
    // our own stream. Expect to see a slight delay in the subscriber video and
    // an echo of the audio coming from the device microphone.
    if (nil == _subscriber && subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
streamDestroyed:(OTStream *)stream
{
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    
    [self cleanupPublisher];
}

- (void)publisher:(OTPublisherKit*)publisher
didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}



#pragma mark - Helper Methods
#pragma mark - Helper Methods
- (IBAction)endCallAction:(UIButton *)button
{
//    if (_session && _session.sessionConnectionStatus ==
//        OTSessionConnectionStatusConnected) {
        // disconnect session
   
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"END CALL"
                                          message:@"Are you sure you want to end this call??"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"No")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Yes", @"Yes")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [timerexpire invalidate];
                                   timerexpire = nil;
                                   [timer invalidate];
                                   timer = nil;
                                   
                                   appDelegate.isstartSession = NO;
                                   [self cleanupSubscriber];
                                   NSLog(@"disconnecting....");
                                   [_session disconnect:nil];
                                   [self performSelector:@selector(ExpiredView) withObject:nil afterDelay:2];
                                   return;
                                   
                                   
                               }];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    
    
         // }
}



-(void)CloseView
{
    [self stopLoadingview];
    [appDelegate stopLoadingview];
    [appDelegate stopLoadingview];
    [timerexpire invalidate];
    timerexpire = nil;
    [timer invalidate];
    timer = nil;
    
    appDelegate.isstartSession = NO;
    
    appDelegate.isEndLiveStream = YES;
    
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Coach"])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
    }
    else
    {
      
        
        [self dismissViewControllerAnimated:NO completion:nil];
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Interactions
- (IBAction)toggleAudioSubscribe:(id)sender
{
    if (_subscriber.subscribeToAudio == YES) {
        _subscriber.subscribeToAudio = NO;
        self.audioSubUnsubButton.selected = YES;
    } else {
        _subscriber.subscribeToAudio = YES;
        self.audioSubUnsubButton.selected = NO;
    }
}

- (void)dealloc
{
    [_cameraToggleButton release];
    [_audioPubUnpubButton release];
    [_userNameLabel release];
    [_audioSubUnsubButton release];
    [_overlayTimer release];
    
    [_endCallButton release];

    [super dealloc];
}

- (IBAction)toggleCameraPosition:(id)sender
{
    if (_publisher.cameraPosition == AVCaptureDevicePositionBack) {
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
        self.cameraToggleButton.selected = NO;
        self.cameraToggleButton.highlighted = NO;
    } else if (_publisher.cameraPosition == AVCaptureDevicePositionFront) {
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
        self.cameraToggleButton.selected = YES;
        self.cameraToggleButton.highlighted = YES;
    }
}

- (IBAction)toggleAudioPublish:(id)sender
{
    if (_publisher.publishAudio == YES) {
        _publisher.publishAudio = NO;
        self.audioPubUnpubButton.selected = YES;
    } else {
        _publisher.publishAudio = YES;
        self.audioPubUnpubButton.selected = NO;
    }
}






//////////////   Mark :- Text Chat /////////

//- (void)keyboardWillShow:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//        
//        CGRect r = self.view.bounds;
//        r.origin.y += 20;
//        r.size.height -= 20 + kbSize.height;
//        _textChat.view.frame = r;
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//        
//        CGRect r = self.view.bounds;
//        r.origin.y += 20;
//        r.size.height -= 20;
//        _textChat.view.frame = r;
//        
//    }];
//}
//
- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message {
    OTError *error = nil;
    [_session signalWithType:kTextChatType string:message.text connection:nil error:&error];
    if (error) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark OTSessionDelegate methods

- (void)sessionDidConnect:(OTSession*)session {
    
    // [appDelegate stopLoadingview];
    
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    [self doPublish];
    
    // When we've connected to the session, we can create the chat component.
    
    _IBLayoutViewVideoHeight.constant = [[UIScreen mainScreen]bounds].size.height - 200;
    [_publisher.view setFrame:CGRectMake(5, self.view.frame.size.height -330, 70, 70)];
    
    
    _textChat = [[OTKTextChatComponent alloc] init];
    
    _textChat.delegate = self;
    
    [_textChat setMaxLength:1050];
    [_textChat setSenderId:session.connection.connectionId alias:session.connection.data];
    
    CGRect r = _UIViewTextChat.bounds;
    r.origin.y += 0;
    r.size.height -= 0;
    [_textChat.view setFrame:r];
    [_UIViewTextChat addSubview:_textChat.view];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // fade in
    _textChat.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^()
    {
        //_connectingLabel.alpha = 0;
        _textChat.view.alpha = 1;
    }];
    
}

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string
{
    NSLog(@"strGet");
    if (![connection.connectionId isEqualToString:_session.connection.connectionId])
    {
        [player play];
        
        OTKChatMessage *msg = [[OTKChatMessage alloc]init];
        msg.senderAlias = connection.data;
        msg.senderId = connection.connectionId;
        msg.text = string;
        [self.textChat addMessage:msg];

    }
}

- (IBAction)IBButtonInfo:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"Tap to enable full screen and tap again to go back normal" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    [alert show];

}

- (IBAction)IBButtonClickTap:(id)sender
{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        NSLog(@"Landscape");
        if (_IBButtonTap.tag == 0)
        {
            _IBButtonTap.tag = 1;
            _IBLayoutViewVideoHeight.constant = [[UIScreen mainScreen]bounds].size.height;
            _UIViewTextChat.hidden = YES;
             [_publisher.view setFrame:CGRectMake(5, _UIViewVideo.frame.size.height -130, 70, 70)];
            
            
        }
        else
        {
            _IBButtonTap.tag = 0;
            _IBLayoutViewVideoHeight.constant = [[UIScreen mainScreen]bounds].size.height - 200;
            _UIViewTextChat.hidden = NO;
            [_publisher.view setFrame:CGRectMake(5, _UIViewVideo.frame.size.height -330, 70, 70)];
            
        }
        [_subscriber.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,_IBViewBackground.frame.size.width)];
    }
    else
    {
        if (_IBButtonTap.tag == 0)
        {
            _IBButtonTap.tag = 1;
            _IBLayoutViewVideoHeight.constant = [[UIScreen mainScreen]bounds].size.height;
            _UIViewTextChat.hidden = YES;
            [_publisher.view setFrame:CGRectMake(5, self.view.frame.size.height -130, 70, 70)];
            
            
        }
        else
        {
            _IBButtonTap.tag = 0;
            _IBLayoutViewVideoHeight.constant = [[UIScreen mainScreen]bounds].size.height - 200;
            _UIViewTextChat.hidden = NO;
            [_publisher.view setFrame:CGRectMake(5, self.view.frame.size.height -330, 70, 70)];
            
        }
        [_subscriber.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height)];
    }
}


-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        NSLog(@"Landscape");
        
        [_publisher.view setFrame:CGRectMake(5, _UIViewVideo.frame.size.height -130, 70, 70)];
        [_subscriber.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,_IBViewBackground.frame.size.width)];
    }
    else
    {
        NSLog(@"Portrait");
        [_publisher.view setFrame:CGRectMake(5, _UIViewVideo.frame.size.height -130, 70, 70)];
        [_subscriber.view setFrame:CGRectMake(0, 0, _IBViewBackground.frame.size.width,_IBViewBackground.frame.size.height)];
        
    }
    
}

@end
