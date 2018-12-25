//
//  ClubSignUpPage.m
//  MTC
//
//  Created by Bhavin on 6/8/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "ClubSignUpPage.h"
#import "ClubDetailPage.h"
#import "AddPhotoAlert.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <Google/SignIn.h>
#import <GTLRGmail.h>

@interface ClubSignUpPage () <SharedClassDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRGmailService *service;
    
@property (strong, nonatomic) AddPhotoAlert *addPhotoAlert;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *txtShadow;
@property (strong, nonatomic) NSString *facebookToken;
@property (strong, nonatomic) NSString *gmailToken;

@end

@implementation ClubSignUpPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInButton.style = kGIDSignInButtonStyleIconOnly;
    self.signInButton.colorScheme = kGIDSignInButtonColorSchemeLight;
    
    TagState = NO;
    
    self.addPhotoAlert = [[AddPhotoAlert alloc] init];
    
    
    //IBTextSkill SHADOW
    
    self.txtShadow.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.txtShadow.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.txtShadow.layer.shadowRadius = 3.0f;
    self.txtShadow.layer.shadowOpacity = 0.5f;
    
    
    
    self.bottomView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bottomView.layer.shadowRadius = 3.0f;
    self.bottomView.layer.shadowOpacity = 0.3f;
    self.bottomView.layer.masksToBounds = NO;
    
    //Place Title Names
    self.IBTextFieldEmail.titleLabel.text = @"EMAIL";
    self.IBTextFieldpwd.titleLabel.text = @"PASSWORD";
    
    self.IBTextFieldname.titleLabel.text = @"CLUB NAME";
    self.IBTextFieldLocation.titleLabel.text = @"COUNTRY";
    self.IBTextFieldState.titleLabel.text = @"STATE";
    
    self.IBTextFieldpwd.textField.secureTextEntry = YES;
    
    if ([_strEditTag isEqualToString:@"Register"])
    {
        [_IBButtonRegister setTitle:@"REGISTER" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"CLUB REGISTRATION";
        _IBTextFieldEmail.textField.enabled = YES;
//        _IBTextFieldpwd.placeholder = @"Password";
    }
    else
    {
        [_IBButtonRegister setTitle:@"SAVE" forState:UIControlStateNormal];
        _IBLabelHeader.text = @"EDIT PROFILE";
        _IBTextFieldEmail.textField.enabled = NO;
//        _IBTextFieldpwd.placeholder = @"Change Password";
        
    }

      [_IBTextFieldLocation.textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:nil nextAction:@selector(doneActionLocation:) doneAction:@selector(doneActionLocation:)];
  
    
    
    [self GetAllCoutry];
    
    
    
    [self setNeedsStatusBarAppearanceUpdate];
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
        
        _IBTextFieldname.textField.text = user.profile.name;
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

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_IBTextBio.text.length == 0)
    {
        _IBLabelBio.hidden = NO;
    }
    else
    {
        _IBLabelBio.hidden = YES;
    }
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
    
    [_IBTextFieldLocation.textField setItemList:[NSArray arrayWithArray:countries]];

    if (![_strEditTag isEqualToString:@"Register"])
    {
        [self GetClubData];
    }
    
}


-(void)doneActionLocation:(UIBarButtonItem*)barButton
{
    [_IBTextFieldLocation.textField resignFirstResponder];
    if (_IBTextFieldLocation.textField.text.length != 0)
    {
        NSString *strID;
        for (int i = 0; i<arycountries.count; i++)
        {
            if ([[[arycountries objectAtIndex:i]valueForKey:@"name"] isEqualToString:_IBTextFieldLocation.textField.text])
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
    
    [_IBTextFieldState.textField setItemList:[NSArray arrayWithArray:countries]];
    if (TagState == NO)
    {
        [_IBTextFieldState.textField becomeFirstResponder];
    }
    else
    {
        TagState = NO;
    }
}

-(void) GetClubData
{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    [shared ClubDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"club_id"] passing_value:@"get_club_details" sport_type:@""];
}

-(void)getUserDetails4:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    data = [result valueForKey:@"data"];
    
    
    UIImageView *im = [[UIImageView alloc] init];
    [im sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[data valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"ClubREgister"]];
    
    self.avatar.image = im.image;
    
    _IBTextFieldname.textField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"name"]];
    _IBTextFieldEmail.textField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"email"]];
    _IBTextFieldLocation.textField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"location"]];
    _IBTextFieldState.textField.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"state"]];
    _IBTextBio.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"bio"]];
    _IBTextFieldEmail.textField.enabled = NO;
    
    if (_IBTextFieldState.textField.text.length == 0) {
        _IBTextFieldState.textField.text = @"";
    }
    
    if(_IBTextBio.text.length == 0)
    {
        _IBLabelBio.hidden = NO;
    }
    else
    {
        _IBLabelBio.hidden = YES;
    }
    
    NSString *strID = [NSString stringWithFormat:@"%@",[data valueForKey:@"country_id"]];
    if (strID.length != 0)
    {
        TagState = YES;
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared StateList:strID];
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


- (IBAction)IBButtonClickRegister:(id)sender
{
    if ([_strEditTag isEqualToString:@"Register"])
    {
        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimmedString = [_IBTextFieldname.textField.text stringByTrimmingCharactersInSet:charSet];
        
        if (_IBTextFieldname.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter club name"];
            
        }
        else if ([trimmedString isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid club name"];
        }
        else if (_IBTextFieldEmail.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter email"];
            
        }
        else if (![self isValidEmail:_IBTextFieldEmail.textField.text])
        {
            [appDelegate showAlertMessage:@"Please enter valid email"];
        }
        else if (_IBTextFieldLocation.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select country"];
            
        }
        else if (_IBTextFieldState.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select state"];
            
        }

        else if (_IBTextBio.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter descritpion"];
            
        }
        else if ([[_IBTextBio.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid bio"];
        }
      
        else if (_IBTextFieldpwd.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter password"];
            
        }
        
        
        else
        {
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared clubRegistration:_IBTextFieldname.textField.text email:_IBTextFieldEmail.textField.text password:_IBTextFieldpwd.textField.text location:_IBTextFieldLocation.textField.text bio:_IBTextBio.text clubImage:self.avatar.image state:_IBTextFieldState.textField.text];
            
        }
    }
    else
    {
        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimmedString = [_IBTextFieldname.textField.text stringByTrimmingCharactersInSet:charSet];
        
        if (_IBTextFieldname.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter club name"];
        }
        else if ([trimmedString isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid club name"];
        }
        else if (_IBTextFieldEmail.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter email"];
            
        }
        else if (![self isValidEmail:_IBTextFieldEmail.textField.text])
        {
            [appDelegate showAlertMessage:@"Please enter valid email"];
        }
        else if (_IBTextFieldLocation.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select country"];
            
        }
        else if (_IBTextFieldState.textField.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please select state"];
            
        }

        else if (_IBTextBio.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter descritpion"];
            
        }
        else if ([[_IBTextBio.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid bio"];
        }
        else
        {
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared clubEdit:[[NSUserDefaults standardUserDefaults]stringForKey:@"club_id"]  clubName:_IBTextFieldname.textField.text email:_IBTextFieldEmail.textField.text password:_IBTextFieldpwd.textField.text location:_IBTextFieldLocation.textField.text bio:_IBTextBio.text clubImage:self.avatar.image state:_IBTextFieldState.textField.text];
            
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
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    data = [result valueForKey:@"data"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        if ([_strEditTag isEqualToString:@"Register"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Club" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults] setObject:[data valueForKey:@"id"] forKey:@"club_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClubDetailPage *lp =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
        [self.navigationController pushViewController:lp animated:YES];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
}

- (IBAction)IBButtonClickProfile:(id)sender{
    [self.addPhotoAlert show:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.addPhotoAlert.didSelectCamera = ^(){
        [weakSelf CameraOpen];
    };
    
    self.addPhotoAlert.didSelectLibrary = ^(){
        [weakSelf GalleryOpen];
    };
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
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email, about"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 _gmailToken = nil;
                 _facebookToken = accessToken;
                 
                 NSString *firstName = [result valueForKey:@"first_name"];
                 NSString *lastName = [result valueForKey:@"last_name"];
                 _IBTextFieldname.textField.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                 
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
    [self.avatar setImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)IBButtonClickBack:(id)sender
{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
