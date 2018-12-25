//
//  ClubSignUpPage.h
//  MTC
//
//  Created by Bhavin on 6/8/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldRegistration.h"
#import "TextFieldRegistrationDrop.h"

@interface ClubSignUpPage : UIViewController
{
    NSMutableArray *arycountries,*arystates;
    BOOL TagState;
}

@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldname;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldEmail;

@property (weak, nonatomic) IBOutlet TextFieldRegistration *IBTextFieldpwd;
@property (weak, nonatomic) IBOutlet UITextView *IBTextBio;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelBio;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldLocation;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *IBTextFieldState;

@property (weak, nonatomic) IBOutlet UIButton *IBImageProfile;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelHeader;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;


@property (strong, nonatomic) NSString *strEditTag;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonRegister;

@end
