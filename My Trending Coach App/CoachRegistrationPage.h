//
//  CoachRegistrationPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 10/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "TextFieldRegistration.h"
#import "TextFieldRegistrationDrop.h"


#import <Google/SignIn.h>
#import <GTLRGmail.h>

@interface CoachRegistrationPage : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SharedClassDelegate,UIDocumentPickerDelegate,MWPhotoBrowserDelegate, GIDSignInDelegate, GIDSignInUIDelegate>
{
    NSString *strSportType, *strSportDay;
    NSMutableArray *arySportsType, *arySportsDay;
    NSString *strImageTag,*strCertificate,*strResume;
    UIImage *imgCertificate;
    NSMutableArray *arycountries,*arystates;
    BOOL TagState;
}

@property (weak, nonatomic) IBOutlet UILabel *IBLabelHeader;

@property (nonatomic, strong) NSMutableArray *photos;


@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldUsername;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldEmail;
//@property (weak, nonatomic) IBOutlet UITextField *IBTextSportsClub;

@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldpwd;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldSelectCountry;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldSelectState;

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRGmailService *service;
    
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldGraduated;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextRateforSession;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextRateforVideo;
@property (weak, nonatomic) IBOutlet UITextView *IBTextBio;


@property (strong, nonatomic) IBOutlet UIButton *IBButtonMonday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonTuesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonWednesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonThursday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonFriday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSaturday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSunday;


@property (weak, nonatomic) IBOutlet UIButton *IBButtonRegister;

@property (strong, nonatomic) NSString *strEditTag;

@property (weak, nonatomic) IBOutlet UIButton *IBImageProfile;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageCertificate;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageResume;

@property (strong, nonatomic) NSString *strClubID;

- (IBAction)IBButtonClickProfile:(id)sender;

- (IBAction)IBButtonClickAllTypes:(id)sender;


- (IBAction)IBButtonClickRegister:(id)sender;



- (IBAction)IBButtonClickBack:(id)sender;

@end
