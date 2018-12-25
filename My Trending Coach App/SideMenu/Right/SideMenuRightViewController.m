//
//  SideMenuRightViewController.m
//  MTC
//
//  Created by Evgen Litvinenko on 26.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "SideMenuRightViewController.h"
#import "AvailabilityViewController.h"
#import "EditPlayerDetailPage.h"
#import "HCSStarRatingView.h"
#import "CoachDetailPage.h"
#import "PopupLogout.h"
#import "LoginPage.h"

@interface SideMenuRightViewController () <SharedClassDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *genderLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UILabel *sessionPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIView *couchView;
@property (weak, nonatomic) IBOutlet UIView *playerView;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *availabilityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) PopupLogout *popupLogout;

@end

@implementation SideMenuRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.masksToBounds = YES;;
    _avatarImageView.layer.cornerRadius = 5.;
    
//    self.panGesture.cancelsTouchesInView = YES;
    [self GetPlayerData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetPlayerData];
}

#pragma mark - User Info

- (void)GetPlayerData {
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate = self;
    
    NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login"];
    NSString *idUser = [[NSUserDefaults standardUserDefaults]stringForKey:@"id"];
    if ([type isEqualToString:@"Player"]) {
        [shared playerDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
        self.playerView.hidden = self.availabilityView.hidden = NO;
        self.couchView.hidden = self.ratingView.hidden = YES;
        self.topConstraint.constant = 10;
    }else if ([type isEqualToString:@"Coach"]){
        [shared coachDetail:idUser];
        self.playerView.hidden = self.availabilityView.hidden = YES;
        self.couchView.hidden = self.ratingView.hidden = NO;
        self.topConstraint.constant = -10;
    }
}

- (void)getUserDetails_PlayerDetail:(NSDictionary *)info {
    NSMutableArray *information = [info valueForKeyPath:@"result.player information"];
    if (information && information.count){
        NSDictionary *dic = [information lastObject];
        _nameLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _ageLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _locationLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]] uppercaseString];
        _genderLabel.text = [[NSString stringWithFormat:@"%@", [dic valueForKey:@"Gender"]] uppercaseString];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]]];
    }
}

- (void)didReceivePlayerDetails:(NSDictionary *)info {
    NSMutableArray *information = [info valueForKeyPath:@"result.player information"];
    if (information && information.count){
        NSDictionary *dic = [information lastObject];
        _nameLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _ageLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _locationLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]] uppercaseString];
        _genderLabel.text = [[NSString stringWithFormat:@"%@", [dic valueForKey:@"Gender"]] uppercaseString];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]]];
    }
}

-(void)getUserDetails_CoachDetail:(NSDictionary *)dicVideoDetials{
    NSMutableArray *information = [dicVideoDetials valueForKeyPath:@"result.player information"];
    if (information && information.count){
        NSDictionary *dic = [information lastObject];
        _nameLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _sessionPriceLabel.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"rate_session"]];
        _locationLabel.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]] uppercaseString];
        _videoPriceLabel.text = [[NSString stringWithFormat:@"$%@", [dic valueForKey:@"rate_video"]] uppercaseString];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Coach Image Path"]]]];
        
        float value = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Rating"]] floatValue];
        self.ratingView.value = value;
    }
}

#pragma mark - Actions

- (IBAction)onAvailability:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    AvailabilityViewController *pr = [storyboard instantiateViewControllerWithIdentifier:@"AvailabilityViewController"];
    pr.makeRequestForCouch = NO;
    [pr setupAdditionAllowed:NO];
    [self showViewController:pr sender:self];
}

- (IBAction)onMyProfile:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    appDelegate.strPlayerCheck = @"Indirect";
    NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login"];
    if ([type isEqualToString:@"Player"]) {
        
        UINavigationController *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlayerDetailPageNavigation"];
//        EditPlayerDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"EditPlayerDetailPage"];
       [self showViewController:pr sender:self];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] forKey:@"CoachID"];
        
        UINavigationController *detNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPageNavigation"];
        CoachDetailPage *detController = (CoachDetailPage*)detNavigation.viewControllers.firstObject;
        detController.strCoachEdit = @"Coach";
    
//        CoachDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPage"];
//        pr.strCoachEdit = @"Coach";
        [self showViewController:detNavigation sender:self];
    }
}

- (IBAction)onRequests:(id)sender {
    
}

- (IBAction)onPending:(id)sender {

}

- (IBAction)onVideo:(id)sender {
    
}

- (IBAction)onLogout:(id)sender {

    self.popupLogout = [[PopupLogout alloc] init];
    __weak typeof(self) weakSelf = self;
    
    [self.popupLogout show:[[[UIApplication sharedApplication] delegate] window]];
    
    self.popupLogout.didLogout = ^{
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate = weakSelf;
        [shared Logout:[[NSUserDefaults standardUserDefaults]
                        stringForKey:@"Login"]];
    };
}

-(void)getUserDetails2:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails_USER_LOGIN_API_CALL  :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.popupLogout removeFromSuperview];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        [self showViewController:pr sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
    }
}

@end
