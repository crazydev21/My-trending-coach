//
//  CoachesPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 15/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "CoachesPage.h"
#import "EditCoachDetailPage.h"

#import "CoachDetailPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ClubDetailPage.h"
#import "SinglePersonView.h"
#import "HCSStarRatingView.h"
#import "ClubPreviewViewController.h"
#import "CouchPreviewViewController.h"

#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

#import "iCarousel.h"

@interface CoachesPage ()

@property (strong, nonatomic) NSArray *clubsAllInfo;

@property (weak, nonatomic) IBOutlet iCarousel *sportClubs;

@property (weak, nonatomic) IBOutlet iCarousel *namesSport;
@property (weak, nonatomic) IBOutlet iCarousel *couchs;

@property (strong, nonatomic) NSArray *namesSportArray;

@property (weak,nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation CoachesPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
     [_IBTextFieldSelectRating setItemList:[NSArray arrayWithObjects:@"Low to high for session",@"High to low for session",@"Low to high for video",@"High to low for video", nil]];
  
     [_IBTextFieldSelectState addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];

     [_IBTextFieldSelectRating addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
     [_IBTextFieldName addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [_IBTextFieldSelectCountry addDoneOnKeyboardWithTarget:self action:@selector(doneActionLocation:)];
    
    self.namesSport.type = self.sportClubs.type = self.couchs.type =0;
    self.namesSportArray = [[NSArray alloc] initWithObjects:@"TENNIS", @"SOCCER", @"FOOTBALL", @"BASEBALL", @"GOLF", @"PERSONAL TRAINER", @"FITNESS", @"SOFTBALL", @"SPORT PSYCHOLOGY", @"OTHER", nil];
    [self.namesSport reloadData];
    
    
    [self.namesSport scrollToItemAtIndex:[self.namesSportArray indexOfObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"SportType"]] animated:NO];
    
    self.sportClubs.pagingEnabled = self.couchs.pagingEnabled = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    if (carousel == _namesSport)
        return self.namesSportArray.count;
    else if(carousel == _sportClubs)
        return aryClubName.count;
    else
        return aryImages.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    UIView *sportView;
    
    if (carousel == _namesSport) {
        //create new view if no view is available for recycling
        if (sportView == nil)
        {
            sportView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-30, 35)];
            ((UILabel*)sportView).textColor = [UIColor whiteColor];
            ((UILabel*)sportView).textAlignment = NSTextAlignmentCenter;
            ((UILabel*)sportView).font = [UIFont fontWithName:@"SegoeUI-Bold" size:14];
        }
        
        ((UILabel*)sportView).text = [self.namesSportArray objectAtIndex:index];
        
    }else if (carousel == _sportClubs){
        
        UIImageView *avatar;
        UILabel *fromLabel;
        
        if (sportView == nil){
            sportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 150)];
            
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
            avatar.contentMode = UIViewContentModeScaleAspectFill;
            avatar.layer.masksToBounds = YES;
            [sportView addSubview:avatar];
            
            fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 122, 110, 20)];
            fromLabel.font = [UIFont fontWithName:@"SegoeUI-Bold" size:10];
            fromLabel.textColor = [UIColor grayColor];
            [sportView addSubview:fromLabel];
        }
        
        NSString *strImage = [NSString stringWithFormat:@"%@",[aryClubImage objectAtIndex:index]];
        strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [avatar sd_setImageWithURL:[NSURL URLWithString:strImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
                avatar.image = image;
            else
                avatar.image = [UIImage imageNamed:@"avatarDefault"];
        }];
        
        fromLabel.text = [[NSString stringWithFormat:@"%@",[aryClubName objectAtIndex:index]]uppercaseString];
    }
    else {
        
        UIImageView *avatar;
        UILabel *fromLabel;
        HCSStarRatingView *rating;
        
        if (sportView == nil){
            sportView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 150)];
            
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
            avatar.contentMode = UIViewContentModeScaleAspectFill;
            avatar.layer.masksToBounds = YES;
            [sportView addSubview:avatar];
            
            fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 122, 110, 20)];
            fromLabel.font = [UIFont fontWithName:@"SegoeUI-Bold" size:10];
            fromLabel.textColor = [UIColor grayColor];
            [sportView addSubview:fromLabel];
            
            rating = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 140, 60, 10)];
            rating.minimumValue = 0;
            rating.maximumValue = 5;
            rating.value = 3;
            rating.spacing = 1;
            rating.halfStarImage = [UIImage imageNamed:@"rating_star-red_gray"];
            rating.emptyStarImage = [UIImage imageNamed:@"rating_star-gray"];
            rating.filledStarImage = [UIImage imageNamed:@"rating_star-red"];
            [sportView addSubview:rating];
        }
        
        NSString *strImage = [NSString stringWithFormat:@"%@",[aryImages objectAtIndex:index]];
        strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [avatar sd_setImageWithURL:[NSURL URLWithString:strImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
                avatar.image = image;
            else
                avatar.image = [UIImage imageNamed:@"avatarDefault"];
        }];
        
        fromLabel.text = [[NSString stringWithFormat:@"%@",[aryName objectAtIndex:index]]uppercaseString];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;

        rating.value = [[numberFormatter numberFromString:[aryRateCoach objectAtIndex:index]] floatValue];
    }
    
    return sportView;
    
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
    if (carousel == _sportClubs) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClubPreviewViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ClubPreviewViewController"];
        controller.aryClubName = aryClubName;
        controller.clubsAllInfo = self.clubsAllInfo;
        controller.position = index;
        controller.sportType = self.namesSport.currentItemIndex;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (carousel == _couchs){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CoachDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPage"];
        pr.strCoachEdit = @"Player";
        [[NSUserDefaults standardUserDefaults] setValue:[[coaches objectAtIndex:index] valueForKey:@"id"] forKey:@"CoachID"];
        
        [self.navigationController pushViewController:pr animated:YES];
    }
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    if (carousel == _namesSport) {
        
        NSString *searchKey = [self.namesSportArray objectAtIndex:carousel.currentItemIndex];
        
        if (![searchKey isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"SportType"]] || _headerImageView.tag == 0) {
            
            _headerImageView.tag = 1;
            
            [[NSUserDefaults standardUserDefaults] setObject:searchKey forKey:@"SportType"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self GetAllCoutry];
                
                [_headerImageView setImage:[UIImage imageNamed:[@[@"TennisHeader",@"SoccerHeader",@"FootballHeader",@"BassebalHeader",@"GolfHeader",@"PersonalTrainer",@"FitnessHeader",@"SoftBallHeader",@"SportPhysyologyHeader",@"OtherHeader"] objectAtIndex:carousel.currentItemIndex]]];
//            });
        }
    }
}

- (IBAction)onSearchButton:(id)sender{
    [self.searchView setHidden:!self.searchView.hidden];
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
  //  NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    countries = [[result valueForKey:@"countries"] valueForKey:@"name"];
    
    arycountries = [[NSMutableArray alloc] init];
    arycountries = [result valueForKey:@"countries"];
    
    [_IBTextFieldSelectCountry setItemList:[NSArray arrayWithArray:countries]];
    
    [self GetCoachListData];
    
}

-(void)doneActionLocation:(UIBarButtonItem*)barButton
{
    [_IBTextFieldSelectCountry resignFirstResponder];
    [_IBTextFieldSelectRating resignFirstResponder];
    [_IBTextFieldName resignFirstResponder];
    [_IBTextFieldSelectState resignFirstResponder];
    
    if (_IBTextFieldSelectCountry.text.length != 0)
    {
        NSString *strID;
        for (int i = 0; i<arycountries.count; i++)
        {
            if ([[[arycountries objectAtIndex:i]valueForKey:@"name"] isEqualToString:_IBTextFieldSelectCountry.text])
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
    
    [_IBTextFieldSelectState setItemList:[NSArray arrayWithArray:countries]];
    
    [self GetCoachListData];
    
   // [_IBTextFieldSelectState becomeFirstResponder];
 
    
}

-(void)doneAction:(UIBarButtonItem*)barButton
{
    [_IBTextFieldSelectCountry resignFirstResponder];
    [_IBTextFieldSelectRating resignFirstResponder];
    [_IBTextFieldName resignFirstResponder];
    [_IBTextFieldSelectState resignFirstResponder];

    
    [self GetCoachListData];
    
    //doneAction
}


 /////////  MARK : - Get Coach List      ////////

-(void)GetCoachListData
{
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] isEqualToString:@"Club"])
    {
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        
        if ([_IBTextFieldSelectRating.text isEqualToString:@"Low to high for session"])
        {
            NSLog(@"Country==%@",_IBTextFieldSelectCountry.text);
            NSLog(@"SportType==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]);
            NSLog(@"Name==%@,",_IBTextFieldName.text);
            NSLog(@"Login==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"]);

            [shared coachList:_strClubID country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"1" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"High to low for session"])
        {
            
            NSLog(@"Country==%@",_IBTextFieldSelectCountry.text);
            NSLog(@"SportType==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]);
            NSLog(@"Name==%@,",_IBTextFieldName.text);
            NSLog(@"Login==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"]);

            [shared coachList:_strClubID country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"2" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"Low to high for video"])
        {

            NSLog(@"Country==%@",_IBTextFieldSelectCountry.text);
            NSLog(@"SportType==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]);
            NSLog(@"Name==%@,",_IBTextFieldName.text);
            NSLog(@"Login==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"]);

            [shared coachList:_strClubID country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"3" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
            
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"High to low for video"])
        {
            NSLog(@"Country==%@",_IBTextFieldSelectCountry.text);
            NSLog(@"SportType==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]);
            NSLog(@"Name==%@,",_IBTextFieldName.text);
            NSLog(@"Login==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"]);

            [shared coachList:_strClubID country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"4" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else
        {
            
            NSLog(@"Country==%@",_IBTextFieldSelectCountry.text);
            NSLog(@"SportType==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]);
            NSLog(@"Name==%@,",_IBTextFieldName.text);
            NSLog(@"Login==%@,",[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"]);

            [shared coachList:_strClubID country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }

    }
    else
    {
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        
        if ([_IBTextFieldSelectRating.text isEqualToString:@"Low to high for session"])
        {
            [shared coachList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"1" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"High to low for session"])
        {
            [shared coachList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"2" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"Low to high for video"])
        {
            [shared coachList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"3" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
            
        }
        else if ([_IBTextFieldSelectRating.text isEqualToString:@"High to low for video"])
        {
            [shared coachList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"4" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }
        else
        {
            [shared coachList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] country:_IBTextFieldSelectCountry.text sporttype:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"] name:_IBTextFieldName.text rating:@"" user_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] state:_IBTextFieldSelectState.text];
        }

    }
  }

-(void)getUserDetails:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_PlayerDetail  :   %@",dicVideoDetials);
     [appDelegate stopLoadingview];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = coaches = [result valueForKey:@"player information"];
    
    NSMutableArray *clubinformation = [[NSMutableArray alloc] init];
    clubinformation = [result valueForKey:@"club information"];
    
    self.clubsAllInfo = clubinformation;
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    aryClubName = [[NSMutableArray alloc]init];
    aryClubID = [[NSMutableArray alloc]init];
    aryClubImage = [[NSMutableArray alloc]init];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        if (information != (id)[NSNull null])
        {
            aryID = [[NSMutableArray alloc] init];
            aryID = [information valueForKey:@"id"];
            
            aryName = [[NSMutableArray alloc] init];
            aryName = [information valueForKey:@"Name"];
            
            aryImages = [[NSMutableArray alloc] init];
            aryImages = [information valueForKey:@"Photo"];
            
            aryRateCoach = [[NSMutableArray alloc] init];
            aryRateCoach = [information valueForKey:@"Rating"];
            
            [_couchs reloadData];
            if ([appDelegate.strPlayerCoachTag isEqualToString:@"Player"])
            {
                NSMutableArray *sport_type = [[NSMutableArray alloc] init];
                sport_type = [information valueForKey:@"Sport Type"];
                
                //            arySportType = [[NSMutableArray alloc] init];
                //            for (NSDictionary *dic in sport_type)
                //            {
                //                [arySportType addObject:[dic valueForKey:@"sport_type"]];
                //            }
                //            NSLog(@"ary=%@",arySportType);
                
            }
            

        }
        
        if (clubinformation != (id)[NSNull null])
        {
     
            aryClubName = [clubinformation valueForKey:@"name"];
            aryClubID = [clubinformation valueForKey:@"id"];
            aryClubImage = [clubinformation valueForKey:@"image"];
        }
        
        [_sportClubs reloadData];

    }
    else
    {
        aryID = [[NSMutableArray alloc] init];
        aryName = [[NSMutableArray alloc] init];
        aryImages = [[NSMutableArray alloc] init];
         [self LoadScrollView];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
         //[self performSelector:@selector(DismissAlert:) withObject:alert afterDelay:1];
    }
    
     [appDelegate stopLoadingview];
}

-(void)DismissAlert:(UIAlertView*)x
{
    [x dismissWithClickedButtonIndex:-1 animated:YES];
   // [self IBButtonClickBack:0];
    
}

 /////////  MARK : -  Coach Listing Design Method      ////////

- (void) LoadScrollView
{

    int x=25, y=10;
    
    for (UIView *v in _IBContentView.subviews) {
        [v removeFromSuperview];
    }
    
    for (int i = 0 ; i<aryImages.count; i++)
    {
        NSLog(@"Height==%f",([[UIScreen mainScreen] bounds].size.width - 350) /2);
        CGRect buttonFrame = CGRectMake( x, y, self.view.frame.size.width /2 -40, ([[UIScreen mainScreen] bounds].size.height - 350) /2);
        UIView *view =[[UIView alloc] initWithFrame:buttonFrame];
        view.backgroundColor = [UIColor clearColor];
        [_IBContentView addSubview:view];

    
        NSString *strImage = [NSString stringWithFormat:@"%@",[aryImages objectAtIndex:i]];
        strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, view.frame.size.width-10, view.frame.size.height-35)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strImage]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        //img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[aryImages objectAtIndex:i]]];
        img.contentMode = UIViewContentModeScaleToFill;
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 2.0;
        [view addSubview:img];
        
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.size.height+5, view.frame.size.width, 25)];
        fromLabel.text = [[NSString stringWithFormat:@"%@",[aryName objectAtIndex:i]]uppercaseString ];
        fromLabel.font = [UIFont fontWithName:@"EurostileRoundW00-Bold" size:15];
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor whiteColor];
        fromLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:fromLabel];

        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(  0, 0, view.frame.size.width-10, view.frame.size.height-35 )];
        // [button setTitle: @"My Button" forState: UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        button.tag = i;
        [view addSubview:button];
        
        

        x += self.view.frame.size.width /2;
        _IBLayoutWidthView.constant = x;
        _IBLayoutHeightView.constant = view.frame.size.height;
        
      //  [_IBScrollView setContentSize:CGSizeMake(x, view.frame.size.height)];
        
        
//        if (x > [[UIScreen mainScreen] bounds].size.width-10) {
//            
//            x = 20;
//            y += self.view.frame.size.width /2+10;
//        }

        
//        if (aryImages.count % 2)
//        {
//            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y+self.view.frame.size.width /2+10)];
//        }
//        else
//        {
//            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y)];
//        }

        
    }
    
    [self  LoadScrollViewClub];
    [appDelegate stopLoadingview];
}

-(void)ButtonClickEvent:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld   %@", (long)iTag,[aryID objectAtIndex:iTag]);

    [[NSUserDefaults standardUserDefaults] setObject:[aryID objectAtIndex:iTag] forKey:@"CoachID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    CoachDetailPage *cp = [storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPage"];
    cp.strCoachEdit = @"Player";
    cp.strClubID = _strClubID;

    [self.navigationController pushViewController:cp animated:YES];
    
}

/////////  MARK : -  Club Listing Design Method      ////////

- (void) LoadScrollViewClub
{
    
    int x=25, y=10;
    
    for (UIView *v in _IBContentViewClub.subviews) {
        [v removeFromSuperview];
    }
    
    for (int i = 0 ; i<aryClubName.count; i++)
    {
        NSLog(@"Height==%f",([[UIScreen mainScreen] bounds].size.width - 350) /2);
        CGRect buttonFrame = CGRectMake( x, y, self.view.frame.size.width /2 -40, ([[UIScreen mainScreen] bounds].size.height - 350) /2);
        UIView *view =[[UIView alloc] initWithFrame:buttonFrame];
        view.backgroundColor = [UIColor clearColor];
        [_IBContentViewClub addSubview:view];
        
        NSString *strImage = [NSString stringWithFormat:@"%@",[aryClubImage objectAtIndex:i]];
        strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, view.frame.size.width-10, view.frame.size.height-35)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strImage]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        img.contentMode = UIViewContentModeScaleToFill;
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 2.0;
        [view addSubview:img];
        
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.size.height+5, view.frame.size.width, 25)];
        fromLabel.text = [[NSString stringWithFormat:@"%@",[aryClubName objectAtIndex:i]]uppercaseString ];
        fromLabel.font = [UIFont fontWithName:@"EurostileRoundW00-Bold" size:15];
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor whiteColor];
        fromLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:fromLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(  0, 0, view.frame.size.width-10, view.frame.size.height-35 )];
        // [button setTitle: @"My Button" forState: UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClickEventClub:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        button.tag = i;
        [view addSubview:button];
        
        x += self.view.frame.size.width /2;
        _IBLayoutWidthViewClub.constant = x;
        _IBLayoutHeightViewClub.constant = view.frame.size.height;
    }
    
    [appDelegate stopLoadingview];
}

-(void)ButtonClickEventClub:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld   %@", (long)iTag,[aryClubID objectAtIndex:iTag]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ClubDetailPage *lp =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
    lp.strClubID = [aryClubID objectAtIndex:iTag];
    [self.navigationController pushViewController:lp animated:YES];
}


#pragma mark - crop square image method
-(UIImage *)SquareImageWithSideOfLength:(float)length image :(UIImage *)Image
{
    UIImage *thumbnail;
    
    //couldn’t find a previously created thumb image so create one first…
    UIImage *mainImage = Image;
    
    // Allocate an imageview
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    
    // Get the greater value from width and height
    BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
    //    float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
    
    float sideFull, difference;
    
    if(widthGreaterThanHeight)
    {
        sideFull = mainImage.size.height;
        difference = mainImage.size.width - sideFull;
    }
    else
    {
        sideFull = mainImage.size.width;
        difference = mainImage.size.height - sideFull;
    }
    
    // Setup a rect to generate thumbnail
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect( currentContext, clippedRect);
    
    CGFloat scaleFactor = length/sideFull;
    
    if (widthGreaterThanHeight)
    {
        //a landscape image – make context shift the original image to the left when drawn into the context
        CGContextTranslateCTM(currentContext, -(difference / 2) * scaleFactor, 0);
    }
    
    else
    {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        CGContextTranslateCTM(currentContext, 0, -(difference / 2) * scaleFactor);
    }
    
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
    
    [mainImageView.layer renderInContext:currentContext];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            NSString *str= [[NSUserDefaults standardUserDefaults]stringForKey:@"CardNumber"];
            if (str.length > 10)
            {
                NSString *cardno = [NSString stringWithFormat:@"************%@",[str substringFromIndex: [str length] - 4]];
                NSLog(@"cardno=%@",cardno);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged from (Card no:%@) for send this Video",cardno] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
                alert.tag = 2;
                [alert show];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged to send this video"] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
                alert.tag = 2;
                [alert show];
                
            }

            
        }
        
    }
    else  if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [player pause];
            player = nil;
            
            if (thumbnail.size.width < thumbnail.size.height)
            {
                thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.width image:thumbnail];
            }
            else
            {
                thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.height image:thumbnail];
            }
            

            
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
            
            
            if (appDelegate.strFilterSportType.length == 0)
            {
                appDelegate.strFilterSportType = strsportTypes;
            }
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq :@"Capture" sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
        }
    }

    // NSLog(@"ava=%@",Aryavailability);
}

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{

    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        appDelegate.strFilterTitle = @"";
        appDelegate.strFilterSportType = @"";
        appDelegate.strFilterNotes = @"";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOUR VIDEO HAS BEEN SENT" message:[NSString stringWithFormat:@"Once your video has been reviewed by your coach, You will be Charged and your reviewed video will show up under your “Videos” tab in your profile"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];

        appDelegate.isReviewed = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    appDelegate.strPlayerstrVideoPath = @"";
}

- (IBAction)IBButtonClickCountry:(id)sender
{
    
}

- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onMenu:(id)sender{
    [self openRightView:nil];
}
@end
