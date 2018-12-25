//
//  PlayerRegistrationPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 09/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPCard.h"
#import "Stripe.h"
#import "TextFieldRegistration.h"
#import "TextFieldRegistrationDrop.h"

#import <Google/SignIn.h>
#import <GTLRGmail.h>

@interface PlayerRegistrationPage : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SharedClassDelegate, GIDSignInDelegate, GIDSignInUIDelegate>
{
    NSString *strGender,*strUserType,*strSportType;
    NSMutableArray *arySportsType;
    NSMutableArray *arycountries,*arystates;
    BOOL TagState;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelHeader;
@property (weak, nonatomic) IBOutlet UIView *IBViewRegisterIcon;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonMale;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonFemale;
- (IBAction)IBButtonMFSelection:(id)sender;

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRGmailService *service;


@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldFirstUsername;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldEmail;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldpwd;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldAge;
@property (weak, nonatomic) IBOutlet UITextView *IBTextSkill;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelSkill;

@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldSelectCountry;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldSelectState;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldGender;


@property (weak, nonatomic) IBOutlet UIButton *IBButtonRegister;

@property (strong, nonatomic) NSMutableArray *agesArray;

- (IBAction)IBButtonClickAllTypes:(id)sender;


- (IBAction)IBButtonClickRegister:(id)sender;

- (IBAction)IBButtonClickBack:(id)sender;

@property (strong, nonatomic) NSString *strEditTag;

@property (weak, nonatomic) IBOutlet UIButton *IBImageProfile;
- (IBAction)IBButtonClickProfile:(id)sender;

///////// Payment Page //////

@property (nonatomic, strong) STPCard* stripeCard;

@property (strong, nonatomic) IBOutlet UIView *IBViewPayment;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldCNo;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldCMonth;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldCYear;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldCCVV;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCSave;
- (IBAction)IBButtonClickCSave:(id)sender;

@end
