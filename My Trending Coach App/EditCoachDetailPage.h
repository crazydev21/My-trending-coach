//
//  EditCoachDetailPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 11/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView/HCSStarRatingView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "FSCalendar.h"


@interface EditCoachDetailPage : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SharedClassDelegate,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
{
    NSMutableArray *aryPhotos,*aryVideos;
    NSString *strUserType,*strSportType,*strImagePathProfile,*strRating;
    NSMutableArray *arySportsType;
    
  //  NSString *strCalenderDates;
    NSMutableArray *calendarDateary,*aryCalName;
    NSDate *newDate;
    NSArray *arySportsName;
     BOOL SaveChangeTag;
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UIView *IBViewMainCalender;
@property (weak, nonatomic) IBOutlet FSCalendar *IBViewCalendar;


@property (strong, nonatomic) NSMutableDictionary *borderDefaultColors;


- (IBAction)IBButtonClickCancel:(id)sender;
- (IBAction)IBButtonClickOk:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightContentVew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightTopView;

@property (weak, nonatomic) IBOutlet UIView *IBViewSports;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightViewSports;

@property (weak, nonatomic) IBOutlet UILabel *IBLabelAge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelGender;

@property (weak, nonatomic) IBOutlet UILabel *IBLabelRate;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightPhoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightVideo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightAppointmentVw;



@property (weak, nonatomic) IBOutlet UIImageView *IBImagebg;
@property (weak, nonatomic) IBOutlet UIScrollView *IBScrollView;
@property (weak, nonatomic) IBOutlet UIView *topview;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *IBViewRating;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldName;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldEmail;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelEducation;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldSelectCountry;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldRate;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldCertificate;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldSelectGraduate;

@property (weak, nonatomic) IBOutlet UIImageView *IBImageProfile;
- (IBAction)IBButtonClickProfile:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *IBViewPhotos;
@property (weak, nonatomic) IBOutlet UIView *IBViewVideo;
@property (weak, nonatomic) IBOutlet UIView *IBViewAppointment;

- (IBAction)IBButtonClickPhotos:(id)sender;
- (IBAction)IBButtonClickVideos:(id)sender; 

- (IBAction)IBButtonClickCalendar:(id)sender;


- (IBAction)IBButtonClickEdit:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *IBButtonTennis;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonGolf;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonBasball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonFootball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonWresling;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCricket;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPerTrainer;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonOther;

- (IBAction)IBButtonClickAllTypes:(id)sender;



- (IBAction)IBButtonClickBack:(id)sender;


@property(nonatomic,assign) int notificationID;

@end
