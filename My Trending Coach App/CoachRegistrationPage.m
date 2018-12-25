//
//  CoachRegistrationPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 10/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "CoachRegistrationPage.h"
#import "MainViewController.h"
#import "LoginPage.h"
#import "ClubDetailPage.h"
#import "CoachDetailPage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LGSideMenuController.h"
#import "AddPhotoAlert.h"
#import "BBView.h"


@interface CoachRegistrationPage () <BBDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet BBView *bubbleView;
@property (strong, nonatomic) AddPhotoAlert *addPhotoAlert;
@property (weak, nonatomic) IBOutlet UIView *txtShadow;


@property (strong, nonatomic) NSString *facebookToken;
@property (strong, nonatomic) NSString *gmailToken;

@end

@implementation CoachRegistrationPage

- (void)viewDidLoad
{
    [super viewDidLoad];

    strResume = @"test info resume";
    
    self.IBButtonMonday.alpha = self.IBButtonTuesday.alpha =
    self.IBButtonWednesday.alpha = self.IBButtonThursday.alpha =
    self.IBButtonFriday.alpha = self.IBButtonSaturday.alpha =
    self.IBButtonSunday.alpha = 0.5;
    
     strSportType= [[NSString alloc]init];
     arySportsType = [[NSMutableArray alloc]init];
     arySportsDay = [[NSMutableArray alloc]init];
    
     self.addPhotoAlert = [[AddPhotoAlert alloc] init];
    
    self.IBTextFieldUsername.titleLabel.text = @"NAME";
    self.IBTextRateforSession.titleLabel.text = @"RATE FOR SESSION";
    self.IBTextRateforVideo.titleLabel.text = @"RATE FOR VIDEO";
    self.IBTextFieldEmail.titleLabel.text = @"RESUME";
    self.IBTextFieldSelectCountry.titleLabel.text = @"COUNTRY";
    self.IBTextFieldSelectState.titleLabel.text = @"STATE";
    self.IBTextFieldEmail.titleLabel.text = @"EMAIL";
    self.IBTextFieldpwd.titleLabel.text = @"PASSWORD";
    
    self.IBTextFieldpwd.textField.secureTextEntry = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.bubbleView.delegate = self;
        
        [self.bubbleView fillBIGGERBubbleViewWithButtons:@[@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER"] bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
    });
    
    self.bottomView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bottomView.layer.shadowRadius = 3.0f;
    self.bottomView.layer.shadowOpacity = 0.3f;
    self.bottomView.layer.masksToBounds = NO;

    self.txtShadow.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.txtShadow.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.txtShadow.layer.shadowRadius = 3.0f;
    self.txtShadow.layer.shadowOpacity = 0.5f;
    
//    self.IBTextSkill.layer.masksToBounds = YES;
    
    
     TagState = NO;
    
    if ([_strEditTag isEqualToString:@"Register"])
    {
        [_IBButtonRegister setTitle:@"REGISTER" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"COACH REGISTRATION";
        _IBTextFieldEmail.textField.enabled = YES;
//        _IBTextFieldpwd.placeholder = @"Password";
    }
    else
    {
        [_IBButtonRegister setTitle:@"Save" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"COACH PROFILE";
        _IBTextFieldEmail.textField.enabled = NO;
//        _IBTextFieldpwd.placeholder = @"Change Password";
    }

    
     //[_IBTextFieldGraduated setItemList:[NSArray arrayWithObjects:@"test1",@"test2",@"test3",@"test4",@"test5",@"test6", nil]];
   // _IBViewRegisterIcon.clipsToBounds=YES;
   // _IBViewRegisterIcon.layer.cornerRadius = _IBViewRegisterIcon.bounds.size.width / 2.0;
    
    // Do any additional setup after loading the view from its nib.
    
    [_IBTextFieldSelectCountry.textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:nil nextAction:@selector(doneActionLocation:) doneAction:@selector(doneActionLocation:)];
  
    [self GetAllCoutry];

    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didClickBubbleButton:(UIButton *)bubble{
    arySportsType = self.bubbleView.bubbleSelectedArray;
}

- (IBAction)onGmail:(id)sender{
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeGmailReadonly, nil];
    
    [signIn signIn];
}
    
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        
        _gmailToken = user.authentication.accessToken;
        _facebookToken = nil;
        
        _IBTextFieldUsername.textField.text = user.profile.name;
        _IBTextFieldEmail.textField.text = user.profile.email;
        
        NSURL *avatarUrl = [user.profile imageURLWithDimension:300];
        
        [_avatar setImageWithURL:avatarUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(image){
                [_avatar setImage:image];
                _IBImageProfile.imageView.image = image;
            }
        }];
        
        NSLog(@"user.authentication.accessToken = %@", user.authentication.accessToken);
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
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}
    
    
    // Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

    


/////////  MARK : -   Get All Coutry Response    ////////

-(void) GetAllCoutry
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared CountryList];
    
    
}
-(void)getUserDetails7:(NSDictionary *)dicVideoDetials
{
    //NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    countries = [[result valueForKey:@"countries"] valueForKey:@"name"];
    
    arycountries = [[NSMutableArray alloc] init];
    arycountries = [result valueForKey:@"countries"];
    
    [_IBTextFieldSelectCountry.textField setItemList:[NSArray arrayWithArray:countries]];
    
    
    if (![_strEditTag isEqualToString:@"Register"])
    {
        [self GetCoachData];
    }
    
}

-(void)doneActionLocation:(UIBarButtonItem*)barButton
{
    [_IBTextFieldSelectCountry.textField resignFirstResponder];
    if (_IBTextFieldSelectCountry.textField.text.length != 0)
    {
        NSString *strID;
        for (int i = 0; i<arycountries.count; i++)
        {
            if ([[[arycountries objectAtIndex:i]valueForKey:@"name"] isEqualToString:_IBTextFieldSelectCountry.textField.text])
            {
                NSLog(@"id===%@",[[arycountries objectAtIndex:i]valueForKey:@"id"]);
                
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
                [shared StateList:[[arycountries objectAtIndex:i]valueForKey:@"id"]];
                
                
            }
        }
        
        NSLog(@"strID==%@",strID);
        
        
    }
    
    //doneAction
}

-(void)getUserDetails8:(NSDictionary *)dicVideoDetials
{
    //NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    countries = [[result valueForKey:@"states"] valueForKey:@"name"];
    
    arystates = [[NSMutableArray alloc] init];
    arystates = [result valueForKey:@"states"];
    
    
    [_IBTextFieldSelectState.textField setItemList:[NSArray arrayWithArray:countries]];
    
    if (TagState == NO)
    {
        [_IBTextFieldSelectState becomeFirstResponder];
    }
    else
    {
        TagState = NO;
    }

}






-(void) GetCoachData
{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    [shared coachDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
    
}

-(void)getUserDetails_CoachDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_CoachDetail  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    for (NSDictionary *dic in information)
    {
        [_avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Coach Image Path"]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        _IBTextFieldUsername.textField.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
        _IBTextRateforSession.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"rate_session"]];
        _IBTextRateforVideo.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"rate_video"]];
        _IBTextFieldSelectCountry.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        _IBTextFieldSelectState.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"state"]];
        //_IBTextSportsClub.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sports_club"]];
        _IBTextBio.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"bio"]];
        
        if (_IBTextFieldSelectState.textField.text.length == 0) {
            _IBTextFieldSelectState.textField.text = @"";
        }
        
        _IBTextFieldEmail.textField.enabled = NO;
        
        
        NSString *strR = [NSString stringWithFormat:@"%@",[dic valueForKey:@"resume_path"]];
        NSString *strC = [NSString stringWithFormat:@"%@",[dic valueForKey:@"certificate_path"]];
        
        if(strR.length > 20)
        {
            _IBImageResume.image = [UIImage imageNamed:@"Uploaded"];
        }
        if(strC.length > 20)
        {
            _IBImageCertificate.image = [UIImage imageNamed:@"Uploaded"];
        }
        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        NSArray *TypesAry = [sportstype componentsSeparatedByString:@","];
        [arySportsType addObjectsFromArray:TypesAry];
        
       self.bubbleView.bubbleSelectedArray = arySportsType;
        
        
        
        NSString *flexible_days = [[NSString alloc] init];
        flexible_days = [dic valueForKey:@"Flexible Days"];
        
        NSArray *TypesAryflexible_days = [flexible_days componentsSeparatedByString:@","];
        [arySportsDay addObjectsFromArray:TypesAryflexible_days];
        
        // NSLog(@"arySportsType==%@",arySportsType);
        
        
        if ([arySportsDay containsObject:@"MONDAY"])
        {
            [_IBButtonMonday setSelected:YES];
            [self.IBButtonMonday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"TUESDAY"])
        {
            [_IBButtonTuesday setSelected:YES];
            [self.IBButtonTuesday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"WEDNESDAY"])
        {
            [_IBButtonWednesday setSelected:YES];
            [self.IBButtonWednesday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"THURSDAY"])
        {
            [_IBButtonThursday setSelected:YES];
            [self.IBButtonThursday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"FRIDAY"])
        {
            [_IBButtonFriday setSelected:YES];
            [self.IBButtonFriday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"SATURDAY"])
        {
            [_IBButtonSaturday setSelected:YES];
            [self.IBButtonSaturday setAlpha:1];
        }
        if ([arySportsDay containsObject:@"SUNDAY"])
        {
            [_IBButtonSunday setSelected:YES];
            [self.IBButtonSunday setAlpha:1];
        }
        
        
       
        NSString *strID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"country_id"]];
        if (strID.length != 0)
        {
            TagState = YES;
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared StateList:strID];
        }
        
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) textViewDidChange:(UITextView *)textView
{
    
}


 /////////  MARK : -  Sports Type Selection      ////////

- (IBAction)IBButtonClickAllTypes:(id)sender
{
}

- (IBAction)IBButtonClickDays:(id)sender {
    
    switch ([sender tag]) {
        case 0:
            if([_IBButtonMonday isSelected]==YES)
            {
                [arySportsDay removeObject:@"MONDAY"];
                [_IBButtonMonday setSelected:NO];
                [_IBButtonMonday setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"MONDAY"];
                [_IBButtonMonday setSelected:YES];
                [_IBButtonMonday setAlpha:1];
            }
            
            break;
        case 1:
            if([_IBButtonTuesday isSelected]==YES)
            {
                [arySportsDay removeObject:@"TUESDAY"];
                [_IBButtonTuesday setSelected:NO];
                [_IBButtonTuesday  setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"TUESDAY"];
                [_IBButtonTuesday setSelected:YES];
                [_IBButtonTuesday  setAlpha:1];
            }
            
            break;
        case 2:
            if([_IBButtonWednesday isSelected]==YES)
            {
                [arySportsDay removeObject:@"WEDNESDAY"];
                [_IBButtonWednesday setSelected:NO];
                [_IBButtonWednesday  setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"WEDNESDAY"];
                [_IBButtonWednesday setSelected:YES];
                [_IBButtonWednesday  setAlpha:1];
            }
            
            break;
        case 3:
            if([_IBButtonThursday isSelected]==YES)
            {
                [arySportsDay removeObject:@"THURSDAY"];
                [_IBButtonThursday setSelected:NO];
                [_IBButtonThursday  setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"THURSDAY"];
                [_IBButtonThursday setSelected:YES];
                [_IBButtonThursday  setAlpha:1];
            }
            
            break;
            
        case 4:
            if([_IBButtonFriday isSelected]==YES)
            {
                [arySportsDay removeObject:@"FRIDAY"];
                [_IBButtonFriday setSelected:NO];
                [_IBButtonFriday setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"FRIDAY"];
                [_IBButtonFriday setSelected:YES];
                [_IBButtonFriday  setAlpha:1];
            }
            
            break;
            
        case 5:
            if([_IBButtonSaturday isSelected]==YES)
            {
                [arySportsDay removeObject:@"SATURDAY"];
                [_IBButtonSaturday setSelected:NO];
                [_IBButtonSaturday setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"SATURDAY"];
                [_IBButtonSaturday setSelected:YES];
                [_IBButtonSaturday setAlpha:1];
            }
            
            break;
            
            
        case 6:
            if([_IBButtonSunday isSelected]==YES)
            {
                [arySportsDay removeObject:@"SUNDAY"];
                [_IBButtonSunday setSelected:NO];
                [_IBButtonSunday setAlpha:0.5];
                
            }
            else
            {
                [arySportsDay addObject:@"SUNDAY"];
                [_IBButtonSunday setSelected:YES];
                [_IBButtonSunday setAlpha:1];
            }
            
            break;
            
            
        default:
            break;
    }

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

- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}

 /////////  MARK : -  Register Button      ////////


- (IBAction)onRegisterFacebook:(id)sender{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    [self getUserInfoFromFacebookFramework];
                                }
                            }];
}

- (void)getUserInfoFromFacebookFramework{
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        NSString *accessToken = [[FBSDKAccessToken currentAccessToken]tokenString];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email, about"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 _gmailToken = nil;
                 _facebookToken = accessToken;
                 
                 NSString *firstName = [result valueForKey:@"first_name"];
                 NSString *lastName = [result valueForKey:@"last_name"];
                 _IBTextFieldUsername.textField.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                 
                 NSString *email = [result valueForKey:@"email"];
                 _IBTextFieldEmail.textField.text = email;
                 
                 NSString *socialId = [result valueForKey:@"id"];
                 NSString *avatarUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=400&height=400", socialId];
                 [_avatar setImageWithURL:[NSURL URLWithString:avatarUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                     if(image){
                         [_avatar setImage:image];
                         _IBImageProfile.imageView.image = image;
                     }
                 }];
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
    }
}

- (IBAction)IBButtonClickRegister:(id)sender
{
    NSLog(@"ary=%@",arySportsType);
    [self.view endEditing:YES];
    if (arySportsType.count>0)
    {
        strSportType= [[NSString alloc]init ];
        for (int i=0; i<arySportsType.count; i++)
        {
            
            strSportType = [strSportType stringByAppendingString:[NSString stringWithFormat:@"%@",[arySportsType objectAtIndex:i]]];
            strSportType = [strSportType stringByAppendingString:@","];
        }
        
        if (strSportType.length != 0)
        {
            strSportType = [strSportType substringToIndex:[strSportType length] - 1];
            NSLog(@"strSportType=%@",strSportType);
        }
        
       
        
    }
    else
    {
        strSportType = @"";
    }
    
    
    
    NSLog(@"ary=%@",arySportsDay);
    
    if (arySportsDay.count>0)
    {
        strSportDay= [[NSString alloc]init ];
        for (int i=0; i<arySportsDay.count; i++)
        {
            if (![[arySportsDay objectAtIndex:i] isEqualToString:@""])
            {
                strSportDay = [strSportDay stringByAppendingString:[NSString stringWithFormat:@"%@",[arySportsDay objectAtIndex:i]]];
                strSportDay = [strSportDay stringByAppendingString:@","];
            }
            
        }
        
        if (strSportDay.length != 0)
        {
            strSportDay = [strSportDay substringToIndex:[strSportDay length] - 1];
            NSLog(@"strSportType=%@",strSportDay);
        }
        
    }
    else
    {
        strSportDay = @"";
    }

    
    if ([_strEditTag isEqualToString:@"Register"])
    {
        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimmedString = [_IBTextFieldUsername.textField.text stringByTrimmingCharactersInSet:charSet];
        
        if (_IBTextFieldUsername.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter full name"];
        }
        else if ([trimmedString isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid full name"];
        }
        else if (_IBTextFieldEmail.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter email"];
            
        }
        else if (![self isValidEmail:_IBTextFieldEmail.textField.text])
        {
            [appDelegate showAlertMessage:@"Please enter valid email"];
        }
        
        else if (_IBTextFieldSelectCountry.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select country"];
        }
        else if (_IBTextFieldSelectState.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select state"];
        }
        else if (_IBTextRateforSession.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter rate for session"];
        }
        
        else if (![self validateString:_IBTextRateforSession.textField.text withPattern:@"^[0-9]+(.{1}[0-9]+)?$"])
        {
            [appDelegate showAlertMessage:@"Please enter valid rate for session"];
        }

        else if (_IBTextRateforVideo.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter rate for video"];
            
        }
        else if (![self validateString:_IBTextRateforVideo.textField.text withPattern:@"^[0-9]+(.{1}[0-9]+)?$"])
        {
            [appDelegate showAlertMessage:@"Please enter valid rate for video"];
        }
//        else if (strCertificate.length ==0 && imgCertificate == nil)
//        {
//            [appDelegate showAlertMessage:@"Please add certificate"];
//        }
        
        else if (strResume.length ==0)
        {
            [appDelegate showAlertMessage:@"Please add resume file"];
            
        }
        else if (_IBTextBio.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter bio"];
            
        }
        else if ([[_IBTextBio.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid bio"];
        }
        else if (strSportType.length ==0 )
        {
           [appDelegate showAlertMessage:@"Please select sports type"];
        }
        else if (_IBTextFieldpwd.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter password"];
        }
        else
        {
            
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
            [shared coachRegistration:_IBTextFieldUsername.textField.text email:_IBTextFieldEmail.textField.text password:_IBTextFieldpwd.textField.text location:_IBTextFieldSelectCountry.textField.text rate:@"" usertype:@"Coach" sporttype:strSportType sports_club:_strClubID rateforsession:_IBTextRateforSession.textField.text rateforvideo:_IBTextRateforVideo.textField.text bio:_IBTextBio.text profileImage:self.avatar.image certificate:strCertificate resume:strResume imgcertificate:imgCertificate state:_IBTextFieldSelectState.textField.text strflexible_days:strSportDay facebookToken:self.facebookToken gmailToken:self.gmailToken];
            
        }
    }
    else
    {

        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimmedString = [_IBTextFieldUsername.textField.text stringByTrimmingCharactersInSet:charSet];
        
        
        if (_IBTextFieldUsername.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter username"];
            
        }
        else if ([trimmedString isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid username"];
        }
//        else if (_IBTextSportsClub.text.length ==0 )
//        {
//            [appDelegate showAlertMessage:@"Please enter sports club"];
//        }
//        else if ([[_IBTextSportsClub.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
//        {
//            // it's empty or contains only white spaces
//            [appDelegate showAlertMessage:@"Please enter valid sports club"];
//        }
        else if (_IBTextFieldSelectCountry.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select country"];
            
        }
        else if (_IBTextFieldSelectState.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select state"];
            
        }
        else if (_IBTextRateforSession.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter rate for session"];
            
        }
        else if (![self validateString:_IBTextRateforSession.textField.text withPattern:@"^[0-9]+(.{1}[0-9]+)?$"])
        {
            [appDelegate showAlertMessage:@"Please enter valid rate for session"];
        }
        
        else if (_IBTextRateforVideo.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter rate for video"];
            
        }
        else if (![self validateString:_IBTextRateforVideo.textField.text withPattern:@"^[0-9]+(.{1}[0-9]+)?$"])
        {
            [appDelegate showAlertMessage:@"Please enter valid rate for video"];
        }
        else if (_IBTextBio.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter bio"];
            
        }
        else if ([[_IBTextBio.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid bio"];
        }
        else if (strSportType.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select sports type"];
            
        }
        else
        {
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared coachEdit:_IBTextFieldUsername.textField.text email:_IBTextFieldEmail.textField.text coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]  location:_IBTextFieldSelectCountry.textField.text rate:@"" usertype:@"Coach" sporttype:strSportType rating:@"" profileImage:self.avatar.image sports_club:_strClubID rateforsession:_IBTextRateforSession.textField.text rateforvideo:_IBTextRateforVideo.textField.text bio:_IBTextBio.text password:_IBTextFieldpwd.textField.text certificate:strCertificate resume:strResume imgcertificate:imgCertificate state:_IBTextFieldSelectState.textField.text  strflexible_days:strSportDay];
            
        }

    }

  }


 /////////  MARK : -  Get Response      ////////

-(void)getUserDetails:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];

    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"information"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        if ([_strEditTag isEqualToString:@"Register"])
        {
            
            if (_strClubID.length == 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"Id"] forKey:@"id"];
                [[NSUserDefaults standardUserDefaults] setObject:@"Coach" forKey:@"Login"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                LGSideMenuController *mv =[storyboard instantiateViewControllerWithIdentifier:@"LGSideMenuController"];
                [[[UIApplication sharedApplication] delegate] window].rootViewController = mv;
            }
            else
            {
              
                [[NSUserDefaults standardUserDefaults] setObject:@"Club" forKey:@"Login"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ClubDetailPage *lp =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
                [self.navigationController pushViewController:lp animated:YES];

            }
                
            
            
            
        }
        else
        {
            appDelegate.isSavedProfile = YES;
            CoachDetailPage *lp = [[CoachDetailPage alloc]initWithNibName:@"CoachDetailPage" bundle:nil];
            lp.strCoachEdit = @"Coach";
            [self.navigationController pushViewController:lp animated:YES];
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
    }
    
}



- (IBAction)IBButtonClickLogin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Coach" forKey:@"SignUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginPage *lp = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
    [self.navigationController pushViewController:lp animated:YES];
}

- (IBAction)IBButtonClickBack:(id)sender
{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)IBButtonClickProfile:(id)sender
{
    [self.addPhotoAlert show:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.addPhotoAlert.didSelectCamera = ^(){
        [weakSelf CameraOpen];
    };
    
    self.addPhotoAlert.didSelectLibrary = ^(){
        [weakSelf GalleryOpen];
    };
}

- (IBAction)IBButtonClickUploadCertificate:(id)sender
{
    strImageTag = @"2";
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            @"iCloud Drive",
                            nil];
    popup.tag = 2;
    [popup showInView:self.view];
    
}

- (IBAction)IBButtonClickUploadResume:(id)sender
{
    strImageTag = @"3";
    [self iCloudOpen];
    
}

///////  ImagePickerController Class //////////

-(void) CameraOpen
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
    
}

-(void) GalleryOpen
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *chosenImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    UIImage *chosenImage=info[UIImagePickerControllerOriginalImage];
    
//    if ([strImageTag isEqualToString:@"1"])
//    {
        [self.avatar setImage:chosenImage];
//    }
//    else if ([strImageTag isEqualToString:@"2"])
//    {
//        strCertificate = @"";
//        imgCertificate = chosenImage;
//        _IBImageCertificate.image = [UIImage imageNamed:@"Uploaded"];
//    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void) iCloudOpen
{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image",@"public.data",@"public.content",@"public.text",@"public.plain-text",@"public.composite-​content",@"public.presentation",] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    //@"public.movie" @"public.audio",
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        if ([strImageTag isEqualToString:@"2"])
        {
            imgCertificate = nil;
            strCertificate =@"";
            strCertificate = [strCertificate stringByAppendingString:[url path]];
            NSLog(@"strCertificate=%@",strCertificate);
            
            NSArray *parts = [strCertificate componentsSeparatedByString:@"/"];
            NSString *filename = [parts lastObject];
            
            if ([filename rangeOfString:@".doc"].location != NSNotFound || [filename rangeOfString:@".docx"].location != NSNotFound || [filename rangeOfString:@".pdf"].location != NSNotFound || [filename rangeOfString:@".png"].location != NSNotFound || [filename rangeOfString:@".PNG"].location != NSNotFound || [filename rangeOfString:@".jpg"].location != NSNotFound || [filename rangeOfString:@".jpeg"].location != NSNotFound || [filename rangeOfString:@".JPG"].location != NSNotFound || [filename rangeOfString:@".JPEG"].location != NSNotFound)
            {
                _IBImageCertificate.image = [UIImage imageNamed:@"Uploaded"];
            }
            else
            {
                [appDelegate showAlertMessage:@"Please select png,jpg,pdf,doc and docx format file."];
            }
        }
        else
        {
            strResume =@"";
            strResume = [strResume stringByAppendingString:[url path]];
            NSLog(@"strResume=%@",strResume);
            
            NSArray *parts = [strResume componentsSeparatedByString:@"/"];
            NSString *filename = [parts lastObject];
            
            if ([filename rangeOfString:@".doc"].location != NSNotFound || [filename rangeOfString:@".docx"].location != NSNotFound || [filename rangeOfString:@".pdf"].location != NSNotFound)
            {
                _IBImageResume.image = [UIImage imageNamed:@"Uploaded"];
            }
            else
            {
                [appDelegate showAlertMessage:@"Please select pdf,doc and docx format file."];
                
            }

        }
        
        
    }
}


- (IBAction)IBButtonClickInfo:(id)sender
{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"information"]];
    photo.caption = @"";
    [photos addObject:photo];
    
    self.photos = photos;
    
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableSwipeToDismiss = NO;
    browser.zoomPhotosToFill = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
