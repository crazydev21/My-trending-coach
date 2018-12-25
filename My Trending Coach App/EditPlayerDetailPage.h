//
//  EditPlayerDetailPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 11/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "BBView.h"


@interface EditPlayerDetailPage : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SharedClassDelegate,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
{
    NSString *strGender,*strUserType,*strSportType,*strImagePath;
    NSMutableArray *arySportsType;
    
    NSMutableArray *aryCalDate,*aryCalStatus,*aryCalName;
    NSDate *newDate;
    
    NSArray *arySportsName;
    
    BOOL SaveChangeTag;
    NSTimer *timer;
    NSMutableArray *aryPlayerList;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightContentVew;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightTopView;

@property (weak, nonatomic) IBOutlet UIView *IBViewSports;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightViewSports;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldName;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldEmail;

@property (weak, nonatomic) IBOutlet UIView *IBViewAppointment;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelAge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelGender;
@property (weak, nonatomic) IBOutlet UILabel *IBTextSkill;


@property (weak, nonatomic) IBOutlet UIImageView *IBImageProfile;
- (IBAction)IBButtonClickProfile:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *IBButtonMale;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonFemale;
- (IBAction)IBButtonMFSelection:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldAge;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldSkill;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldSelectCountry;



@property (weak, nonatomic) IBOutlet UIButton *IBButtonTennis;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonGolf;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonBasball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonFootball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonWresling;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCricket;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPerTrainer;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonOther;

- (IBAction)IBButtonClickAllTypes:(id)sender;

- (IBAction)IBButtonClickEdit:(id)sender;

- (IBAction)IBButtonClickBack:(id)sender;

@property(nonatomic,assign) int notificationID;


@property (strong, nonatomic) IBOutlet UIView *IBViewPopUp;
@property (strong, nonatomic) IBOutlet UITableView *IBTblPopUp;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonClose;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonVideo;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonAR;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPA;

@property (strong, nonatomic) IBOutlet UIView *IBViewMainCalender;
@property (weak, nonatomic) IBOutlet FSCalendar *IBViewCalendar;
@property (strong, nonatomic) NSMutableDictionary *borderDefaultColors;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelBadge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelRequestBadge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelVideoBadge;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonEdit;


@end
