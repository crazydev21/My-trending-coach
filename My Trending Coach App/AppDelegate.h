//
//  AppDelegate.h
//  My Trending Coach App
//
//  Created by Nisarg on 07/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSpinKitView.h"
#import <UserNotifications/UserNotifications.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

{
    RTSpinKitView *objSpinKit;
    UIView *viewShowLoad;
    UIActivityIndicatorView *spinner;
    UIView *PopupView;
    
}

@property (strong, nonatomic) NSString *strNotiDate;


@property (strong, nonatomic) UIImage *appEditImage;
@property (strong, nonatomic) NSString *strEditImageTag;
@property (strong, nonatomic) NSString *strrandomNumber;
@property (strong, nonatomic) NSString *strWriteReview;
@property (strong, nonatomic) NSString *strPlayerId;
@property (strong, nonatomic) NSString *strCoachName;
@property (strong, nonatomic) NSString *strCoachId;

@property (strong, nonatomic) NSURL *UrlVideoFile;

@property (strong, nonatomic) NSMutableArray *arrappEditImage;

@property (strong, nonatomic) NSURL *urlImgPath;


@property (strong, nonatomic) NSString *strVideoRandId;

//@property (strong, nonatomic) NSString *strcurrentTimeZone;


///////// for Filter Video ////////

@property (strong, nonatomic) NSString *strFilterTitle;
@property (strong, nonatomic) NSString *strFilterSportType;
@property (strong, nonatomic) NSString *strFilterNotes;


@property (strong, nonatomic) NSString *strCalendarDate;
@property (strong, nonatomic) NSMutableArray *aryCalendarDate;
@property (strong, nonatomic) NSMutableArray *aryCalendarStatus;
@property (strong, nonatomic) NSMutableArray *aryPlayerIDs;

@property (strong, nonatomic) NSString *strPlayerCoachTag;
@property (strong, nonatomic) NSString *strPlayerstrVideoPath;

@property (strong, nonatomic) NSString *strPlayerSendVideoPath;
@property (strong, nonatomic) NSString *strPlayerSendVideo;
@property (strong, nonatomic) NSString *strPlayerSendThumbPath;
@property (strong, nonatomic) NSString *strPlayerSendThumb;

@property (strong, nonatomic) NSString *strPlayerCheck;

@property (strong, nonatomic) NSMutableArray *dicNotificationVideoFiles;

@property (strong, nonatomic) UIWindow *window;

-(void)startLoadingview :(NSString *)strMessage;
-(void)stopLoadingview;
-(void)showAlertMessage:(NSString *)strMessage;

@property (nonatomic) BOOL isSaved;
@property (nonatomic) BOOL isSavedAgain;
@property (nonatomic) BOOL isReviewed;

@property (nonatomic) BOOL isstartSession;

@property (nonatomic) BOOL isSavedProfile;

@property (strong, nonatomic) NSString *strCoachtoPlayerId;
@property (strong, nonatomic) NSString *strRequestID;

@property (nonatomic) BOOL isEndLiveStream;

@end

