    //
//  AppDelegate.m
//  My Trending Coach App
//
//  Created by Nisarg on 07/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "LGSideMenuController.h"


#import "CalendarViewController.h"

#import "VideoFilterPage.h"
#import "VideoDetailPage.h"

#import "EditPlayerDetailPage.h"
#import "CoachDetailPage.h"
#import "LoginPage.h"
#import "VideoChatViewController.h"
#import "ClubDetailPage.h"

#import "CustomAlertNotification.h"
#import "RWBlurPopover.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize arrappEditImage,strEditImageTag,dicNotificationVideoFiles,strrandomNumber,strWriteReview,strPlayerId,strCoachName,strCoachId,strCalendarDate;


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    _isSaved = NO;
    [NSThread sleepForTimeInterval:3.0];
    
    arrappEditImage = [[NSMutableArray alloc]init ];
    strEditImageTag = [[NSString alloc]init ];
    strWriteReview = [[NSString alloc]init ];
    _strNotiDate = [[NSString alloc]init ];
    
    
       application.statusBarHidden = YES;
    
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
//    {
//#ifdef __IPHONE_8_0
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
//#endif
//    } else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound|UIUserNotificationTypeAlert;
//        [application registerForRemoteNotificationTypes:myTypes];
//    }

    
//    VideoFilterPage *vp = [[VideoFilterPage alloc]initWithNibName:@"VideoFilterPage" bundle:nil ];
//    self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:vp ];
    
    
//        CalendarViewController *vp = [[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil ];
//        self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:vp ];
    
    
//
//    NSDate *today = [NSDate date];
//  
//    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
//    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
//    
//    NSString *selectedDatetoday =[dateFormatter1 stringFromDate:today];
//    
//    _strcurrentTimeZone = [selectedDatetoday substringFromIndex: [selectedDatetoday length] - 5];
//    NSLog(@"strcurrentTimeZone=%@",_strcurrentTimeZone);
    
   
   
    
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"LoggedIn"];
    NSLog(@"Login===%@",Login);
    if ([Login isEqualToString:@"YESFORCLUB"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClubDetailPage *mv =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
        self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
    }
    else if ([Login isEqualToString:@"YES"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LGSideMenuController *mv =[storyboard instantiateViewControllerWithIdentifier:@"LGSideMenuController"];
        self.window.rootViewController = mv;
    }
    else
    {
        LoginPage *mv = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
    }
    
    
    
    if (launchOptions) { //launchOptions is not nil
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        dicNotificationVideoFiles = [[NSMutableArray alloc]init ];
        dicNotificationVideoFiles = [userInfo valueForKey:@"aps"];
        
        if (dicNotificationVideoFiles) { //apsInfo is not nil
            [self performSelector:@selector(NotificationView)
                       withObject:nil
                       afterDelay:1];
        }
    }
    
    
    
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                       UIUserNotificationTypeSound categories:nil]];
    }
    if (localNotif)
    {
        NSLog(@"localNotif=%@",localNotif);
        _strNotiDate = [localNotif.userInfo objectForKey:@"Date"];
        NSLog(@"_strNotiDate=%@",_strNotiDate);
        
        [self GetRemindar];
        
    }
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSLog(@"tzName=%@",tzName);
    [[NSUserDefaults standardUserDefaults] setObject:tzName forKey:@"TimeZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"notification=%@",notification);
    _strNotiDate = [notification.userInfo objectForKey:@"Date"];
    
    [self GetRemindar];
}

-(void)GetRemindar
{
//    if (appDelegate.isstartSession == NO)
//    {
//        NSString *Login = [[NSUserDefaults standardUserDefaults]
//                           stringForKey:@"Login"];
//         appDelegate.isSavedProfile = YES;
//        if ([Login isEqualToString:@"Coach"])
//        {
//            CoachDetailPage *mv =[[CoachDetailPage alloc] initWithNibName:@"CoachDetailPage" bundle:nil];
//            mv.strCoachEdit = @"Coach";
//            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
//        }
//        else
//        {
//            EditPlayerDetailPage *mv =[[EditPlayerDetailPage alloc] initWithNibName:@"EditPlayerDetailPage" bundle:nil];
//            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
//        }
//        
//    }
//    
   
}



//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSString *strDeviveToken = [[[[deviceToken description]
//                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
//                                stringByReplacingOccurrencesOfString: @" " withString: @""];
//    [[NSUserDefaults standardUserDefaults] setObject:strDeviveToken forKey:@"userDeviceToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    NSLog(@"strDeviveToken  :   %@",strDeviveToken);
//    
//    [[NSUserDefaults standardUserDefaults]setObject:strDeviveToken forKey:@"DeviceToken"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
//}




- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"userInfo Push Notification  :   %@",userInfo);
    
    dicNotificationVideoFiles = [[NSMutableArray alloc]init ];
    dicNotificationVideoFiles = [userInfo valueForKey:@"aps"];
    
    NSLog(@"dicNotificationVideoFiles :   %@",dicNotificationVideoFiles);

    
    if (dicNotificationVideoFiles != nil)
    {
        [self performSelector:@selector(NotificationView) withObject:nil afterDelay:1.0];
    }
    else
    {
        NSLog(@"localNotif=%@",userInfo);
        
        _strNotiDate = [userInfo objectForKey:@"Date"];
        NSLog(@"_strNotiDate=%@",_strNotiDate);
        
        [self GetRemindar];
    }
  
}

-(void)NotificationView
{
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Coach"])
    {
        int randomno = arc4random() % 9000 + 1000;
        strrandomNumber = [NSString stringWithFormat:@"%d",randomno];
        NSLog(@"strrandomNumber %@",strrandomNumber);
        
        arrappEditImage = [[NSMutableArray alloc]init];
        
        
        if ([[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"request"])
        {
         
            strCalendarDate = [[NSString alloc] init];
            strCalendarDate= [dicNotificationVideoFiles valueForKey:@"date"];
            
            if (![strCalendarDate isEqualToString:@""])
            {
                strCalendarDate=[strCalendarDate substringToIndex:10];
            }
            NSLog(@"strCalendarDate :   %@",strCalendarDate);
            
            
            strPlayerId = [[NSString alloc] init];
            strPlayerId= [dicNotificationVideoFiles valueForKey:@"player_id"];
            NSLog(@"strPlayerId :   %@",strPlayerId);
            
            [[NSUserDefaults standardUserDefaults]setObject:strPlayerId forKey:@"Playerid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
           

            NSLog(@"appDelegate.aryCalendarDate=%@",appDelegate.aryCalendarDate);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"%@",[dicNotificationVideoFiles valueForKey:@"alert"]] delegate:self cancelButtonTitle:@"Go to calendar" otherButtonTitles:nil , nil];
            alert.tag = 1;
            [alert show];

        }
        else if (![[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"live_stream"])
        {
            
            strPlayerId = [[NSString alloc] init];
            strPlayerId= [dicNotificationVideoFiles valueForKey:@"playerid"];
            NSLog(@"strPlayerId :   %@",strPlayerId);
            
            NSLog(@" playerIDs==%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"%@ ",[dicNotificationVideoFiles valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
            
            [alert show];

//            VideoPlayerPage *vp = [[VideoPlayerPage alloc]initWithNibName:@"VideoPlayerPage" bundle:nil ];
//            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:vp ];
            
        }
        else if ([[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"livestream_start"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"%@",[dicNotificationVideoFiles valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
            
            [alert show];
            //            MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            //            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
            
            
        }

    
        

    }
    else if ([Login isEqualToString:@"Club"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClubDetailPage *mv =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
        self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
    }
    else
    {
        if ([[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"live_stream"] || [[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"livestream_start"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"%@",[dicNotificationVideoFiles valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
         
            [alert show];
//            MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];


        }
        else if ([[dicNotificationVideoFiles valueForKey:@"path"] isEqualToString:@"coach_video"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"%@ ",[dicNotificationVideoFiles valueForKey:@"alert"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
            
            [alert show];
            
        }
        else
        {
            strCoachId = [[NSString alloc] init];
            strCoachId= [dicNotificationVideoFiles valueForKey:@"coachid"];
            NSLog(@"strCoachId :   %@",strCoachId);
            
            strCoachName = [[NSString alloc] init];
            strCoachName= [dicNotificationVideoFiles valueForKey:@"coachname"];
            NSLog(@"strCoachName :   %@",strCoachName);
            
//            MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//            self.window.rootViewController =  [[UINavigationController alloc]initWithRootViewController:mv ];
        }
        
    }

}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
           
        }
        
    }
    // NSLog(@"ava=%@",Aryavailability);
}



/////// REMOTE NOTIFICATION //////

#pragma mark - Remote Notification Delegate // <= iOS 9.x

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",strDevicetoken);
    
    [[NSUserDefaults standardUserDefaults]setObject:strDevicetoken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}




#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //   NSLog(@"userInfo Push Notification  :   %@",response.notification.request.content.userInfo);
    
    dicNotificationVideoFiles = [[NSMutableArray alloc]init ];
    dicNotificationVideoFiles = [notification.request.content.userInfo valueForKey:@"aps"];
    
    NSLog(@"dicNotificationVideoFiles :   %@",dicNotificationVideoFiles);
    
    if (dicNotificationVideoFiles != nil)
    {
          [self performSelector:@selector(NotificationView) withObject:nil afterDelay:1.0];
    }
    else
    {
        NSLog(@"localNotif=%@",notification.request.content.userInfo);
        
        _strNotiDate = [notification.request.content.userInfo objectForKey:@"Date"];
        NSLog(@"_strNotiDate=%@",_strNotiDate);
        
        [self GetRemindar];
    }
    completionHandler(UNNotificationPresentationOptionBadge);
   // completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
 //   NSLog(@"userInfo Push Notification  :   %@",response.notification.request.content.userInfo);
    
    dicNotificationVideoFiles = [[NSMutableArray alloc]init ];
    dicNotificationVideoFiles = [response.notification.request.content.userInfo valueForKey:@"aps"];
    
    NSLog(@"dicNotificationVideoFiles :   %@",dicNotificationVideoFiles);
    
    if (dicNotificationVideoFiles != nil)
    {
        [self performSelector:@selector(NotificationView) withObject:nil afterDelay:1.0];
    }
    else
    {
        NSLog(@"localNotif=%@",response.notification.request.content.userInfo);
        
        _strNotiDate = [response.notification.request.content.userInfo objectForKey:@"Date"];
        NSLog(@"_strNotiDate=%@",_strNotiDate);
        
        [self GetRemindar];
        
    }

    
    completionHandler();

}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//
//    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
//    
//  
//}

#pragma mark - Loader

-(void)startLoadingview :(NSString *)strMessage
{
    // DISPLAY CUSTOM LOADING SCREEN WHEN THIS METHOD CALLS.
    
    viewShowLoad=[[UIView alloc]init];
   
    viewShowLoad.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    viewShowLoad.backgroundColor =[UIColor clearColor];
    
    // SET THE VIEW INSIDE MAIN VIEW
    UIView *viewUp=[[UIView alloc] initWithFrame:viewShowLoad.frame];
    viewUp.backgroundColor=[UIColor blackColor];
    viewUp.alpha=0.5;
    [viewShowLoad addSubview:viewUp];
    
    // CUSTOM ACTIVITY INDICATOR
//    objSpinKit=[[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleBounce color:[UIColor whiteColor]];
//    objSpinKit.center = CGPointMake(CGRectGetMidX(viewShowLoad.frame), CGRectGetMidY(viewShowLoad.frame));
//    [objSpinKit startAnimating];
//    [viewShowLoad addSubview:objSpinKit];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(viewShowLoad.frame.size.width/2.0, viewShowLoad.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    [viewShowLoad addSubview:spinner];
    
    [spinner startAnimating];
    
    // SET THE LABLE
    UILabel *lblLoading=[[UILabel alloc] initWithFrame:CGRectMake(0, spinner.frame.origin.y + 30, viewShowLoad.frame.size.width, 50)];
    lblLoading.font=[UIFont systemFontOfSize:18.0];
    lblLoading.text=strMessage;
    lblLoading.numberOfLines = 0;
    lblLoading.backgroundColor=[UIColor clearColor];
    lblLoading.textColor=[UIColor whiteColor];
    lblLoading.textAlignment=NSTextAlignmentCenter;
    [viewShowLoad addSubview:lblLoading];
    
    [self.window addSubview:viewShowLoad];
}

-(void)stopLoadingview
{
    [spinner stopAnimating];
    //[objSpinKit stopAnimating];
    [viewShowLoad removeFromSuperview];
}


- (void)showAlertMessage:(NSString *)strMessage{
    
    if (self.window.rootViewController.presentedViewController) {
        [CustomAlertNotification show:self.window.rootViewController.presentedViewController.view message:strMessage];
    } else{
        [CustomAlertNotification show:self.window.rootViewController.view message:strMessage];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSLog(@"tzName=%@",tzName);
    [[NSUserDefaults standardUserDefaults] setObject:tzName forKey:@"TimeZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    application.statusBarHidden = YES;
    
    if ([self.window.rootViewController.presentedViewController isKindOfClass: [VideoDetailPage class]])
    {
        VideoDetailPage *secondController = (VideoDetailPage *) self.window.rootViewController.presentedViewController;
        
        if (secondController.isPresented)
            return UIInterfaceOrientationMaskLandscape;
        else return UIInterfaceOrientationMaskPortrait;
    }
    else if ([self.window.rootViewController.presentedViewController isKindOfClass: [VideoChatViewController class]])
    {
            return UIInterfaceOrientationMaskAll;
    }

    else return UIInterfaceOrientationMaskPortrait;
}

@end
