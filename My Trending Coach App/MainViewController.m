//
//  MainViewController.m
//  My Trending Coach App
//
//  Created by Nisarg on 07/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "MainViewController.h"
#import "PlayerRegistrationPage.h"
#import "CoachRegistrationPage.h"
#import "EditPlayerDetailPage.h"
#import "EditCoachDetailPage.h"
#import "CoachesPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CoachDetailPage.h"
#import "UIViewController+MJPopupViewController.h"
#import "FeedBackView.h"

#import "VideoDetailPage.h"
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "LoginPage.h"

#import "iCarousel.h"


@interface MainViewController () <MJSecondPopupDelegate,SharedClassDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (strong, nonatomic) NSArray *valuesCarousel;
@property (strong, nonatomic) NSArray *valuesCarouselInactive;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iCarouselView.type = 1;
    self.valuesCarousel = [[NSArray alloc] initWithObjects:@"TennisCard", @"soccerCard", @"footballCard", @"BaseballCard",@"GolfCard", @"PersonalsCard", @"fittness", @"Softball", @"physyologiCard", @"OtherCard", nil];
    
    self.valuesCarouselInactive = [[NSArray alloc] initWithObjects:@"TennisCardInactive", @"soccerCardInactive", @"footballCardInactive", @"BaseballCardInactive",@"GolfCardInactive", @"PersonalsCardInactive", @"fittnessInactive", @"SoftballInactive", @"physyologiCardInactive", @"OtherCardInactive", nil];
    
    [self.iCarouselView reloadData];
    
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    _IBPlayerlbl.numberOfLines = 0;
   
      /////////  MARK : -  Rounded Circle Button     ////////
    
    _IBButtonClub.clipsToBounds=YES;
    _IBButtonClub.layer.cornerRadius = _IBButtonClub.bounds.size.width / 2.0;
    _IBButtonClub.layer.borderColor=[UIColor orangeColor].CGColor;
    _IBButtonClub.layer.borderWidth=2.0f;
    
    _IBButtonPlayers.clipsToBounds=YES;
    _IBButtonPlayers.layer.cornerRadius = _IBButtonPlayers.bounds.size.width / 2.0;
    _IBButtonPlayers.layer.borderColor=[UIColor orangeColor].CGColor;
    _IBButtonPlayers.layer.borderWidth=2.0f;
    
    _IBButtonCoaches.clipsToBounds=YES;
    _IBButtonCoaches.layer.cornerRadius = _IBButtonCoaches.bounds.size.width / 2.0;
    _IBButtonCoaches.layer.borderColor=[UIColor orangeColor].CGColor;
    _IBButtonCoaches.layer.borderWidth=2.0f;

    NSString *Login = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"Login"];
    

    if ([Login isEqualToString:@"Player"] || [Login isEqualToString:@"Coach"])
    {
        _IBViewCPC.hidden = YES;
        _IBViewUser.hidden = NO;
    }
    else
    {
         _IBViewCPC.hidden = NO;
         _IBViewUser.hidden = YES;
    }
    
    
    if (appDelegate.strCoachId.length != 0)
    {
         //[self performSelector:@selector(RateView) withObject:nil afterDelay:0.5];
    }
    [self setNeedsStatusBarAppearanceUpdate];
 //   [self performSelector:@selector(VideoFilterView) withObject:nil afterDelay:1];
   
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return self.valuesCarousel.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 230)];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2;
    }
    
    if(index == _iCarouselView.currentItemIndex)
        ((UIImageView *)view).image = [UIImage imageNamed:[self.valuesCarouselInactive objectAtIndex:index]];
    else
        ((UIImageView *)view).image = [UIImage imageNamed:[self.valuesCarousel objectAtIndex:index]];
    
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    [carousel reloadData];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    [self ButtonClcikEventTag:index];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)VideoFilterView
{
//    appDelegate.strPlayerstrVideoPath = @"/private/var/mobile/Containers/Data/Application/282D338B-7F37-4340-ADCE-40A6AE69B482/tmp/trim.3D09C44B-6C84-4DD2-A9E9-71DFF35A0C7E.MOV";
//    
//    NSLog(@"appDelegate.strPlayerstrVideoPath  %@", appDelegate.strPlayerstrVideoPath);
//    VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
//    [self presentViewController: vdp animated: NO completion: nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [[NSUserDefaults standardUserDefaults] setObject:[timeZone name] forKey:@"TimeZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


  /////////  MARK : -  Open Rate View        ////////

-(void)RateView
{
    FeedBackView *detailViewController = [[FeedBackView alloc] initWithNibName:@"FeedBackView" bundle:nil];
    detailViewController.delegate = self;
    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


  /////////  MARK : -   Clicl event for Sports Type Button       ////////

-(void)ButtonClcikEvent:(UIButton*)btn
{
    
     appDelegate.strPlayerCheck = @"Direct";
    
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld   %@", (long)iTag,[textary objectAtIndex:iTag]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[textary objectAtIndex:iTag] forKey:@"SportType"];
    
   // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] forKey:@"SportType"]);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     appDelegate.strPlayerCoachTag = @"Coach";
    
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    NSLog(@"login=%@",Login);
    
    if ([Login isEqualToString:@"Player"] || [Login isEqualToString:@"Coach"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CoachesPage *cp = [storyboard instantiateViewControllerWithIdentifier:@"CoachesPage"];
        [self.navigationController pushViewController:cp animated:YES];
    }
}

-(void)ButtonClcikEventTag:(NSInteger)iTag
{
    
    NSArray *textarys = [[NSArray alloc]initWithObjects:@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER", nil];
    
    appDelegate.strPlayerCheck = @"Direct";
    
    NSLog(@"iTag %ld   %@ appDelegate.strFilterSportType = %@", (long)iTag,[textarys objectAtIndex:iTag], appDelegate.strFilterSportType);
    
    [[NSUserDefaults standardUserDefaults] setObject:[textarys objectAtIndex:iTag] forKey:@"SportType"];
    
    // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] forKey:@"SportType"]);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    appDelegate.strPlayerCoachTag = @"Coach";
    
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    NSLog(@"login=%@",Login);
    
    if ([Login isEqualToString:@"Player"] || [Login isEqualToString:@"Coach"])
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CoachesPage *cp = [storyboard instantiateViewControllerWithIdentifier:@"CoachesPage"];
        [self.navigationController pushViewController:cp animated:YES];
    }
}

  /////////  MARK : -  New User Button        ////////

- (IBAction)IBButtonClickUser:(id)sender
{
     appDelegate.strPlayerCheck = @"Indirect";
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    if ([Login isEqualToString:@"Player"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        EditPlayerDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"EditPlayerDetailPage"];
        [self.navigationController pushViewController:pr animated:YES];
    
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] forKey:@"CoachID"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

        CoachDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPage"];
        pr.strCoachEdit = @"Coach";
        [self.navigationController pushViewController:pr animated:YES];
    }
    
}


  /////////  MARK : -   Logout button       ////////

- (IBAction)IBButtonClickLogout:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Logout"
                                          message:@"Are you sure you want to logout?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"No", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Type==%@",[[NSUserDefaults standardUserDefaults]
                                                      stringForKey:@"Login"]);
                                   SharedClass *shared =[SharedClass sharedInstance];
                                   shared.delegate =self;
                                   [shared Logout:[[NSUserDefaults standardUserDefaults]
                                     stringForKey:@"Login"]];
                                   
                                   
                               }];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
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
        
        LoginPage *mv = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        [self.navigationController pushViewController:mv animated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
    }
    
}

- (IBAction)IBButtonClubEvent:(id)sender {
}

  /////////  MARK : -  Player Page        ////////

- (IBAction)IBButtonPlayersEvent:(id)sender
{
    PlayerRegistrationPage *pr = [[PlayerRegistrationPage alloc]initWithNibName:@"PlayerRegistrationPage" bundle:nil ];
    [self.navigationController pushViewController:pr animated:YES];
}

  /////////  MARK : -  Coach Page        ////////

- (IBAction)IBButtonCoachesEvent:(id)sender
{
    CoachRegistrationPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachRegistrationPage"];
    [self.navigationController pushViewController:pr animated:YES];
}

- (IBAction)onMenu:(id)sender{
    [self openRightView:nil];
}

@end
