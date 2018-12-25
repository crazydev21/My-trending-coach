//
//  LoginPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 10/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "LoginPage.h"
#import "PlayerRegistrationPage.h"
#import "CoachRegistrationPage.h"
#import "MainViewController.h"
#import "CustomIOSAlertView.h"
#import "ClubSignUpPage.h"
#import "ClubDetailPage.h"
#import "TextFieldRegistration.h"
#import "CustomAlertNotification.h"
#import "TextInputAlert.h"
#import "LGSideMenuController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <Google/SignIn.h>
#import <GTLRGmail.h>
#import "GTMOAuth2ViewControllerTouch.h"

@interface LoginPage () <GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet TextFieldRegistration *emailView;
@property (weak, nonatomic) IBOutlet TextFieldRegistration *passwordView;
@property (strong, nonatomic) TextInputAlert *textInputAlert;
    @property (nonatomic, strong) GTLRGmailService *service;

@end

@implementation LoginPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.navigationController.navigationBarHidden = YES;
     strKeepmeLogin = @"LoggedIn";
    
    self.emailView.titleLabel.text = @"EMAIL";
    self.passwordView.titleLabel.text = @"PASSWORD";
    
    self.passwordView.textField.secureTextEntry = YES;
    
    self.textInputAlert = [[TextInputAlert alloc] init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL) isValidEmail:(NSString *)checkString
{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)IBButtonClickKeepmelogin:(id)sender
{
    if ([strKeepmeLogin isEqualToString:@"LoggedIn"])
    {
        strKeepmeLogin = @"NotLoggedIn";
        [_IBButtonKeepmelogin setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
    }
    else
    {
        strKeepmeLogin = @"LoggedIn";
        [_IBButtonKeepmelogin setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateNormal];
    }
}
    
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        self.service.authorizer = nil;
    } else {
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        
        NSString *accessToken = user.authentication.accessToken;
        
        if(accessToken){
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared userGmailTokenLogin:accessToken];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter gmail" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        
        [self fetchLabels];
    }
}
    
    // Construct a query and get a list of labels from the user's gmail. Display the
    // label name in the UITextView
- (void)fetchLabels {
    GTLRGmailQuery_UsersLabelsList *query = [GTLRGmailQuery_UsersLabelsList queryWithUserId:@"me"];
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}
    
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRGmail_ListLabelsResponse *)labelsResponse
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *labelString = [[NSMutableString alloc] init];
        if (labelsResponse.labels.count > 0) {
            [labelString appendString:@"Labels:\n"];
            for (GTLRGmail_Label *label in labelsResponse.labels) {
                [labelString appendFormat:@"%@\n", label.name];
            }
        } else {
            [labelString appendString:@"No labels found."];
        }
    } else {
    }
}
    
- (IBAction)gmailAuthButtonTapped:(id)sender {
    
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeGmailReadonly, nil];

    [signIn signIn];
}
    
- (IBAction)facebookAuthButtonTapped:(id)sender {
    
    NSString *accessToken = [[FBSDKAccessToken currentAccessToken]tokenString];
    
    if(accessToken){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error){
                 SharedClass *shared =[SharedClass sharedInstance];
                 shared.delegate =self;
                 [shared userFacebookTokenLogin:accessToken];
             }else
             NSLog(@"Error %@",error);
         }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter facebook" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)IBButtonClickLogin:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.emailView.textField.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter email"];
        
    }
    else if (![self isValidEmail:self.emailView.textField.text])
    {
        [appDelegate showAlertMessage:@"Please enter valid email"];
    }
    
    else if (self.passwordView.textField.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter password"];
    }
    else
    {
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared userLogin:self.emailView.textField.text password:self.passwordView.textField.text];
    }
}

 /////////  MARK : -  Get Login Response       ////////

-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails_USER_LOGIN_API_CALL  :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"information"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        NSString *SignUp = [[NSString alloc] init];
        SignUp = [information valueForKey:@"User Type"];
        NSLog(@"%@",SignUp);
        
        
        if ([strKeepmeLogin isEqualToString:@"LoggedIn"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoggedIn"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LoggedIn"];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([SignUp isEqualToString:@"Player"] || [SignUp isEqualToString:@"player"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"id"] forKey:@"id"];

            [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:@"Login"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[information valueForKey:@"Card No"] forKey:@"CardNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:[information valueForKey:@"Card Month"] forKey:@"CardMonth"];
            [[NSUserDefaults standardUserDefaults] setObject:[information valueForKey:@"Card Year"] forKey:@"CardYear"];
            [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSUserDefaults standardUserDefaults] synchronize];
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            [self.navigationController pushViewController:mv animated:YES];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LGSideMenuController *mv =[storyboard instantiateViewControllerWithIdentifier:@"LGSideMenuController"];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = mv;

        }
        else if ([SignUp isEqualToString:@"Coach"] || [SignUp isEqualToString:@"coach"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Coach" forKey:@"Login"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"id"] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            [self.navigationController pushViewController:mv animated:YES];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LGSideMenuController *mv =[storyboard instantiateViewControllerWithIdentifier:@"LGSideMenuController"];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = mv;
        }
        else
        {
            if ([strKeepmeLogin isEqualToString:@"LoggedIn"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"YESFORCLUB" forKey:@"LoggedIn"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LoggedIn"];
            }

            [[NSUserDefaults standardUserDefaults] setObject:@"Club" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"id"] forKey:@"club_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ClubDetailPage *mv =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
            
//            [[[UIApplication sharedApplication] delegate] window].rootViewController = mv;
            [self.navigationController pushViewController:mv animated:YES];
        }
    }
    else
    {
        [CustomAlertNotification show:self.view message:message];
    }
}

 /////////  MARK : -   Forgot Password Button     ////////

- (IBAction)IBButtonClickForgotpwd:(id)sender
{
    [self.textInputAlert show:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.textInputAlert.didSubmit = ^{
        if ([weakSelf.textInputAlert.textField.text length] != 0) {
            
            if (![weakSelf isValidEmail:weakSelf.textInputAlert.textField.text]) {
                
                [appDelegate showAlertMessage:@"Please enter valid email"];
                
            }else{
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate = weakSelf;
                [shared userForgotPassword:weakSelf.textInputAlert.textField.text];
                [weakSelf.textInputAlert removeFromSuperview];
            }
        }else{
            
            [appDelegate showAlertMessage:@"Please enter email"];
        }
    };
}

 /////////  MARK : -   For Pwd Get Data     ////////

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    [appDelegate showAlertMessage:message];
}

- (IBAction)IBButtonClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)IBButtonClickPlayerSignup:(id)sender{
    PlayerRegistrationPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerRegistrationPage"];
    pr.strEditTag = @"Register";
    [self showViewController:pr sender:self];
}

- (IBAction)IBButtonClickCoachSignup:(id)sender{
    CoachRegistrationPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachRegistrationPage"];
    pr.strEditTag = @"Register";
    [self showViewController:pr sender:self];
}

- (IBAction)IBButtonClickClubSignUp:(id)sender{
    ClubSignUpPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubSignUpPage"];
    pr.strEditTag = @"Register";
    [self showViewController:pr sender:self];
}

@end
