//
//  PlayerRegistrationPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 09/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "PlayerRegistrationPage.h"
#import "LoginPage.h"
#import "MainViewController.h"
#import "EditPlayerDetailPage.h"
#import "AddPhotoAlert.h"
#import "BBView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LGSideMenuController.h"

#define STRIPE_PUBLISHABLE_KEY @"pk_test_FKwUuApym0GC9Sqf5S27Nrmb"

@interface PlayerRegistrationPage () <BBDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *txtShadow;

@property (weak, nonatomic) IBOutlet BBView *bubbleView;
@property (strong, nonatomic) AddPhotoAlert *addPhotoAlert;

@property (strong, nonatomic) NSString *facebookToken;
@property (strong, nonatomic) NSString *gmailToken;

@end

@implementation PlayerRegistrationPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInButton.style = kGIDSignInButtonStyleIconOnly;
    self.signInButton.colorScheme = kGIDSignInButtonColorSchemeLight;
    
    
    // Initialize the service object.
    self.service = [[GTLRGmailService alloc] init];
    
    self.addPhotoAlert = [[AddPhotoAlert alloc] init];
    
    //IBTextSkill SHADOW
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.txtShadow.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
        self.txtShadow.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.txtShadow.layer.shadowRadius = 3.0f;
        self.txtShadow.layer.shadowOpacity = 0.5f;
        
        self.IBTextSkill.layer.masksToBounds = YES;
        
        self.bottomView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
        self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.bottomView.layer.shadowRadius = 3.0f;
        self.bottomView.layer.shadowOpacity = 0.3f;
        self.bottomView.layer.masksToBounds = NO;
    });
    
    //Place Title Names
    self.IBTextFieldEmail.titleLabel.text = @"EMAIL";
    self.IBTextFieldpwd.titleLabel.text = @"PASSWORD";
    self.IBTextFieldFirstUsername.titleLabel.text = @"FULL NAME";
    self.IBTextFieldSelectCountry.titleLabel.text = @"COUNTRY";
    self.IBTextFieldSelectState.titleLabel.text = @"STATE";
    self.IBTextFieldAge.titleLabel.text = @"AGE";
    self.IBTextFieldGender.titleLabel.text = @"GENDER";
    
    self.facebookToken = self.gmailToken = nil;
    
    self.IBTextFieldpwd.textField.secureTextEntry = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.bubbleView.delegate = self;
        
         [self.bubbleView fillBIGGERBubbleViewWithButtons:@[@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER"] bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
    });
   
     TagState = NO;
    _IBButtonMale.tag = 0;
    _IBButtonFemale.tag = 1;
    
    strUserType= [[NSString alloc]init];
    strSportType= [[NSString alloc]init];
    arySportsType = [[NSMutableArray alloc]init];
    self.agesArray = [[NSMutableArray alloc] init];
    
    
    for (int i=10; i < 80; i++) {
        [self.agesArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
        NSLog(@"_strEditTag==%@",_strEditTag);

    if ([_strEditTag isEqualToString:@"Register"])
    {
        [_IBButtonRegister setTitle:@"REGISTER" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"PLAYER REGISTRATION";
        _IBTextFieldEmail.textField.enabled = YES;
        _IBTextFieldpwd.textField.placeholder = @"";
        
    }
    else
    {
        [_IBButtonRegister setTitle:@"Save" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"EDIT PROFILE";
        _IBTextFieldEmail.textField.enabled = NO;
        _IBTextFieldpwd.textField.placeholder = @"Change Password";
     
    }
    
    [_IBTextFieldCMonth setItemList:[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil]];
    [_IBTextFieldCYear setItemList:[NSArray arrayWithObjects:@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040", nil]];
    [_IBTextFieldGender.textField setItemList:@[@"Male", @"Female"]];
    
    
    [_IBTextFieldSelectCountry.textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:nil nextAction:@selector(doneActionLocation:) doneAction:@selector(doneActionLocation:)];
    
    [self GetAllCoutry];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)IBButtonMFSelection:(id)sender{
    
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
        
        _IBTextFieldFirstUsername.textField.text = user.profile.name;
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
   // NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    countries = [[result valueForKey:@"countries"] valueForKey:@"name"];
    
    arycountries = [[NSMutableArray alloc] init];
    arycountries = [result valueForKey:@"countries"];
    
    [_IBTextFieldSelectCountry.textField setItemList:[NSArray arrayWithArray:countries]];
    
    [_IBTextFieldAge.textField setItemList:self.agesArray];
    
    if (![_strEditTag isEqualToString:@"Register"])
    {
         [self GetPlayerData];
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
        [_IBTextFieldSelectState.textField becomeFirstResponder];
    }
    else
    {
        TagState = NO;
    }
    
}








-(void) textViewDidChange:(UITextView *)textView
{
    if(_IBTextSkill.text.length == 0)
    {
        _IBLabelSkill.hidden = NO;
    }
    else
    {
        _IBLabelSkill.hidden = YES;
    }
}


/////////  MARK : -   Player Detail request response    ////////

-(void) GetPlayerData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared playerDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
    
    
}

- (void)didReceivePlayerDetails:(NSDictionary *)info {
    NSLog(@"getUserDetails_PlayerDetail  :   %@",info);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [info valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    
    for (NSDictionary *dic in information)
    {
        _IBTextFieldFirstUsername.textField.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
        _IBTextFieldAge.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _IBTextFieldSelectCountry.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        _IBTextFieldSelectState.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"state"]];
        
        /////  Gender ///////
        _IBTextFieldGender.textField.text = [NSString stringWithFormat:@"%@", [dic valueForKey:@"Gender"]];
        
        if (_IBTextFieldSelectState.textField.text.length == 0) {
            _IBTextFieldSelectState.textField.text = @"";
        }
        
        _IBTextSkill.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Skill"]];
        strSportType =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Sport Type"]];
        
        
        _IBTextFieldEmail.textField.enabled = NO;
        
        [_avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]]];
        
        if(_IBTextSkill.text.length == 0)
        {
            _IBLabelSkill.hidden = NO;
        }
        else
        {
            _IBLabelSkill.hidden = YES;
        }
        
        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        NSArray *TypesAry = [sportstype componentsSeparatedByString:@","];
        [arySportsType addObjectsFromArray:TypesAry];
        
        // NSLog(@"arySportsType==%@",arySportsType);
        if (arySportsType.count > 0) {
            self.bubbleView.bubbleSelectedArray = arySportsType;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bubbleView fillBIGGERBubbleViewWithButtons:@[@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER"] bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
            });
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

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_PlayerDetail  :   %@",dicVideoDetials);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];

    
    for (NSDictionary *dic in information)
    {
        _IBTextFieldFirstUsername.textField.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
         _IBTextFieldAge.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _IBTextFieldSelectCountry.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        _IBTextFieldSelectState.textField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"state"]];
        
        /////  Gender ///////
        _IBTextFieldGender.textField.text = [NSString stringWithFormat:@"%@", [dic valueForKey:@"Gender"]];
        
        if (_IBTextFieldSelectState.textField.text.length == 0) {
            _IBTextFieldSelectState.textField.text = @"";
        }
        
        _IBTextSkill.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Skill"]];
        strSportType =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Sport Type"]];
        
       
        _IBTextFieldEmail.textField.enabled = NO;
        
        [_avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]]];
        
        if(_IBTextSkill.text.length == 0)
        {
            _IBLabelSkill.hidden = NO;
        }
        else
        {
            _IBLabelSkill.hidden = YES;
        }

        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        NSArray *TypesAry = [sportstype componentsSeparatedByString:@","];
        [arySportsType addObjectsFromArray:TypesAry];
        
       // NSLog(@"arySportsType==%@",arySportsType);
        if (arySportsType.count > 0) {
            self.bubbleView.bubbleSelectedArray = arySportsType;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bubbleView fillBIGGERBubbleViewWithButtons:@[@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER"] bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
            });
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
  }

 /////////  MARK : -  Sport Type Selection      ////////

- (IBAction)IBButtonClickAllTypes:(id)sender
{
    
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



 /////////  MARK : -  Register button      ////////

- (IBAction)IBButtonClickRegister:(id)sender
{
    
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
    
    if ([_strEditTag isEqualToString:@"Register"])
    {
    
        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimmedString = [_IBTextFieldFirstUsername.textField.text stringByTrimmingCharactersInSet:charSet];
        
        
        if (_IBTextFieldFirstUsername.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter first name"];
            
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
        else if (_IBTextFieldAge.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter age"];
            
        }
        else if (_IBTextFieldGender.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select gender"];
            
        }
        else if (_IBTextFieldpwd.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter password"];
            
        }
        else if (_IBTextSkill.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter skill"];
            
        }
        else if ([[_IBTextSkill.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid skill"];
        }
        else if (strSportType.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select sports type"];
            
        }
        else
        {
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            
            [shared playerRegistration:_IBTextFieldFirstUsername.textField.text email:_IBTextFieldEmail.textField.text password:_IBTextFieldpwd.textField.text gender:_IBTextFieldGender.textField.text location:_IBTextFieldSelectCountry.textField.text age:_IBTextFieldAge.textField.text usertype:@"Player" sporttype:strSportType skills:_IBTextSkill.text cno:@"" cmonth:@"" cyear:@"" profileImage:_IBImageProfile.imageView.image state:_IBTextFieldSelectState.textField.text facebookToken:self.facebookToken gmailToken:self.gmailToken];
        }
    }
    else
    {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        

        if (_IBTextFieldFirstUsername.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter username"];
            
        }
        else if ([[_IBTextFieldFirstUsername.textField.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid username"];
        }
        else if (_IBTextFieldSelectCountry.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select country"];
            
        }
        else if (_IBTextFieldSelectState.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select state"];
            
        }
        else if (_IBTextFieldAge.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter age"];
            
        }
        else if (_IBTextSkill.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter skill"];
            
        }
        else if ([[_IBTextSkill.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid skill"];
        }

        else if (strSportType.length ==0 )
        {
           [appDelegate showAlertMessage:@"Please select sports type"];
        }

        else
        {
       
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared playerEdit:_IBTextFieldFirstUsername.textField.text email:_IBTextFieldEmail.textField.text playerid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] gender:_IBTextFieldGender.textField.text location:_IBTextFieldSelectCountry.textField.text age:_IBTextFieldAge.textField.text usertype:strUserType sporttype:strSportType skills:(NSString *)_IBTextSkill.text profileImage:_avatar.image password:_IBTextFieldpwd.textField.text state:_IBTextFieldSelectState.textField.text];
            
            
        }
    }
}


 /////////  MARK : -   Get Response     ////////

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
            
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"Id"] forKey:@"id"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            MainViewController *lp =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            [self.navigationController pushViewController:lp animated:YES];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LGSideMenuController *mv =[storyboard instantiateViewControllerWithIdentifier:@"LGSideMenuController"];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = mv;
        }
        else
        {
         
            appDelegate.isSavedProfile = YES;
            EditPlayerDetailPage *lp = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlayerDetailPage"];
            [self.navigationController pushViewController:lp animated:YES];


        }
        
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    

}



- (IBAction)IBButtonClickBack:(id)sender
{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

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
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email, about, gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 _gmailToken = nil;
                 _facebookToken = accessToken;
                 
                 NSString *firstName = [result valueForKey:@"first_name"];
                 NSString *lastName = [result valueForKey:@"last_name"];
                 _IBTextFieldFirstUsername.textField.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                 
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
                 
                  NSString *gender = [result valueForKey:@"gender"];
                 _IBTextFieldGender.textField.text = gender;
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
    }
}

- (IBAction)onGmailRegister:(id)sender{
    
}

- (IBAction)IBButtonClickCSave:(id)sender
{
    if (_IBTextFieldCNo.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter card number"];
        
    }
    else if (_IBTextFieldCMonth.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please select month"];
        
    }
    else if (_IBTextFieldCYear.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please select year"];
        
    }
    else if (_IBTextFieldCCVV.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter cvv number"];
        
    }
    else
    {
        [appDelegate startLoadingview:@"Verifying..."];
        self.stripeCard = [[STPCard alloc] init];
       // self.stripeCard.name = @"Test";
        self.stripeCard.number = _IBTextFieldCNo.text;
        self.stripeCard.cvc = _IBTextFieldCCVV.text;
        self.stripeCard.expMonth = [_IBTextFieldCMonth.text integerValue];
        self.stripeCard.expYear = [_IBTextFieldCYear.text integerValue];

        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [Stripe createTokenWithCard:self.stripeCard
                     publishableKey:STRIPE_PUBLISHABLE_KEY
                         completion:^(STPToken* token, NSError* error) {
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                             if(error)
                             {
                                 [appDelegate stopLoadingview];
                                 [appDelegate showAlertMessage:@"Credit/Debit card is not valid, please enter valid card detail."];
                             }
                             else
                                 [self hasToken:token];
                         }];

    }
    
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
                                [appDelegate stopLoadingview];
                                [appDelegate showAlertMessage:@"Your card save successfully"];
                                [_IBViewPayment removeFromSuperview];
        
                                [[NSUserDefaults standardUserDefaults] setObject:_IBTextFieldCNo.text forKey:@"CardNumber"];
                                [[NSUserDefaults standardUserDefaults] setObject:_IBTextFieldCCVV.text forKey:@"CardCVV"];
                                [[NSUserDefaults standardUserDefaults] setObject:_IBTextFieldCMonth.text forKey:@"CardMonth"];
                                [[NSUserDefaults standardUserDefaults] setObject:_IBTextFieldCYear.text forKey:@"CardYear"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                           }];
}


/////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];

  
    if (textField.tag == 5)
    {
        if (currentString.length > 16) {
            return NO;
        }
        return YES;
    }
    else if (textField.tag == 6)
    {
        if (currentString.length > 4) {
            return NO;
        }
        return YES;
    }
    else
    {
        return YES;
    }
    
    
    //[formatter setLenient:YES];
    
}
- (IBAction)IBButtonClickProfile:(id)sender
{
//    [[[[iToast makeText:NSLocalizedString(@"For better experience use edited Instagram pictures", @"")]
//       setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    
    [self.addPhotoAlert show:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.addPhotoAlert.didSelectCamera = ^(){
        [weakSelf CameraOpen];
    };
    
    self.addPhotoAlert.didSelectLibrary = ^(){
        [weakSelf GalleryOpen];
    };
}


///////  ImagePickerController Class //////////

-(void) CameraOpen
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [appDelegate showAlertMessage:@"Device has no camera"];
        
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
    UIImage *chosenImage=info[UIImagePickerControllerOriginalImage];
    [self.avatar setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
//////////////////////


@end
