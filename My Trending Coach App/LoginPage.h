//
//  LoginPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 10/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginPage : UIViewController <UIAlertViewDelegate,SharedClassDelegate>
{
    UITextField *alertEmailtextfield;
    NSString *strKeepmeLogin;
}

@property (weak, nonatomic) IBOutlet UIButton *IBButtonKeepmelogin;
- (IBAction)IBButtonClickKeepmelogin:(id)sender;


- (IBAction)IBButtonClickLogin:(id)sender;
- (IBAction)IBButtonClickForgotpwd:(id)sender;
- (IBAction)IBButtonClickBack:(id)sender;

- (IBAction)IBButtonClickPlayerSignup:(id)sender;
- (IBAction)IBButtonClickCoachSignup:(id)sender;

@end
