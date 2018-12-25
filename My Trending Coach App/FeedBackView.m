//
//  FeedBackView.m
//  My Trending Coach App
//
//  Created by Nisarg on 05/01/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "FeedBackView.h"
#import "UIViewController+MJPopupViewController.h"

@interface FeedBackView () <SharedClassDelegate>

@end

@implementation FeedBackView
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_IbLabelCoach.text = [NSString stringWithFormat:@"Rate For %@",appDelegate.strCoachName];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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


- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    
    strRating = [NSString stringWithFormat:@"%.1f",sender.value];
    
}

- (IBAction)IBButtonClickCancel:(id)sender
{
    appDelegate.strCoachId= @"";
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)IBButtonClickOk:(id)sender
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared SendFeedback:appDelegate.strCoachId rating:strRating feedback:_IBTextviewFeedback.text];
}

-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails  :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        appDelegate.strCoachId= @"";
        [appDelegate showAlertMessage:message];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
}



@end
