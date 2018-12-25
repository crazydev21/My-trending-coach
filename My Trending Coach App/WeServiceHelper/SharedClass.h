//
//  SharedClass.h
//  BoxCore
//
//  Created by Binty Shah on 4/14/14.
//  Copyright (c) 2014 Agile Infoways Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Other_Detail_Tag2 102
#define Player_Detail 100
#define Player_Details 28
#define Coach_Detail 101
#define Other_Detail_Tag 99
#define Other_Detail_Tag4 104
#define Other_Detail_Tag5 105
#define Other_Detail_Tag6 106
#define Other_Detail_Tag7 107
#define Other_Detail_Tag8 108
#define Other_Detail_Tag9 109

#define Other_Detail_Tag10 110
#define Other_Detail_Tag11 111
#define Other_Detail_Tag12 112

@protocol SharedClassDelegate <NSObject>
@optional
// ***********************************************

-(void)getUserDetails:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails2:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails_CoachDetail:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails4:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails5:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails6:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails7:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails8:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails9:(NSDictionary *)dicVideoDetials;

-(void)getUserDetails10:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails11:(NSDictionary *)dicVideoDetials;
-(void)getUserDetails12:(NSDictionary *)dicVideoDetials;

-(void)didReceivePlayerDetails:(NSDictionary *)dicVideoDetials;
// ***********************************************

@end

@interface SharedClass : NSObject


+ (SharedClass *)sharedInstance;

@property (nonatomic,assign) id<SharedClassDelegate>delegate;

// ***********************************************

-(void)userLogin :(NSString *)strUserName password : (NSString *)strPassword;
-(void)userFacebookTokenLogin:(NSString *)facebookToken;
-(void)playerRegistration :(NSString *)strUserName email : (NSString *)strEmail password : (NSString *)strPassword gender:(NSString *)strGender location:(NSString *)strLocation age:(NSString *)strAge usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  skills:(NSString *)strSkills  cno:(NSString *)CNo cmonth:(NSString *)CMonth cyear:(NSString *)CYear profileImage : (UIImage *)profileimage state:(NSString *)strState facebookToken:(NSString*)facebookToken gmailToken:(NSString*)gmailToken;


-(void)playerEdit :(NSString *)strUserName email : (NSString *)strEmail playerid : (NSString *)strPlayerID gender:(NSString *)strGender location:(NSString *)strLocation age:(NSString *)strAge usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  skills:(NSString *)strSkills profileImage : (UIImage *)profileimage password : (NSString *)strPassword state:(NSString *)strState;


-(void)coachRegistration :(NSString *)strUserName email : (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation rate:(NSString *)strRate usertype:(NSString *)strUserType sporttype:(NSString *)strSportType  sports_club : (NSString *)strSportsClub rateforsession : (NSString *)strRateforSession rateforvideo : (NSString *)strRateforVideo bio : (NSString *)strBio profileImage : (UIImage *)Profileimage certificate : (NSString *)strCertificate resume : (NSString *)strResume imgcertificate : (UIImage *)imgCertificate state:(NSString *)strState strflexible_days:(NSString *)strFlexible_days facebookToken:(NSString*)facebookToken gmailToken:(NSString*)gmailToken;

-(void)coachEdit :(NSString *)strUserName email : (NSString *)strEmail coachid : (NSString *)strCoachID location:(NSString *)strLocation rate:(NSString *)strRate usertype:(NSString *)strUserType sporttype:(NSString *)strSportType rating:(NSString *)strRating profileImage : (UIImage *)Profileimage sports_club : (NSString *)strSportsClub rateforsession : (NSString *)strRateforSession rateforvideo : (NSString *)strRateforVideo bio : (NSString *)strBio password : (NSString *)strPassword certificate : (NSString *)strCertificate resume : (NSString *)strResume imgcertificate : (UIImage *)imgCertificate state:(NSString *)strState strflexible_days:(NSString *)strFlexible_days;


-(void)userForgotPassword :(NSString *)strEmail;

-(void)SendFeedback :(NSString *)strCoachID rating:(NSString *)strRating feedback:(NSString *)strFeedback;

-(void)UploadCoachMediaFile :(NSString *)strCoachID name:(NSString *)strName video:(NSString *)strVideo image:(UIImage *)Image;

-(void)playerDetail :(NSString *)strID;
-(void)coachDetail :(NSString *)strID;

-(void)coachList :(NSString *)strID country : (NSString *)strCountry sporttype : (NSString *)strSportType name : (NSString *)strName rating : (NSString *)strRating user_type : (NSString *)strUser_type state : (NSString *)strState;

-(void)sendNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage;

-(void)sendCoachVideoWithPlayerId :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage;

-(void)sendNotificationwithPath :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofilename :(NSString *)VideoFileName videofile :(NSString *)VideoFile thumbname :(NSString *)thumbName thumb :(NSString *)thumb;

-(void)changeVideoStatus:(NSString*)status requestid :(NSString *)requestid;

-(void)sendNotificationWithVideotoPlayer :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofile :(NSString *)VideoFile thumbimage :(UIImage *)thumbImage;

-(void)sendNotificationWithVideotoPlayerPath :(NSString *)strPlayerID coachid : (NSString *)strCoachID title : (NSString *)strTitle notes : (NSString *)strNotes videoreq : (NSString *)strVideoReq sporttype :(NSString *)strSportType randid :(NSString *)strRandID  videofilename :(NSString *)VideoFileName videofile :(NSString *)VideoFile thumbname :(NSString *)thumbName thumb :(NSString *)thumb;


-(void)saveEditedImage :(NSString *)strPlayerID coachid : (NSString *)strCoachID randomid : (NSString *)strRandom_ID image :(UIImage *)Editedimage;
-(void)sendMail :(NSString *)strPlayerID coachid : (NSString *)strCoachID randomid : (NSString *)strRandom_ID reviewtext :(NSString *)strReviewtext;


-(void)sendLiveStreamNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID datetime : (NSString *)strDateTime status : (NSString *)strStatus;
-(void)confirmLiveStreamNotification :(NSString *)strPlayerID coachid : (NSString *)strCoachID datetime : (NSString *)strDateTime status : (NSString *)strStatus;

-(void)CoachVideoList:(NSString *)strUserId usertype : (NSString *)strUserType video_request : (NSString *)strvideo_request usertypevideo : (NSString *)strUserTypeVideo;

-(void)playerVideoList:(NSString *)strUserId usertype : (NSString *)strUserType video_request : (NSString *)strvideo_request usertypevideo : (NSString *)strUserTypeVideo;
-(void)playerVideoDetail:(NSString *)strRandId;

-(void)DeleteVideo:(NSString *)strID playerid : (NSString *)strPlayerID coachid : (NSString *)strCoachID;

-(void)UpdateVideoDetail:(NSString *)strVideo_ID title : (NSString *)strTitle notes : (NSString *)stsNotes;

-(void)userGmailTokenLogin:(NSString *)gmailToken;

-(void)PlayerList;

-(void)TalkBox:(NSString *)strID userid : (NSString *)strUserId usertype : (NSString *)strUserType;

-(void)Logout :(NSString *)strUserType;

-(void)GetAvaibility:(NSString *)strUserId passing_value : (NSString *)strPassingValue date : (NSString *)strDate;
-(void)SetAvaibility:(NSString *)strUserId passing_value : (NSString *)strPassingValue date : (NSString *)strDate start_time : (NSString *)strstart_time end_time : (NSString *)strend_time repeat : (NSString *)strrepeat approve : (NSString *)strapprove;

-(void)RequestToCoachForLiveStream:(NSString *)strPlayerId coachid:(NSString *)strCoachid date:(NSString *)date startTime:(NSString *)startTime endTime:(NSString *)endTime passing_value:(NSString *)strPassingValue;

-(void)RequestAppointmentList:(NSString *)strCoachid passing_value: (NSString *)strPassingValue;
-(void)DeleteRequestAppointmentFromList:(NSString *)strRequest_id passing_value: (NSString *)strPassingValue user_type: (NSString *)struser_type;

-(void)RequestApproveFromCoach:(NSString *)strCoachid playerid : (NSString *)strPlayerId passing_value: (NSString *)strPassingValue start_date_time:(NSString *)strstart_date_time endDateTime:(NSString *)endDateTime request_id: (NSString *)strrequest_id;

-(void)DeleteRequest:(NSString *)strRequest_id;

-(void)RequestAppointmentListForPlayer:(NSString *)strPlayerid passing_value: (NSString *)strPassingValue;

-(void)PendingAppointmentList:(NSString *)strUserid passing_value: (NSString *)strPassingValue user: (NSString *)strUser;

-(void)CountryList;
-(void)StateList :(NSString *)strCountryid;

// ***********************************************


//  Methods to set and get the user info
- (void)saveUser:(NSDictionary *)dict;
- (NSDictionary*)getUser;
- (BOOL)currentUserTypePlayer;

-(void)ClubDetail:(NSString *)strClubid passing_value: (NSString *)strPassingValue sport_type:(NSString *)strSport_type;
-(void)clubRegistration :(NSString *)strClubName email: (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation bio : (NSString *)strBio clubImage : (UIImage *)ClubImage state:(NSString *)strState;
-(void)clubEdit :(NSString *)strClubID clubName: (NSString *)strClubName email: (NSString *)strEmail password : (NSString *)strPassword location:(NSString *)strLocation bio : (NSString *)strBio clubImage : (UIImage *)ClubImage state:(NSString *)strState;
-(void)AddCoachtoClub:(NSString *)strClubid coachid : (NSString *)strCoachID passing_value: (NSString *)strPassingValue;
-(void)RequestClubList:(NSString *)strCoachid passing_value: (NSString *)strPassingValue;

-(void)ClubRequestAD:(NSString *)strClubid coachid : (NSString *)strCoachID passing_value: (NSString *)strPassingValue status: (NSString *)strStatus;



-(void)AddCertificate:(NSString *)strCoachID  certificate : (NSString *)strCertificate imgcertificate : (UIImage *)imgCertificate;
-(void)GetAllCertificates:(NSString *)strCoachID;
-(void)DeleteCertificate:(NSString *)strCertificateID;

-(void)ClubsList:(NSString *)strSport_type;

-(void)deleteCoach:(NSString *)strCoachid clubId:(NSString*)clubId;


@end
