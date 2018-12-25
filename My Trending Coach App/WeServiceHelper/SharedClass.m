//
//  SharedClass.m
//  BoxCore
//
//  Created by Binty Shah on 11/17/14.
//  Copyright (c) 2014 Agile Infoways Pvt. Ltd. All rights reserved.
//

#import "SharedClass.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "SharedDelegate.h"
#import "Base64.h"


#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define baseURL @"http://websitetestingbox.com/php/treding_coach/web_service/"

@implementation SharedClass
{
    int cnt;
}

static SharedClass *sharedInstance = NULL;
@synthesize delegate;

// Get the shared instance and create it if necessary.
+ (SharedClass *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}

// User Login API
-(void)userLogin :(NSString *)strUserName password : (NSString *)strPassword
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    
    NSString  *DeviceToken =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"]];
    NSLog(@"DeviceToken : %@",DeviceToken);
    
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@login.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserName forKey:@"email"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:DeviceToken forKey:@"reg_id"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)userFacebookTokenLogin:(NSString *)facebookToken
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    
    NSString  *DeviceToken =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"]];
    NSLog(@"DeviceToken : %@",DeviceToken);
    
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@login.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:facebookToken forKey:@"facebook_token"];
    [request setPostValue:DeviceToken forKey:@"reg_id"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
    
    -(void)userGmailTokenLogin:(NSString *)gmailToken
    {
        
        [appDelegate startLoadingview:@"Loading..."];
        
        // CHECK NETWORK AVAILABLE OR NOT
        if(![[SharedDelegate sharedDelegate] checkNetwork])
        {
            NSLog(@"Network not available");
            return;
        }
        
        
        NSString  *DeviceToken =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"]];
        NSLog(@"DeviceToken : %@",DeviceToken);
        
        
        NSString  *escapedUrlString =[NSString stringWithFormat:@"%@login.php",baseURL];
        NSLog(@"escapedUrlString : %@",escapedUrlString);
        
        NSURL *url = [NSURL URLWithString:escapedUrlString];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"POST"];
        [request setPostValue:gmailToken forKey:@"gmail_token"];
        [request setPostValue:DeviceToken forKey:@"reg_id"];
        [request setPostValue:@"IOS" forKey:@"device"];
        
        [request setTag:Other_Detail_Tag];
        [request setTimeOutSeconds:600];
        [request setDelegate:self];
        [request startAsynchronous];
        
    }

// User Logout API
-(void)Logout :(NSString *)strUserType
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@logout.php",baseURL];
    NSLog(@"id : %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:strUserType forKey:@"user_type"];
    if ([strUserType isEqualToString:@"Club"])
    {
        [request setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"club_id"] forKey:@"user_id"];
    }
    else
    {
        [request setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] forKey:@"user_id"];
    }
    
    
    [request setTag:Other_Detail_Tag2];
    [request setTimeOutSeconds:90];
    [request setDelegate:self];
    [request startAsynchronous];
    
}



// Player Edit & Registration API

-(void)playerRegistration :(NSString *)strUserName email : (NSString *)strEmail password : (NSString *)strPassword gender:(NSString *)strGender location:(NSString *)strLocation age:(NSString *)strAge usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  skills:(NSString *)strSkills  cno:(NSString *)CNo cmonth:(NSString *)CMonth cyear:(NSString *)CYear profileImage : (UIImage *)profileimage state:(NSString *)strState
             facebookToken:(NSString*)facebookToken gmailToken:(NSString*)gmailToken
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *DeviceToken =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"]];
    NSLog(@"DeviceToken : %@",DeviceToken);
    
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@user_player.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserName forKey:@"name"];
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strLocation forKey:@"location"];
    [request setPostValue:strState forKey:@"state"];
    [request setPostValue:strAge forKey:@"age"];
    [request setPostValue:@"Player" forKey:@"user_type"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strGender forKey:@"gender"];
    [request setPostValue:strSkills forKey:@"skill"];
    [request setPostValue:DeviceToken forKey:@"reg_id"];
    [request setPostValue:@"IOS" forKey:@"device"];
    [request setPostValue:facebookToken forKey:@"facebook_token"];
    [request setPostValue:gmailToken forKey:@"gmail_token"];
    
    NSData *imageData = UIImageJPEGRepresentation(profileimage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"PlayerProfileImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"photo"];
    
    
    //    [request setPostValue:CNo forKey:@"card_no"];
    //    [request setPostValue:CMonth forKey:@"card_month"];
    //    [request setPostValue:CYear forKey:@"card_year"];
    
    // [request setPostValue:imageBase64 forKey:@"photo"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)playerEdit :(NSString *)strUserName email : (NSString *)strEmail playerid : (NSString *)strPlayerID gender:(NSString *)strGender location:(NSString *)strLocation age:(NSString *)strAge usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  skills:(NSString *)strSkills profileImage : (UIImage *)profileimage password : (NSString *)strPassword state:(NSString *)strState
{
    
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@edit_profile_player.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserName forKey:@"name"];
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strLocation forKey:@"location"];
    [request setPostValue:strState forKey:@"state"];
    [request setPostValue:strAge forKey:@"age"];
    [request setPostValue:@"Player" forKey:@"user_type"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strGender forKey:@"gender"];
    [request setPostValue:strSkills forKey:@"skill"];
    [request setPostValue:strPassword forKey:@"password"];
    
    NSData *imageData = UIImageJPEGRepresentation(profileimage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"PlayerProfileImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"photo"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


// Coach Edit & Registration API

-(void)coachRegistration :(NSString *)strUserName email : (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation rate:(NSString *)strRate usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  sports_club : (NSString *)strSportsClub rateforsession : (NSString *)strRateforSession rateforvideo : (NSString *)strRateforVideo bio : (NSString *)strBio profileImage : (UIImage *)Profileimage certificate : (NSString *)strCertificate resume : (NSString *)strResume imgcertificate : (UIImage *)imgCertificate state:(NSString *)strState strflexible_days:(NSString *)strFlexible_days facebookToken:(NSString*)facebookToken gmailToken:(NSString*)gmailToken
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@user_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserName forKey:@"name"];
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strLocation forKey:@"location"];
    [request setPostValue:strState forKey:@"state"];
    [request setPostValue:strSportsClub forKey:@"sports_club"];
    [request setPostValue:strRateforSession forKey:@"rate_session"];
    [request setPostValue:strRateforVideo forKey:@"rate_video"];
    [request setPostValue:strBio forKey:@"bio"];
    [request setPostValue:@"Coach" forKey:@"user_type"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strFlexible_days forKey:@"flexible_days"];
    [request setPostValue:facebookToken forKey:@"facebook_token"];
    [request setPostValue:gmailToken forKey:@"gmail_token"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(Profileimage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"CoachProfileImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"photo"];
    
    //    if (imgCertificate == nil)
    //    {
    //        NSArray *Exten = [strCertificate componentsSeparatedByString:@"."];
    //        NSString *strDataFileExtension = [NSString stringWithFormat:@"certificate%@.%@",string,[Exten lastObject]];
    //
    //        NSData *datacerti = [NSData dataWithContentsOfFile:strCertificate];
    //        [request setData:datacerti withFileName:strDataFileExtension andContentType:@"txt/rtf/doc/docx/pdf/ppt/pptx/xls/xlsx/png/jpeg" forKey:@"certificate"];
    //
    //    }
    //    else
    //    {
    //        NSString *imgStr = [NSString stringWithFormat:@"Image%@.png",string];
    //        NSLog(@"imgStr%@",imgStr);
    //
    //        NSData *datacerti = UIImagePNGRepresentation(imgCertificate);
    //        [request setData:[NSData dataWithData:datacerti] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"certificate"];
    //
    //    }
    
    NSArray *Exten = [strResume componentsSeparatedByString:@"."];
    NSString *strDataFileExtension = [NSString stringWithFormat:@"resume%@.%@",string,[Exten lastObject]];
    
    NSData *dataresume = [NSData dataWithContentsOfFile:strResume];
    [request setData:dataresume withFileName:strDataFileExtension andContentType:@"doc/docx/pdf" forKey:@"resume"];
    
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}

-(void)coachEdit :(NSString *)strUserName email : (NSString *)strEmail coachid : (NSString *)strCoachID location:(NSString *)strLocation rate:(NSString *)strRate usertype:(NSString *)strUserType sporttype:(NSString *)strSportType rating:(NSString *)strRating profileImage : (UIImage *)Profileimage sports_club : (NSString *)strSportsClub rateforsession : (NSString *)strRateforSession rateforvideo : (NSString *)strRateforVideo bio : (NSString *)strBio password : (NSString *)strPassword certificate : (NSString *)strCertificate resume : (NSString *)strResume imgcertificate : (UIImage *)imgCertificate state:(NSString *)strState strflexible_days:(NSString *)strFlexible_days

{
    //    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:profileimage];
    //
    //    NSString *imageBase64=[Base64 encode:file1Data];
    
    // NSData *imageData = UIImagePNGRepresentation(profileimage);
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@edit_profile_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserName forKey:@"name"];
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strLocation forKey:@"location"];
    [request setPostValue:strState forKey:@"state"];
    // [request setPostValue:strRate forKey:@"rate"];
    // [request setPostValue:strRating forKey:@"rating"];
    [request setPostValue:@"Coach" forKey:@"user_type"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strCertificate forKey:@"certificate"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    //[request setPostValue:strSportsClub forKey:@"sports_club"];
    [request setPostValue:strRateforSession forKey:@"rate_session"];
    [request setPostValue:strRateforVideo forKey:@"rate_video"];
    [request setPostValue:strBio forKey:@"bio"];
    [request setPostValue:strPassword forKey:@"password"];
    
    [request setPostValue:strFlexible_days forKey:@"flexible_days"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(Profileimage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"CoachProfileImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"photo"];
    
    if (strCertificate.length != 0)
    {
        NSArray *Exten = [strCertificate componentsSeparatedByString:@"."];
        NSString *strDataFileExtension = [NSString stringWithFormat:@"certificate%@.%@",string,[Exten lastObject]];
        // NSLog(@"strDataFileExtension=%@",strDataFileExtension);
        
        // strCertificate = [strCertificate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSData *datacerti = [NSData dataWithContentsOfFile:strCertificate];
        [request setData:datacerti withFileName:strDataFileExtension andContentType:@"txt/rtf/doc/docx/pdf/ppt/pptx/xls/xlsx/png/jpeg" forKey:@"certificate"];
    }
    else if(imgCertificate != nil)
    {
        //        NSString *imgStr = [NSString stringWithFormat:@"Image%@.png",string];
        //        NSLog(@"imgStr%@",imgStr);
        //
        //        NSData *datacerti = UIImagePNGRepresentation(imgCertificate);
        //        [request setData:[NSData dataWithData:datacerti] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"certificate"];
        //
    }
    
    if (strResume.length != 0)
    {
        NSArray *Exten = [strResume componentsSeparatedByString:@"."];
        NSString *strDataFileExtension = [NSString stringWithFormat:@"resume%@.%@",string,[Exten lastObject]];
        // NSLog(@"strDataFileExtension=%@",strDataFileExtension);
        
        NSData *dataresume = [NSData dataWithContentsOfFile:strResume];
        [request setData:dataresume withFileName:strDataFileExtension andContentType:@"doc/docx/pdf" forKey:@"resume"];
        
    }
    
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)playerDetail:(NSString *)strID
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@detail_player.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strID forKey:@"player_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    [request setTag:Player_Details];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)coachDetail:(NSString *)strID
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    NSLog(@"TimeZone==%2",[timeZone name]);
    
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@detail_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    //    [request setPostValue:[timeZone name] forKey:@"timezone"];
    [request setPostValue:strID forKey:@"coach_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Coach_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)coachList :(NSString *)strID country : (NSString *)strCountry sporttype : (NSString *)strSportType name : (NSString *)strName rating : (NSString *)strRating user_type : (NSString *)strUser_type state : (NSString *)strState
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@list_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strID forKey:@"id"];
    [request setPostValue:strUser_type forKey:@"user_type"];
    [request setPostValue:strCountry forKey:@"country"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strName forKey:@"sports_club"];
    [request setPostValue:strRating forKey:@"rating"];
    [request setPostValue:strState forKey:@"state"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)PlayerList
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    // http://websitetestingbox.com/php/treding_coach/web_service/list_player.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@list_player.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)sendCoachVideoWithPlayerId :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSData *movieData = [NSData dataWithContentsOfFile:VideoFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *videostr = [NSString stringWithFormat:@"PlayerVideo%@.mp4",string];
    NSLog(@"videostr%@",videostr);
    
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/send_notification.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/send_notification.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strRandID forKey:@"random_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:strNotes forKey:@"notes"];
    [request setPostValue:strVideoReq forKey:@"video_request"];
    [request setPostValue:@"Coach" forKey:@"user_type"];
    
    NSString *imgStr = [NSString stringWithFormat:@"PlayerVideoImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    NSData *imageData = UIImagePNGRepresentation(thumbImage);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"thumbnail"];
    
    [request setData:movieData withFileName:videostr andContentType:@"multipart/form-data" forKey:@"file"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    // [request addFile:VideoFile withFileName:videostr andContentType:@"mov/mp4" forKey:@"file"];
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)sendNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage {
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSData *movieData = [NSData dataWithContentsOfFile:VideoFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *videostr = [NSString stringWithFormat:@"PlayerVideo%@.mp4",string];
    NSLog(@"videostr%@",videostr);
    
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/send_notification.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/send_notification.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strRandID forKey:@"random_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:strNotes forKey:@"notes"];
    [request setPostValue:strVideoReq forKey:@"video_request"];
    [request setPostValue:@"Player" forKey:@"user_type"];
    
    NSString *imgStr = [NSString stringWithFormat:@"PlayerVideoImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    NSData *imageData = UIImagePNGRepresentation(thumbImage);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"thumbnail"];
    
    [request setData:movieData withFileName:videostr andContentType:@"multipart/form-data" forKey:@"file"];
    
    // [request addFile:VideoFile withFileName:videostr andContentType:@"mov/mp4" forKey:@"file"];
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)sendNotificationwithPath :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofilename :(NSString *)VideoFileName videofile :(NSString *)VideoFile thumbname :(NSString *)thumbName thumb :(NSString *)thumb
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/send_notification.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/send_notification.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strRandID forKey:@"random_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:strNotes forKey:@"notes"];
    [request setPostValue:strVideoReq forKey:@"video_request"];
    [request setPostValue:@"Player" forKey:@"user_type"];
    
    
    [request setPostValue:VideoFileName forKey:@"str_video"];
    [request setPostValue:VideoFile forKey:@"str_video_path"];
    [request setPostValue:thumbName forKey:@"str_thumbnail"];
    [request setPostValue:thumb forKey:@"str_thumbnail_path"];
    
    
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)changeVideoStatus:(NSString*)status requestid :(NSString *)requestid
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_change_status.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:status forKey:@"status"];
    [request setPostValue:requestid forKey:@"video_id"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)sendNotificationWithVideotoPlayer :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSData *movieData = [NSData dataWithContentsOfFile:VideoFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    
    NSString *videostr = [NSString stringWithFormat:@"PlayerVideo%@.mp4",string];
    NSLog(@"videostr%@",videostr);
    
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/send_notification.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/video_coach_send_notification.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strRandID forKey:@"random_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:strNotes forKey:@"notes"];
    [request setPostValue:strVideoReq forKey:@"video_request"];
    [request setPostValue:@"Coach" forKey:@"user_type"];
    
    NSString *imgStr = [NSString stringWithFormat:@"PlayerVideoImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    NSData *imageData = UIImagePNGRepresentation(thumbImage);
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"thumbnail"];
    
    [request setData:movieData withFileName:videostr andContentType:@"multipart/form-data" forKey:@"file"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    // [request addFile:VideoFile forKey:@"file"];
    
    // [request addFile:VideoFile withFileName:videostr andContentType:@"mov/mp4" forKey:@"file"];
    
    
    
    //    NSString *imageString = [movieData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //    [request setPostValue:imageString forKey:@"file"];
    
    //    cnt = 0;
    //    NSTimer *TimerProgress = [NSTimer scheduledTimerWithTimeInterval: 1
    //                                                     target: self
    //                                                   selector:@selector(ProgressChange:)
    //                                                   userInfo: nil repeats:YES];
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)sendNotificationWithVideotoPlayerPath :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofilename :(NSString *)VideoFileName videofile :(NSString *)VideoFile thumbname :(NSString *)thumbName thumb :(NSString *)thumb
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/video_coach_send_notification.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strSportType forKey:@"sport_type"];
    [request setPostValue:strRandID forKey:@"random_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:strNotes forKey:@"notes"];
    [request setPostValue:strVideoReq forKey:@"video_request"];
    [request setPostValue:@"Coach" forKey:@"user_type"];
    
    
    [request setPostValue:VideoFileName forKey:@"str_video"];
    [request setPostValue:VideoFile forKey:@"str_video_path"];
    [request setPostValue:thumbName forKey:@"str_thumbnail"];
    [request setPostValue:thumb forKey:@"str_thumbnail_path"];
    
    
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}




//-(void)ProgressChange:(NSTimer *)timer
//{
//    cnt++;
//    NSLog(@"cnt=%d",cnt);
//}

-(void)saveEditedImage :(NSString *)strPlayerID coachid : (NSString *)strCoachID randomid : (NSString *)strRandom_ID image :(UIImage *)Editedimage
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSData *imageData = UIImagePNGRepresentation(Editedimage);
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@save_image.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strRandom_ID forKey:@"random_id"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"Editedimage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"image"];
    
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)sendMail :(NSString *)strPlayerID coachid : (NSString *)strCoachID randomid : (NSString *)strRandom_ID reviewtext :(NSString *)strReviewtext
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/send_email.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strRandom_ID forKey:@"random_id"];
    [request setPostValue:strReviewtext forKey:@"review_text"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)userForgotPassword :(NSString *)strEmail
{
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    [appDelegate startLoadingview:@"Loading..."];
    
    //    http://websitetestingbox.com/php/treding_coach/web_service/forgot_password.php
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@forgot_password.php",baseURL];
    
    NSURL *url = [NSURL URLWithString:[escapedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strEmail forKey:@"email"];
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)SendFeedback :(NSString *)strCoachID rating:(NSString *)strRating feedback:(NSString *)strFeedback
{
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    [appDelegate startLoadingview:@"Loading..."];
    
    //    http://websitetestingbox.com/php/treding_coach/web_service/send_feedback.php
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@send_feedback.php",baseURL];
    
    NSURL *url = [NSURL URLWithString:[escapedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strRating forKey:@"rating"];
    [request setPostValue:strFeedback forKey:@"feedback"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)UploadCoachMediaFile :(NSString *)strCoachID name:(NSString *)strName video:(NSString *)strVideo image:(UIImage *)Image
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    
    
    ////Videos
    NSData *movieData = [NSData dataWithContentsOfFile:strVideo];
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyyMMddHHmmss";
    //    NSString *string = [formatter stringFromDate:[NSDate date]];
    
    NSString *vidStr = [NSString stringWithFormat:@"CoachUpdatedVideos.mp4"];
    NSLog(@"vidStr%@",vidStr);
    
    
    ////Photos
    NSData *imageData = UIImagePNGRepresentation(Image);
    
    NSString *imgStr = [NSString stringWithFormat:@"CoachUpdatedImages.png"];
    NSLog(@"imgStr%@",imgStr);
    
    //http://websitetestingbox.com/php/treding_coach/web_service/coach_files.php
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@coach_files.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    
    
    if (strVideo.length == 0)
    {
        [request setPostValue:imgStr forKey:@"name"];
        [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"coach_photo"];
        
    }
    else
    {
        [request setPostValue:vidStr forKey:@"name"];
        [request setData:movieData withFileName:vidStr andContentType:@"multipart/form-data" forKey:@"coach_photo"];
    }
    
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}




-(void)sendLiveStreamNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID datetime : (NSString *)strDateTime status : (NSString *)strStatus
{
    //    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/request_notification_coach.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/request_notification_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"user_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strDateTime forKey:@"start_date_time"];
    [request setPostValue:strStatus forKey:@"status"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)confirmLiveStreamNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID datetime : (NSString *)strDateTime status : (NSString *)strStatus
{
    //    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    // http://websitetestingbox.com/php/treding_coach/web_service/notification/confirm_notification_user.php
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@notification/confirm_notification_user.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerID forKey:@"user_id"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strDateTime forKey:@"start_date_time"];
    [request setPostValue:strStatus forKey:@"status"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}




-(void)CoachVideoList:(NSString *)strUserId usertype : (NSString *)strUserType video_request : (NSString *)strvideo_request usertypevideo : (NSString *)strUserTypeVideo
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_list_coach.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserId forKey:@"user_id"];
    [request setPostValue:strUserType forKey:@"user_type"];
    [request setPostValue:strvideo_request forKey:@"video_request"];
    [request setPostValue:strUserTypeVideo forKey:@"user_type"];
    NSString *timeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"TimeZone"];
    [request setPostValue:timeZone forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)playerVideoList:(NSString *)strUserId usertype : (NSString *)strUserType video_request : (NSString *)strvideo_request usertypevideo : (NSString *)strUserTypeVideo
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_list.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserId forKey:@"user_id"];
    [request setPostValue:strUserType forKey:@"user_type"];
    // [request setPostValue:strvideo_request forKey:@"video_request"];
    // [request setPostValue:strUserTypeVideo forKey:@"user_type_video"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)playerVideoDetail:(NSString *)strRandId
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_details.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strRandId forKey:@"random_id"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)DeleteVideo:(NSString *)strID playerid : (NSString *)strPlayerID coachid : (NSString *)strCoachID
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@delete_video.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strID forKey:@"id"];
    [request setPostValue:strPlayerID forKey:@"player_id"];
    if (strCoachID.length > 0)
        [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setTag:Other_Detail_Tag8];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

//-(void)DeleteVideo:(NSString *)strID playerid : (NSString *)strPlayerID coachid : (NSString *)strCoachID
//{
//
//    [appDelegate startLoadingview:@"Loading..."];
//
//    // CHECK NETWORK AVAILABLE OR NOT
//    if(![[SharedDelegate sharedDelegate] checkNetwork])
//    {
//        NSLog(@"Network not available");
//        return;
//    }
//
//    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@delete_video.php",baseURL];
//    NSLog(@"escapedUrlString : %@",escapedUrlString);
//
//    NSURL *url = [NSURL URLWithString:escapedUrlString];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//
//    [request setRequestMethod:@"POST"];
//    [request setPostValue:strID forKey:@"id"];
//    [request setPostValue:strPlayerID forKey:@"player_id"];
//    [request setPostValue:strCoachID forKey:@"coach_id"];
//    [request setTag:Other_Detail_Tag8];
//    [request setTimeOutSeconds:180];
//    [request setDelegate:self];
//    [request startAsynchronous];
//}


-(void)UpdateVideoDetail:(NSString *)strVideo_ID title : (NSString *)strTitle notes : (NSString *)stsNotes
{
    
    [appDelegate startLoadingview:@"Loading..."];
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_details_update.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strVideo_ID forKey:@"video_id"];
    [request setPostValue:strTitle forKey:@"title"];
    [request setPostValue:stsNotes forKey:@"notes"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag2];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)TalkBox:(NSString *)strID userid : (NSString *)strUserId usertype : (NSString *)strUserType
{
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    // http://websitetestingbox.com/php/treding_coach/web_service/tokbox.php
    [appDelegate startLoadingview:@"Loading..."];
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@tokbox1.php",baseURL];
    
    NSURL *url = [NSURL URLWithString:[escapedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strID forKey:@"appointment_id"];
    [request setPostValue:strUserId forKey:@"user_id"];
    [request setPostValue:strUserType forKey:@"user_type"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)GetAvaibility:(NSString *)strUserId passing_value : (NSString *)strPassingValue date : (NSString *)strDate
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString = [NSString stringWithFormat:@"%@availability.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserId forKey:@"playerid"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strDate forKey:@"date"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Player_Detail];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)SetAvaibility:(NSString *)strUserId passing_value : (NSString *)strPassingValue date : (NSString *)strDate start_time : (NSString *)strstart_time end_time : (NSString *)strend_time repeat : (NSString *)strrepeat approve : (NSString *)strapprove
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@availability.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strUserId forKey:@"playerid"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strDate forKey:@"date"];
    [request setPostValue:strstart_time forKey:@"start_time"];
    [request setPostValue:strend_time forKey:@"end_time"];
    [request setPostValue:strrepeat forKey:@"repeat"];
    [request setPostValue:@"" forKey:@"approve"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    
    [request setTag:Other_Detail_Tag2];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)RequestToCoachForLiveStream:(NSString *)strPlayerId coachid:(NSString *)strCoachid date:(NSString *)date startTime:(NSString *)startTime endTime:(NSString *)endTime passing_value:(NSString *)strPassingValue
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerId forKey:@"playerid"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachid forKey:@"coachid"];
    
    [request setPostValue:date forKey:@"date"];
    [request setPostValue:startTime forKey:@"start_time"];
    [request setPostValue:endTime forKey:@"end_time"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag4];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)RequestAppointmentList:(NSString *)strCoachid passing_value: (NSString *)strPassingValue
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachid forKey:@"coachid"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag5];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)RequestAppointmentListForPlayer:(NSString *)strPlayerid passing_value: (NSString *)strPassingValue
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strPlayerid forKey:@"playerid"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag5];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)DeleteRequestAppointmentFromList:(NSString *)strRequest_id passing_value: (NSString *)strPassingValue user_type: (NSString *)struser_type
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strRequest_id forKey:@"request_id"];
    [request setPostValue:struser_type forKey:@"user_type"];
    
    [request setTag:Other_Detail_Tag8];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)DeleteRequest:(NSString *)strRequest_id
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"delete_pending_appointment" forKey:@"passing_value"];
    [request setPostValue:strRequest_id forKey:@"request_id"];
//    [request setPostValue:@"coach" forKey:@"user_type"];
    
    [request setTag:Other_Detail_Tag6];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)RequestApproveFromCoach:(NSString *)strCoachid playerid : (NSString *)strPlayerId passing_value: (NSString *)strPassingValue start_date_time:(NSString *)strstart_date_time endDateTime:(NSString *)endDateTime request_id: (NSString *)strrequest_id
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPlayerId forKey:@"playerid"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachid forKey:@"coachid"];
    [request setPostValue:strstart_date_time forKey:@"start_date_time"];
    [request setPostValue:endDateTime forKey:@"end_date_time"];
    [request setPostValue:strrequest_id forKey:@"request_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag4];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)deleteCoach:(NSString *)strCoachid clubId:(NSString*)clubId
{
    
    [appDelegate startLoadingview:@"Loading..."];

    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }

    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@delete_coach_club.php",baseURL];

    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    [request setRequestMethod:@"POST"];
    [request setPostValue:strCoachid forKey:@"coach_id"];
    [request setPostValue:clubId forKey:@"club_id"];


    [request setTag:Other_Detail_Tag4];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}



-(void)PendingAppointmentList:(NSString *)strUserid passing_value: (NSString *)strPassingValue user: (NSString *)strUser
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@appointment.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strUserid forKey:strUser];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"TimeZone"] forKey:@"timezone"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)CountryList
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@get_countries.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setTag:Other_Detail_Tag7];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)StateList :(NSString *)strCountryid
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@get_states.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:strCountryid forKey:@"country_id"];
    
    [request setRequestMethod:@"POST"];
    [request setTag:Other_Detail_Tag8];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)ClubDetail:(NSString *)strClubid passing_value: (NSString *)strPassingValue sport_type:(NSString *)strSport_type
{
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    // http://websitetestingbox.com/php/treding_coach/web_service/tokbox.php
//    [appDelegate startLoadingview:@"Loading..."];
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club.php",baseURL];
    
    NSURL *url = [NSURL URLWithString:[escapedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strClubid forKey:@"club_id"];
    [request setPostValue:strSport_type forKey:@"sport_name"];
    
    [request setTag:Other_Detail_Tag4];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

// Coach Edit & Registration API

-(void)clubRegistration :(NSString *)strClubName email: (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation bio : (NSString *)strBio clubImage : (UIImage *)ClubImage state:(NSString *)strState
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *DeviceToken =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"]];
    NSLog(@"DeviceToken : %@",DeviceToken);
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"add_club" forKey:@"passing_value"];
    [request setPostValue:strClubName forKey:@"club_name"];
    [request setPostValue:strEmail forKey:@"club_email"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strLocation forKey:@"club_location"];
    [request setPostValue:strState forKey:@"state"];
    [request setPostValue:strBio forKey:@"club_bio"];
    [request setPostValue:DeviceToken forKey:@"reg_id"];
    [request setPostValue:@"IOS" forKey:@"device"];
    
    NSData *imageData = UIImageJPEGRepresentation(ClubImage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"ClubImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"club_image"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}

-(void)clubEdit :(NSString *)strClubID clubName: (NSString *)strClubName email: (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation bio : (NSString *)strBio clubImage : (UIImage *)ClubImage state:(NSString *)strState
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"update_club_profile" forKey:@"passing_value"];
    [request setPostValue:strClubName forKey:@"club_name"];
    [request setPostValue:strEmail forKey:@"club_email"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strLocation forKey:@"club_location"];
    [request setPostValue:strState forKey:@"state"];
    [request setPostValue:strBio forKey:@"club_bio"];
    [request setPostValue:strClubID forKey:@"club_id"];
    
    NSData *imageData = UIImageJPEGRepresentation(ClubImage,1.0);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    // NSLog(@"Data%@",string);
    
    NSString *imgStr = [NSString stringWithFormat:@"ClubImage%@.png",string];
    NSLog(@"imgStr%@",imgStr);
    
    [request setData:[NSData dataWithData:imageData] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"club_image"];
    
    [request setTag:Other_Detail_Tag];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


-(void)AddCoachtoClub:(NSString *)strClubid coachid : (NSString *)strCoachID passing_value: (NSString *)strPassingValue
{
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    // http://websitetestingbox.com/php/treding_coach/web_service/tokbox.php
    [appDelegate startLoadingview:@"Loading..."];
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club_request.php",baseURL];
    
    NSURL *url = [NSURL URLWithString:[escapedUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strClubid forKey:@"club_id"];
    
    [request setTag:Other_Detail_Tag8];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)RequestClubList:(NSString *)strCoachid passing_value: (NSString *)strPassingValue
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club_request.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachid forKey:@"coach_id"];
    
    [request setTag:Other_Detail_Tag7];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)ClubRequestAD:(NSString *)strClubid coachid : (NSString *)strCoachID passing_value: (NSString *)strPassingValue status: (NSString *)strStatus
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club_request.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:strPassingValue forKey:@"passing_value"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    [request setPostValue:strClubid forKey:@"club_id"];
    [request setPostValue:strStatus forKey:@"status"];
    
    [request setTag:Other_Detail_Tag9];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}


-(void)AddCertificate:(NSString *)strCoachID  certificate : (NSString *)strCertificate imgcertificate : (UIImage *)imgCertificate
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@cerificates.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"add_cerficate" forKey:@"passing_value"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    
    if (imgCertificate == nil)
    {
        NSArray *Exten = [strCertificate componentsSeparatedByString:@"."];
        NSString *strDataFileExtension = [NSString stringWithFormat:@"certificate%@.%@",string,[Exten lastObject]];
        
        NSData *datacerti = [NSData dataWithContentsOfFile:strCertificate];
        [request setData:datacerti withFileName:strDataFileExtension andContentType:@"txt/rtf/doc/docx/pdf/ppt/pptx/xls/xlsx/png/jpeg" forKey:@"certificate[]"];
        
    }
    else
    {
        NSString *imgStr = [NSString stringWithFormat:@"Image%@.png",string];
        NSLog(@"imgStr%@",imgStr);
        
        NSData *datacerti = UIImagePNGRepresentation(imgCertificate);
        [request setData:[NSData dataWithData:datacerti] withFileName:imgStr andContentType:@"png/jpeg" forKey:@"certificate[]"];
        
    }
    
    
    [request setTag:Other_Detail_Tag10];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}


-(void)GetAllCertificates:(NSString *)strCoachID
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@cerificates.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"get_all" forKey:@"passing_value"];
    [request setPostValue:strCoachID forKey:@"coach_id"];
    
    
    
    [request setTag:Other_Detail_Tag11];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)DeleteCertificate:(NSString *)strCertificateID
{
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@cerificates.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"delete" forKey:@"passing_value"];
    [request setPostValue:strCertificateID forKey:@"certificate_id"];
    
    
    
    [request setTag:Other_Detail_Tag12];
    [request setTimeOutSeconds:180];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)ClubsList:(NSString *)strSport_type
{
    
    [appDelegate startLoadingview:@"Loading..."];
    
    // CHECK NETWORK AVAILABLE OR NOT
    if(![[SharedDelegate sharedDelegate] checkNetwork])
    {
        NSLog(@"Network not available");
        return;
    }
    
    NSString  *escapedUrlString =[NSString stringWithFormat:@"%@club.php",baseURL];
    NSLog(@"escapedUrlString : %@",escapedUrlString);
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
//    [request setPostValue:@"get_list_by_sport" forKey:@"passing_value"];
    [request setPostValue:@"get_all" forKey:@"passing_value"];
    [request setPostValue:strSport_type forKey:@"sport_name"];
    [request setRequestMethod:@"POST"];
    [request setTag:Other_Detail_Tag8];
    [request setTimeOutSeconds:600];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


#pragma mark -  ASIHTTP Methods
/// -------------------
- (void)setProgress:(float)newProgress
{
    NSLog(@"newProgress %2f",newProgress);
    NSLog(@"%2f",newProgress*100);
    //    [appDelegate startLoadingview:@"Loading..."];
    //    appDelegate.HUD.progress =newProgress;
}

-(void)requestStart:(ASIHTTPRequest *)request
{
    //   AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //   [appDelegate showMBHUD];
    
}
- (void)requestDone:(ASIHTTPRequest *)request
{
    // NSString *response = [request responseString];
    // AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate stopLoadingview];
    
}
- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    //  NSError *error = [request error];
    //  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate stopLoadingview];
}

#pragma mark Req Finished

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [appDelegate stopLoadingview];
    
    if (request.tag == Player_Detail )
    {
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails_PlayerDetail:)]) {
                [delegate getUserDetails_PlayerDetail:dictUserDetails];
            }
        }
        
    } else if (request.tag == Player_Details) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(didReceivePlayerDetails:)]) {
                [delegate didReceivePlayerDetails:dictUserDetails];
            }
        }
    }
    else if (request.tag==Coach_Detail)
    {
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails_CoachDetail:)]) {
                [delegate getUserDetails_CoachDetail:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails:)]) {
                [delegate getUserDetails:dictUserDetails];
            }
        }
        
    }
    
    else if (request.tag== Other_Detail_Tag2)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails2:)]) {
                [delegate getUserDetails2:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag4)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails4:)]) {
                [delegate getUserDetails4:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag5)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails5:)]) {
                [delegate getUserDetails5:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag6)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails6:)]) {
                [delegate getUserDetails6:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag7)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails7:)]) {
                [delegate getUserDetails7:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag8)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails8:)]) {
                [delegate getUserDetails8:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag9)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails9:)]) {
                [delegate getUserDetails9:dictUserDetails];
            }
        }
        
    }
    
    
    
    else if (request.tag== Other_Detail_Tag10)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails10:)]) {
                [delegate getUserDetails10:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag11)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails11:)]) {
                [delegate getUserDetails11:dictUserDetails];
            }
        }
        
    }
    else if (request.tag== Other_Detail_Tag12)
    {
        
        NSString *responseString = [request responseString];
        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
        [appDelegate stopLoadingview];
        
        if (responseDic)
        {
            NSDictionary *dictUserDetails = responseDic;
            responseDic =nil;
            
            if ([delegate respondsToSelector:@selector(getUserDetails12:)]) {
                [delegate getUserDetails12:dictUserDetails];
            }
        }
        
    }
    
    
    
    
    //    if (request.tag==USER_LOGIN_API_CALL)
    //    {
    //        NSString *responseString = [request responseString];
    //        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
    //        [appDelegate stopLoadingview];
    //
    //        if (responseDic)
    //        {
    //            NSDictionary *dictUserDetails = responseDic;
    //            responseDic =nil;
    //
    //            if ([delegate respondsToSelector:@selector(getUserDetails_USER_LOGIN_API_CALL:)]) {
    //                [delegate getUserDetails_USER_LOGIN_API_CALL:dictUserDetails];
    //            }
    //
    //            responseDic =nil;
    //
    //            if ([delegate respondsToSelector:@selector(getPlayerRegistrationDetails_PLAYER_REGISTRATION_API_CALL:)]) {
    //                [delegate getPlayerRegistrationDetails_PLAYER_REGISTRATION_API_CALL:dictUserDetails];
    //            }
    //
    //        }
    //        else
    //        {
    //        }
    //    }
    //    else if (request.tag == PLAYER_REGISTER_API_CALL)
    //    {
    //        NSString *responseString = [request responseString];
    //        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
    //        [appDelegate stopLoadingview];
    //
    //        if (responseDic)
    //        {
    //            NSDictionary *dictUserDetails = responseDic;
    //            responseDic =nil;
    //
    //            if ([delegate respondsToSelector:@selector(getPlayerRegistrationDetails_PLAYER_REGISTRATION_API_CALL:)]) {
    //                [delegate getPlayerRegistrationDetails_PLAYER_REGISTRATION_API_CALL:dictUserDetails];
    //            }
    //        }
    //        else
    //        {
    //        }
    //    }
    //    else if (request.tag == USER_FORGOTPASSWORD_API_CALL)
    //    {
    //        NSString *responseString = [request responseString];
    //        NSDictionary *responseDic = (NSDictionary*)[responseString JSONValue];
    //        [appDelegate stopLoadingview];
    //
    //        if (responseDic)
    //        {
    //            NSDictionary *dictUserDetails = responseDic;
    //            responseDic =nil;
    //
    //            if ([delegate respondsToSelector:@selector(getUserForgotPassword_USER_FORGOTPASSWORD_API_CALL:)]) {
    //                [delegate getUserForgotPassword_USER_FORGOTPASSWORD_API_CALL:dictUserDetails];
    //            }
    //        }
    //        else
    //        {
    //        }
    //    }
    
}

//+ (void)GetDateNumber :(NSString *) String
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *string = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"Data%@",string);
//
//    return string;
//}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are not connected to the Internet. Please check your Internet connection and try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [appDelegate stopLoadingview];
}

#pragma mark - Methods to set and get the user info

- (void)saveUser:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"user"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
- (NSDictionary*)getUser{
    return   [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
}

- (BOOL)currentUserTypePlayer{
    
    NSString* curUserType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Login"] lowercaseString];
    return [curUserType isEqualToString:@"player"];
}

//#pragma mark -  MBProgressHud Methods
//
////MBProgressHud
//-(void)start_Loading
//{
//    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
//    HUD = [[MBProgressHUD alloc] initWithView:self.view] ;
//
//    // Add HUD to screen
//    [self.view addSubview:HUD];
//
//    //	HUD.animationType = MBProgressHUDAnimationZoom;
//    //    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
//
//    HUD.mode = MBProgressHUDModeAnnularDeterminate;
//
//    // Regisete for HUD callbacks so we can remove it from the window at the right time
//    //	HUD.delegate = self;
//
//    HUD.taskInProgress = YES;
//
//    HUD.labelText = @"Uploading...";
//    
//    HUD.detailsLabelText = @"Please wait";
//    
//    [HUD show:YES];
//    
//    //     [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
//}
//
//- (void)doSomeFunkyStuff {
//    float progress = 0.0;
//    
//    while (progress < 1.0) {
//        progress += 0.01;
//        HUD.progress = progress;
//        usleep(50000);
//    }
//}
//
//- (void)stop_Loading
//{
//    [HUD hide:YES];
//    [HUD removeFromSuperview];
//}

@end
