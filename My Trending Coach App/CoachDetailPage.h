//
//  CoachDetailPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 21/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "FSCalendar.h"

@interface CoachDetailPage : UIViewController <SharedClassDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UIDocumentPickerDelegate>
{
    NSMutableArray *aryPhotos,*aryVideos;
    NSMutableArray *arySportsType;
    NSString *strCoachImagePath;
    NSString *strVideoOption;
    UIButton *Streaming,*Record;
    
    NSArray *calendarary;
    NSMutableArray *calendarDateary;
    NSArray *arySportsName;
    NSString *strResume;
    NSMutableArray *aryRequestList;
    
    NSString *strCertificate;
    UIImage *imgCertificate;
}

@property (strong, nonatomic) IBOutlet UIView *IBViewMainCalender;
@property (weak, nonatomic) IBOutlet FSCalendar *IBViewCalendar;

@property (strong, nonatomic) NSMutableDictionary *borderDefaultColors;

- (IBAction)IBButtonClickRemoveView:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightContentVew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountTopEdge;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightClub;


@property (weak, nonatomic) IBOutlet UIView *IBViewSports;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountHeightViewSports;

@property (weak, nonatomic) IBOutlet UILabel *IBLabelRate;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *IBViewRating;
@property (weak, nonatomic) IBOutlet UIImageView *IBImagebg;

@property (weak, nonatomic) IBOutlet UIImageView *IBImageProfie;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelName;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelEmail;

@property (weak, nonatomic) IBOutlet UILabel *IBLabelClubName;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldName;
@property (weak, nonatomic) IBOutlet UILabel *IBTextFieldLocation;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldEmail;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelEducation;
@property (weak, nonatomic) IBOutlet UILabel *IBLableRateforVideo;
@property (weak, nonatomic) IBOutlet UILabel *IBLableRateforSession;

@property (strong, nonatomic) NSString *couchId;


@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldRate;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldGraduatedForm;

@property (weak, nonatomic) IBOutlet UIView *IBViewVideo;
@property (weak, nonatomic) IBOutlet UIImageView *IBViewPhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *IBCollectionViewVideo;
@property (weak, nonatomic) IBOutlet UICollectionView *IBCollectionViewPhoto;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonHire;

- (IBAction)IBButtonClickHire:(id)sender;
- (IBAction)IBButtonClickBack:(id)sender;

- (IBAction)IBButtonClickCalendar:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonTennis;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonGolf;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonBasball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonFootball;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonWresling;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCricket;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPerTrainer;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonOther;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonSendVideo;
@property (weak, nonatomic) IBOutlet UIButton *IBButonLiveStream;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonSendVideo1;

- (IBAction)IBButonClickSendVideo:(id)sender;

- (IBAction)IBButonClickLiveStream:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonEdit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBNSLayountTopEdgeCoach;
@property (weak, nonatomic) IBOutlet UIView *IBViewCoach;


@property (strong, nonatomic) IBOutlet UIView *IBViewPopUp;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelHeaderPopUp;

@property (strong, nonatomic) IBOutlet UITableView *IBTblPopUp;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonClose;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonAR;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPA;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelBadge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelRequestBadge;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelVideoBadge;

@property (weak, nonatomic) IBOutlet UILabel *IBTextviewBio;

@property (strong, nonatomic) NSString *strCoachEdit;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonCR;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelClubBadge;
@property (strong, nonatomic) NSString *strClubID;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCertificate;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonResume;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonAddCertificate;
@property (weak, nonatomic) IBOutlet UITextView *IBTextFlexibledays;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *shortMenu;



@end
