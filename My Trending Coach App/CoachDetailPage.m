//
//  CoachDetailPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 21/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "CoachDetailPage.h"
#import "CustomIOSAlertView.h"

#import "UIViewController+MJPopupViewController.h"
#import "AvailabilityViewController.h"
#import "VideoFilterPage.h"
#import "PlayerVideoListPage.h"

#import "EditPlayerPopUpCell.h"
#import "PendingAppoinmentVC.h"
#import "CoachRegistrationPage.h"
#import "CoachVideoListPage.h"
#import "WebViewPage.h"
#import "EditPlayerDetailPage.h"
#import "MainViewController.h"
#import "ClubDetailPage.h"
#import "BBView.h"
#import "CertificatesListViewController.h"

@interface CoachDetailPage () <CustomIOSAlertViewDelegate, BBDelegate, CertificatesListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationHeigth;

@property (strong, nonatomic) IBOutlet UIButton *IBButtonMonday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonTuesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonWednesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonThursday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonFriday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSaturday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSunday;

@property (weak, nonatomic) IBOutlet BBView *bubbleView;

@property (nonatomic, strong) NSDictionary* userInfo;
@property (nonatomic, strong) CertificatesListViewController* certificatesController;
@property (strong, nonatomic) NSArray* certificatesInfos;
@end

@implementation CoachDetailPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addShadow];
    
    self.navigationController.navigationBarHidden = YES;

    arySportsType = [[NSMutableArray alloc]init];
    
    appDelegate.isSaved = NO;
    
    _IBButtonAddCertificate.alpha = 0.0;
    
    _IBViewPopUp.alpha = 0.0;

    NSLog(@"test=%@=%@",appDelegate.strPlayerCheck,[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]);
    
    if (([appDelegate.strPlayerCheck isEqualToString:@"Indirect"]) && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Coach"])
    {
        //I'M COACH
        _IBButtonSendVideo1.hidden = NO;
        _IBButtonAR.hidden = NO;
        _IBButtonPA.hidden = NO;
        _IBButtonEdit.hidden = NO;
        _IBButtonCR.hidden = NO;
        _IBButtonCR.hidden = NO;
        self.navigationBar.hidden = NO;
        self.bottomBar.hidden = YES;
        self.navigationHeigth.constant = 90;
    }
    else
    {
        //I'M PLAYER
        _IBButtonSendVideo1.hidden = YES;
        _IBButtonAR.hidden = YES;
        _IBButtonPA.hidden = YES;
        _IBButtonEdit.hidden = YES;
        _IBButtonCR.hidden = YES;
        self.navigationBar.hidden = YES;
        self.bottomBar.hidden = NO;
        self.navigationHeigth.constant = 0;
       
    }


        // Do any additional setup after loading the view from its nib.
    [self GetCoachData];
    
    _IBCollectionViewVideo.backgroundColor = [UIColor clearColor];
    _IBCollectionViewPhoto.backgroundColor = [UIColor clearColor];
    
    _IBButtonEdit.hidden = ![_strCoachEdit isEqualToString:@"Coach"];
    
    [_IBTblPopUp registerNib:[UINib nibWithNibName:@"EditPlayerPopUpCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    // Do any additional setup after loading the view from its nib.
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (appDelegate.isSaved)
    {
        _IBNSLayountHeightContentVew.constant = 810;
        appDelegate.isSaved = NO;
        [_IBViewMainCalender removeFromSuperview];
         [self GetCoachData];
    }
    
    if (appDelegate.isEndLiveStream)
    {
        appDelegate.isEndLiveStream = NO;
    }

    self.certificatesController = nil;
}
 /////////  MARK : -  Get coach Detail      ////////

-(void) GetCoachData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    

    
    if ([_strCoachEdit isEqualToString:@"Player"])
    {
        [shared coachDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"]];
        
    }
    else
    {
        [shared coachDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
        
    }

}

-(void)getUserDetails_CoachDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_CoachDetail  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    NSDictionary *ff = [information firstObject];
    self.userInfo = ff;
    
    NSString *image = [ff valueForKey:@"sports_club_image"];
    if(image != (NSString *)[NSNull null]){
        [_IBViewPhoto sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_IBViewPhoto setImage:image];
        }];
    }
        
    _IBLabelBadge.text = [NSString stringWithFormat:@"%@",[result valueForKey:@"appointment_count"]];
    if (_IBLabelBadge.text.length == 0 || [_IBLabelBadge.text isEqualToString:@"0"])
    {
        _IBLabelBadge.hidden = YES;
    }
    else
    {
        _IBLabelBadge.hidden = NO;
    }
    
    _IBLabelRequestBadge.text = [NSString stringWithFormat:@"%@",[result valueForKey:@"request_count"]];
    if (_IBLabelRequestBadge.text.length == 0 || [_IBLabelRequestBadge.text isEqualToString:@"0"])
    {
        _IBLabelRequestBadge.hidden = YES;
    }
    else
    {
        _IBLabelRequestBadge.hidden = NO;
    }
    
    _IBLabelVideoBadge.text = [NSString stringWithFormat:@"%@",[result valueForKey:@"video_count"]];
    if (_IBLabelVideoBadge.text.length == 0 || [_IBLabelVideoBadge.text isEqualToString:@"0"])
    {
        _IBLabelVideoBadge.hidden = YES;
    }
    else
    {
        _IBLabelVideoBadge.hidden = NO;
    }
    
    
    if ([_strCoachEdit isEqualToString:@"Player"])
    {
        _IBLabelBadge.hidden = YES;
        _IBLabelRequestBadge.hidden = YES;
        _IBLabelVideoBadge.hidden = YES;
        _IBLabelClubBadge.hidden = YES;
    }
    
    
    for (NSDictionary *dic in information)
    {
        _IBTextFieldRate.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Rate"]];
    
        _IBTextviewBio.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"bio"]];


        _IBTextFieldName.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
        _IBLableRateforSession.text = [NSString stringWithFormat:@"$%@\n/session",[dic valueForKey:@"rate_session"]];
        _IBLableRateforVideo.text = [NSString stringWithFormat:@"$%@\n/video",[dic valueForKey:@"rate_video"]];
        _IBTextFieldLocation.text = [NSString stringWithFormat:@"%@,%@",[dic valueForKey:@"state"],[dic valueForKey:@"Location"]];
        
        NSString* clubName = [[dic objectForKey:@"sports_club"] isKindOfClass:[NSNull class]] ? @"" : [dic objectForKey:@"sports_club"];
        _IBLabelClubName.text = clubName.length > 0 ? clubName : @"";
        
        _IBTextFlexibledays.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Flexible Days"]];
    
        
        if(_IBTextviewBio.text.length == 0)
            _IBTextviewBio.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sports_club_bio"]];
        
        if ( _IBTextFlexibledays.text.length != 0)
        {
           _IBTextFlexibledays.text = [NSString stringWithFormat:@"FLEXIBLE DAYS:\n%@",[dic valueForKey:@"Flexible Days"]];
            _IBTextFlexibledays.text = [_IBTextFlexibledays.text stringByReplacingOccurrencesOfString:@"," withString:@", "];
        }
        
        if ([[dic valueForKey:@"state"] isEqualToString:@""]) {
            _IBTextFieldLocation.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        }
        
        if (_IBLabelClubName.text.length <= 0){
            //_IBLabelClubName.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sports_club_name"]];
            NSString* clubName = [[dic objectForKey:@"sports_club_name"] isKindOfClass:[NSNull class]] ? @"" : [dic objectForKey:@"sports_club_name"];
            _IBLabelClubName.text = clubName.length > 0 ? clubName : @"";
        }
        
        if(_IBTextFieldLocation.text.length == 0){
            _IBTextFieldLocation.text = [NSString stringWithFormat:@"%@, %@",[dic valueForKey:@"sports_club_location"],[dic valueForKey:@"sports_club_state"]];
        }
        
        if (_IBLabelClubName.text.length == 0)
        {
             _IBNSLayountHeightClub.constant = 0;
            _IBNSLayountHeightTopView.constant = 485;
        }
        else
        {
             _IBNSLayountHeightClub.constant = 30;
             _IBNSLayountHeightTopView.constant = 575;
        }
        
        if (_IBTextFlexibledays.text.length != 0)
        {
            _IBNSLayountHeightTopView.constant += 60;
        }
        
        strResume = [NSString stringWithFormat:@"%@",[dic valueForKey:@"resume_path"]];
        
        NSMutableArray *calendar= [[NSMutableArray alloc]init];
        calendar =  [dic valueForKey:@"Calendar"];
        
        appDelegate.aryCalendarDate = [[NSMutableArray alloc]init ];
        [appDelegate.aryCalendarDate addObjectsFromArray:[calendar valueForKey:@"date"]];
        
        appDelegate.aryCalendarStatus = [[NSMutableArray alloc]init ];
        [appDelegate.aryCalendarStatus addObjectsFromArray:[calendar valueForKey:@"status"]];
        
        
        NSLog(@"appDelegate.aryCalendarDate=%@",appDelegate.aryCalendarDate);
        
        self.borderDefaultColors = [[NSMutableDictionary alloc]init];
        
        if (appDelegate.aryCalendarDate.count != 0)
        {
            for (int i = 0 ; i<appDelegate.aryCalendarDate.count ; i++)
            {
                NSString *datestr = [NSString stringWithFormat:@"%@",[appDelegate.aryCalendarDate objectAtIndex:i]];
                if (![datestr isEqualToString:@""])
                {
                    datestr=[datestr substringToIndex:10];
                    NSLog(@"[appDelegate.aryCalendarDate objectAtIndex:i]=%@",[appDelegate.aryCalendarDate objectAtIndex:i]);
                    
                    NSLog(@"datestr=%@",datestr);
                    [self.borderDefaultColors setObject:[UIColor purpleColor] forKey:datestr];
                 
                }
            }
        }
        
        NSLog(@"self.borderDefaultColors=%@",self.borderDefaultColors);
        
      
        float value = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Rating"]] floatValue];
        _IBViewRating.value = value;
        
        NSString *strImage = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Coach Image Path"]];
        strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        strCoachImagePath = [[NSString alloc] init];
        strCoachImagePath = strImage;

        [_IBImageProfie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strImage]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        NSMutableArray *CoachFiles= [[NSMutableArray alloc]init ];
        CoachFiles = [dic valueForKey:@"Coach File"];
        NSLog(@"CoachFiles=%@",CoachFiles);
        
        NSMutableArray *names = [[NSMutableArray alloc] init];
        names = [CoachFiles valueForKey:@"names"];
        
        aryPhotos = [[NSMutableArray alloc] init];
        aryVideos = [[NSMutableArray alloc] init];
        
        if (names.count > 0)
        {
            for (int i = 0; i<names.count; i++)
            {
                NSString *str = [NSString stringWithFormat:@"%@",[names objectAtIndex:i]];
                if ([str rangeOfString:@".png"].location != NSNotFound)
                {
                    [aryPhotos addObject:str];
                }
                else if ([str rangeOfString:@".mp4"].location != NSNotFound || [str rangeOfString:@".mov"].location != NSNotFound)
                {
                    [aryVideos addObject:str];
                }
            }
        }
        
        NSArray *TypesAryflexible_days = [[dic valueForKey:@"Flexible Days"] componentsSeparatedByString:@","];
        
        if (![TypesAryflexible_days containsObject:@"MONDAY"])
            [self.IBButtonMonday setAlpha:0.5];
        
        if (![TypesAryflexible_days containsObject:@"TUESDAY"])
            [self.IBButtonTuesday setAlpha:0.5];
        
        if (![TypesAryflexible_days containsObject:@"WEDNESDAY"])
            [self.IBButtonWednesday setAlpha:0.5];
    
        if (![TypesAryflexible_days containsObject:@"THURSDAY"])
            [self.IBButtonThursday setAlpha:0.5];
        
        if (![TypesAryflexible_days containsObject:@"FRIDAY"])
            [self.IBButtonFriday setAlpha:0.5];
        
        if (![TypesAryflexible_days containsObject:@"SATURDAY"])
            [self.IBButtonSaturday setAlpha:0.5];
        
        if (![TypesAryflexible_days containsObject:@"SUNDAY"])
            [self.IBButtonSunday setAlpha:0.5];
        
        
        
        /////  Types ///////
        
        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        NSArray *sportSypeArray = [sportstype componentsSeparatedByString:@","];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.bubbleView.delegate = self;
            
            [self.bubbleView fillBIGGERBubbleViewWithButtons:sportSypeArray bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
        });
        
    }
    
    [self LoadScrollViewSportsNames];
    NSLog(@"aryPhotos=%@",aryPhotos);
    NSLog(@"aryVideos=%@",aryVideos);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails  :   %@",dicUserDetials);
    
}
//////////////////////   Sports Name View METHODS  ///////////////

- (void) LoadScrollViewSportsNames
{
    int y=0 ;
    
    // NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
    NSLog(@"arySportsName=%@",arySportsName);
    for (int i = 0 ; i<arySportsName.count; i++)
    {
        if (![[arySportsName objectAtIndex:i] isEqualToString:@""])
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 0 , y, _IBViewSports.frame.size.width,40) ];
            view.backgroundColor = [UIColor colorWithRed:37/255.0 green:50/255.0 blue:122/255.0 alpha:1.0];
            view.layer.borderColor = [UIColor whiteColor].CGColor;
            view.layer.borderWidth = 1;
            [_IBViewSports addSubview:view];
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, view.frame.size.width-20, 30 ) ];
            lbl.text = [NSString stringWithFormat:@"%@",[arySportsName objectAtIndex:i]];
            lbl.numberOfLines = 0;
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont systemFontOfSize:15];
            [view addSubview:lbl];
            
            y+=50;

        }
        
    }
    
    _IBNSLayountHeightViewSports.constant = y;
    _IBNSLayountHeightContentVew.constant += y;
}


- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 290, 30)];
    title.text = @"Select Option";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textAlignment = NSTextAlignmentLeft;
    [demoView addSubview:title];
    
    Streaming = [[UIButton alloc] initWithFrame: CGRectMake( 20, 60, 250, 30 )];
    [Streaming setTitle: @"  Live Streaming" forState: UIControlStateNormal];
    [Streaming setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
    [Streaming addTarget:self action:@selector(RadioButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Streaming setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    Streaming.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    Streaming.tag =0;
    [demoView addSubview:Streaming];
    
    Record = [[UIButton alloc] initWithFrame: CGRectMake( 20, 100, 250, 30 )];
    [Record setTitle: @"  Send Video" forState: UIControlStateNormal];
    [Record setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
    [Record addTarget:self action:@selector(RadioButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [Record setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    Record.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    Record.tag=1;
    [demoView addSubview:Record];
    
    strVideoOption = @"Live Streaming";
    [Streaming setSelected:YES];
    [Streaming setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];

    return demoView;
}

-(void)RadioButtonClickEvent:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"button.tag  tag=%ld",(long)button.tag );
    
    switch ([sender tag]) {
        case 0:
            if([Streaming isSelected]==YES)
            {
                [Streaming setSelected:NO];
                [Streaming setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            else{
                
                strVideoOption = @"Live Streaming";
                [Streaming setSelected:YES];
                [Record setSelected:NO];
                
                [Streaming setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
                [Record setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
            if([Record isSelected]==YES)
            {
                [Record setSelected:NO];
                [Record setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            else{
                
                strVideoOption = @"Send Video";
                [Record setSelected:YES];
                [Streaming setSelected:NO];
                
                [Streaming setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
                [Record setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
                
            }
            
            break;
        default:
            break;
    }

    
}


 /////////  MARK : -  upload Video Button      ////////

- (IBAction)IBButtonClickHire:(id)sender
{
   
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", @"Cancel", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        //[alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

    
}
- (IBAction)IBButtonClickCalendar:(id)sender{
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    if ([Login isEqualToString:@"Coach"])
    {
        [appDelegate showAlertMessage:@"Please login with player"];
    }
    else
    {
        _IBViewMainCalender.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
        [self.view addSubview:_IBViewMainCalender];
    }
}

- (IBAction)IBButtonClickBack:(id)sender
{
    
    if(self.navigationController){
        if (self.navigationController.viewControllers.count <= 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else
         [self.navigationController popViewControllerAnimated:YES];
    } else
        [self dismissViewControllerAnimated:YES completion:nil];
}

///////////    MARK :- Calendar View /////////////

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    NSString *key = [_IBViewCalendar stringFromDate:date format:@"yyyy-MM-dd"];
    if ([_borderDefaultColors.allKeys containsObject:key]) {
        return _borderDefaultColors[key];
    }
    return appearance.borderDefaultColor;
}

- (BOOL)calendar:(FSCalendar *)calendar1 shouldSelectDate:(NSDate *)date
{
    NSDate *today = [NSDate date];
    NSLog(@"today=%@=========%@",today,date);
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *strfinal = [dateFormatter stringFromDate:today];
    strfinal = [strfinal stringByAppendingString:@" 18:30:00 +0000"];
    
    
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    
    NSDate *oldDate = [dateFormatter1 dateFromString:strfinal];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-3];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newToday = [calendar dateByAddingComponents:dateComponents toDate:oldDate options:0];
    
    NSLog(@"newToday=%@",newToday);
    
    
    
    NSComparisonResult result = [newToday compare:date];
    
    if(result == NSOrderedDescending)
    {
        [appDelegate showAlertMessage:@"You can not select previous date"];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)GototView
{

    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date{
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"calendar.selectedDates=%@",calendar.selectedDates);
    //  calendar.selectedDates = [[NSArray alloc]init ];
    
    calendarDateary = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [calendarDateary addObject:[calendar stringFromDate:obj format:@"yyyy-MM-dd"]];
        appDelegate.strCalendarDate = [NSString stringWithFormat:@"%@",[calendar stringFromDate:obj format:@"yyyy-MM-dd"]];
        
    }];
    
    NSLog(@"appDelegate.strCalendarDate %@",appDelegate.strCalendarDate);
    NSLog(@"selected dates is %@",calendarDateary);
    
    [self GototView];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{
    calendarDateary = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // [appDelegate.aryCalendarDate addObject:[calendar stringFromDate:obj format:@"yyyy/MM/dd"]];
    }];
    NSLog(@"selected dates is %@",calendarDateary);
}

- (IBAction)IBButtonClickRemoveView:(id)sender
{
    [_IBViewMainCalender removeFromSuperview];
}

- (IBAction)IBButonClickSendVideo:(id)sender
{
    NSLog(@"%@", appDelegate.strPlayerCheck);
    
    if ([appDelegate.strPlayerCheck isEqualToString:@"Direct"])
    {
        if ([ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
        {
            /////////  MARK : - Send Video    ////////
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Alert"
                                        message:@"Would you like to send your video now?"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                     PlayerVideoListPage *uvp = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVideoListPage"];
                                     [self.navigationController pushViewController:uvp animated:YES];
                             
                                     
                                 }];
            
            UIAlertAction *cancel = [UIAlertAction
                                     actionWithTitle:@"No"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            

            

        }
    }
    else
    {
        if ([_strCoachEdit isEqualToString:@"Player"])
        {
            //////  MARK :- Player Login ///////
            
            
            /////////  MARK : - Send Video    ////////
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Alert"
                                        message:@"Would you like to send your video now?"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
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
                                     
                                 }];
            
            UIAlertAction *cancel = [UIAlertAction
                                     actionWithTitle:@"No"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            

            
        }
        else
        {
            if ([ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                PlayerVideoListPage *uvp = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVideoListPage"];
                [self.navigationController pushViewController:uvp animated:YES];
            }
        }

    }
    


    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
           
            if (appDelegate.strVideoRandId.length == 0)
            {
                
                NSLog(@"%@",appDelegate.strPlayerstrVideoPath);
                NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
                NSLog(@"%@",videoURL);
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
                
                
                NSLog(@"IDS===%@==%@===%@===%@===%@===%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
                
                int randomID = arc4random() % 90000 + 10000;
                NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
                
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
                [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq :@"Capture" sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];

            }
            else
            {
                
                NSLog(@"IDS===%@==%@===%@===%@===%@===%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
                
                NSLog(@"Paths===%@==%@===%@===%@===",appDelegate.strPlayerSendVideo,appDelegate.strPlayerSendVideoPath,appDelegate.strPlayerSendThumb,appDelegate.strPlayerSendThumbPath
                      );

                
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
                [shared sendNotificationwithPath:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes:appDelegate.strFilterNotes videoreq:@"Capture" sporttype:appDelegate.strFilterSportType randid:appDelegate.strVideoRandId videofilename:appDelegate.strPlayerSendVideo videofile:appDelegate.strPlayerSendVideoPath thumbname:appDelegate.strPlayerSendThumb thumb:appDelegate.strPlayerSendThumbPath];
            }
            
            
            
            
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    appDelegate.strPlayerstrVideoPath = @"";
    
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self VideoCameraOpen];
                    break;
                case 1:
                    [self VideoGalleryOpen];
                    break;
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (buttonIndex) {
                case 0:
                    [self CameraOpen];
                    break;
                case 1:
                    [self GalleryOpen];
                    break;
                case 2:
                    [self iCloudOpen];
                    break;
            }
            break;
        }

            
        default:
            break;
    }
}


-(void) VideoCameraOpen
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
        //        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //        picker.delegate = self;
        //        picker.allowsEditing = YES;
        //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //
        //        [self presentViewController:picker animated:YES completion:NULL];
        
        [[[[iToast makeText:NSLocalizedString(@"Place camera horizontal.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationLong] show];
        
        [self startCameraControllerFromViewController: self
                                        usingDelegate: self];
    }
    
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    [cameraUI setVideoMaximumDuration:15.0f];
    cameraUI.allowsEditing = YES;
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
  
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

-(void) VideoGalleryOpen
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setVideoMaximumDuration:15.0f];
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    
//    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
//    {
//        appDelegate.urlImgPath=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
//    }
//    
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    [self performSelector:@selector(GotoVideoFilter) withObject:nil afterDelay:0.1];
//}

-(void) GotoVideoFilter
{
    VideoFilterPage *uvp = [[VideoFilterPage alloc]initWithNibName:@"VideoFilterPage" bundle:nil ];
    //[self.navigationController pushViewController:uvp animated:YES];
    [self presentViewController: uvp animated: NO completion: nil];
    

}

- (IBAction)IBButonClickLiveStream:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    AvailabilityViewController *pr = [storyboard instantiateViewControllerWithIdentifier:@"AvailabilityViewController"];
    pr.makeRequestForCouch = YES;
    [self showViewController:pr sender:self];
    
    
//    if ([appDelegate.strPlayerCheck isEqualToString:@"Direct"])
//    {
//        if ([ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
//        {
//            /////////  MARK : - Send Request for Live Stream request      ////////
//
//
//            UIAlertController *alert = [UIAlertController
//                                        alertControllerWithTitle:@"Alert"
//                                        message:@"For best results use video analysis first to enhance the live stream lesson with your MTC Professional/MTC Club Professional"
//                                        preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *ok = [UIAlertAction
//                                 actionWithTitle:@"Ok"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     NSString *str;
//
//                                     if (_IBTextFlexibledays.text.length == 0)
//                                     {
//                                         str = [NSString stringWithFormat:@"Would you like to send live stream lesson request?"];
//                                     }
//                                     else
//                                     {
//                                         str = [NSString stringWithFormat:@"Would you like to send live stream lesson request?\n\n %@",_IBTextFlexibledays.text];
//                                     }
//
//
//                                     UIAlertController *alert = [UIAlertController
//                                                                 alertControllerWithTitle:@"Alert"
//                                                                 message:str
//                                                                 preferredStyle:UIAlertControllerStyleAlert];
//
//                                     UIAlertAction *ok = [UIAlertAction
//                                                          actionWithTitle:@"Yes"
//                                                          style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                                          {
//                                                              NSLog(@"Coach_id==%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"]);
//                                                              SharedClass *shared =[SharedClass sharedInstance];
//                                                              shared.delegate =self;
//                                                              [shared RequestToCoachForLiveStream:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] passing_value:@"send"];
//
//
//                                                          }];
//
//                                     UIAlertAction *cancel = [UIAlertAction
//                                                              actionWithTitle:@"No"
//                                                              style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action)
//                                                              {
//                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
//                                                              }];
//                                     [alert addAction:ok];
//                                     [alert addAction:cancel];
//
//                                     [self presentViewController:alert animated:YES completion:nil];
//
//
//                                 }];
//
//
//            [alert addAction:ok];
//
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }
}
-(void)getUserDetails4:(NSDictionary *)dicVideoDetials
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOUR REQUEST HAS BEEN SENT" message:[NSString stringWithFormat:@"When your coach has selected a time from your availability calendar, you will be alerted under your “Pending Appointments” tab."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    
}



- (IBAction)IBButtonClickPA:(id)sender
{
    

    PendingAppoinmentVC *mv = [[PendingAppoinmentVC alloc]initWithNibName:@"PendingAppoinmentVC" bundle:nil ];
    [self.navigationController pushViewController:mv animated:YES];
}
- (IBAction)IBButtonClickAR:(id)sender
{
    NSString *strID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
    if(strID.length != 0)
    {
        [self LoadPlayerListData];
    }
}

- (IBAction)IBButtonClosePopUp:(id)sender
{
   _IBViewPopUp.alpha = 0.0;
    _IBButtonAddCertificate.alpha = 0.0;
}




//// MARK :-  Appointment Requests List  //////

-(void)LoadPlayerListData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]);
    
    [shared RequestAppointmentList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get_request_for_coach"];
    
}

//// MARK :-  Appointment Response List  //////

-(void)getUserDetails5:(NSDictionary *)dicVideoDetials
{
    
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    aryRequestList = [[NSMutableArray alloc]init];
    
    NSMutableArray *appointment_noty = [[NSMutableArray alloc] init];
    appointment_noty = [result valueForKey:@"request_noty"];
    NSLog(@"request_noty  :   %@",appointment_noty);
    
    if (appointment_noty != (id)[NSNull null])
    {
        @try
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[appointment_noty valueForKey:@"message"]uppercaseString]
                                                            message:@"\n" delegate:nil cancelButtonTitle:@"CLOSE" otherButtonTitles:nil , nil];
            [alert show];
            
        }
        @catch (NSException *exception)
        {
            
        }
    }
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        aryRequestList = [result valueForKey:@"request"];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    _IBLabelRequestBadge.text = [NSString stringWithFormat:@"%lu",(unsigned long)aryRequestList.count];
    if (_IBLabelRequestBadge.text.length == 0 || [_IBLabelRequestBadge.text isEqualToString:@"0"])
    {
        _IBLabelRequestBadge.hidden = YES;
    }
    else
    {
        _IBLabelRequestBadge.hidden = NO;
    }

    _IBLabelHeaderPopUp.text = @"YOU HAVE RECEIVED A LIVE STREAM REQUESTS FROM";
    _IBViewPopUp.alpha = 1.0;
    
    
    [_IBTblPopUp reloadData];
}


/////////  MARK : -  Club Method  ////////


- (IBAction)IBButtonClickCR:(id)sender
{
    //[self LoadClubListData];
}

/////////  MARK : -  Club Request Method  ////////

-(void)LoadClubListData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared RequestClubList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"list_club_request"];
    
}

/////////  MARK : -  Club Response Method  ////////

-(void)getUserDetails7:(NSDictionary *)dicVideoDetials
{
    
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    aryRequestList = [[NSMutableArray alloc]init];
   
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
         aryRequestList = [result valueForKey:@"data"];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    _IBLabelHeaderPopUp.text = @"YOU HAVE RECEIVED A CLUB REQUESTS FROM";
    _IBViewPopUp.alpha = 1.0;
   

    
    [_IBTblPopUp reloadData];
}

/////////  MARK : -  TableView Methods  ////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryRequestList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    EditPlayerPopUpCell *cell = (EditPlayerPopUpCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If there is no cell to reuse, create a new one
    if(cell == nil)
    {
        cell = [[EditPlayerPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.IBButtonDelete.alpha = 1.0;
    cell.IBButtonDelete.tag = indexPath.row;
    [cell.IBButtonDelete addTarget:self action:@selector(DeleteClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    if ([_IBLabelHeaderPopUp.text isEqualToString:@"CERTIFICATE"])
    {
        cell.IBLabelName.text = [NSString stringWithFormat:@"%@",[[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"certificate"]];
        if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Coach"])
        {
             cell.IBButtonDelete.alpha = 1.0;
             cell.IBLayoutHeightDelete.constant = 30;
        }
        else
        {
             cell.IBButtonDelete.alpha = 0.0;
             cell.IBLayoutHeightDelete.constant = 0;
        }
       

    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] isEqualToString:@"Player"])
        {
            cell.IBLabelName.text = [NSString stringWithFormat:@"%@",[[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"coach_name"]];
                   }
        else
        {
            cell.IBLabelName.text = [NSString stringWithFormat:@"%@",[[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"player_name"]];
        }
    }
    
   
//    [cell.IBButtonDelete setImage:[UIImage imageNamed:@"close40"] forState:UIControlStateNormal];
//    [cell.IBButtonDelete setImage:[UIImage imageNamed:@"close_h40"] forState:UIControlStateSelected];

    // Configure the cell before it is displayed...
    
    self.IBTblPopUp.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_IBLabelHeaderPopUp.text isEqualToString:@"CERTIFICATE"])
    {
        NSLog(@"path==%@",[[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"certificate_path"]);
        WebViewPage *pr = [[WebViewPage alloc]initWithNibName:@"WebViewPage" bundle:nil ];
        pr.strurl = [[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"certificate_path"];
        [self.navigationController pushViewController:pr animated:YES];
    }
    else
    {
            NSLog(@"playerid==%@",[[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"user_id"]);
            EditPlayerDetailPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlayerDetailPage"];
            appDelegate.strCoachtoPlayerId = [[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"user_id"];
            appDelegate.strRequestID = [[aryRequestList objectAtIndex:indexPath.row]valueForKey:@"id"];
            NSLog(@"str=%@",appDelegate.strRequestID);
            [self.navigationController pushViewController:pr animated:YES];
    }
}

- (void)DeleteClick:(UIButton *) sender
{
    if ([_IBLabelHeaderPopUp.text isEqualToString:@"CERTIFICATE"])
    {
        
         /////////  MARK : - Delete Certificate request      ////////
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Alert"
                                    message:@"Are you sure you would like to delete this certificate?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"id==%@",[[aryRequestList objectAtIndex:sender.tag]valueForKey:@"id"]);
                                 
                                 SharedClass *shared = [SharedClass sharedInstance];
                                 shared.delegate =self;
                                 [shared DeleteCertificate:[[aryRequestList objectAtIndex:sender.tag]valueForKey:@"id"]];
                                 
                             }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Alert"
                                    message:@"Are you sure you would like to Cancel this Request?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                     /////////  MARK : -  Request delete Methods  ////////
                                     
                                     SharedClass *shared = [SharedClass sharedInstance];
                                     shared.delegate =self;
                                     [shared DeleteRequestAppointmentFromList:[[aryRequestList objectAtIndex:sender.tag]valueForKey:@"id"] passing_value:@"delete_coach" user_type:@"coach"];
                             }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
   

}


/////////  MARK : -  Club Decline Methods Response  ////////

-(void)getUserDetails9:(NSDictionary *)dicVideoDetials
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
        _IBButtonAddCertificate.alpha = 0.0;
        _IBViewPopUp.alpha = 0.0;
        //[self performSelector:@selector(LoadClubListData) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    
}

/////////  MARK : -  Delete Appointment Request Methods Response  ////////
-(void)getUserDetails6:(NSDictionary *)dicVideoDetials
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
        _IBButtonAddCertificate.alpha = 0.0;
        _IBViewPopUp.alpha = 0.0;
        
        [self performSelector:@selector(LoadPlayerListData) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    
}

- (IBAction)IBButtonClickEDIT:(id)sender
{

    CoachRegistrationPage *pr = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachRegistrationPage"];
    pr.strEditTag = @"Edit";
    [self.navigationController pushViewController:pr animated:YES];
}
- (IBAction)IBButtonClickCoachVideo:(id)sender
{
    CoachVideoListPage *pr = [[CoachVideoListPage alloc]initWithNibName:@"CoachVideoListPage" bundle:nil ];
    [self.navigationController pushViewController:pr animated:YES];
}

- (IBAction)IBButtonClickCertificate:(id)sender
{
     [self performSelector:@selector(GetAllCertificates) withObject:nil afterDelay:0.1];
}

- (IBAction)IBButtonClickResume:(id)sender
{
    WebViewPage *pr = [[WebViewPage alloc]initWithNibName:@"WebViewPage" bundle:nil ];
    pr.strurl = strResume;
    [self.navigationController pushViewController:pr animated:YES];
}

- (IBAction)IBButtonClickClubRequest:(id)sender
{
        /////////  MARK : - Add Coach to Club request      ////////
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Alert"
                                    message:@"Are you sure you would like to request to this coach for join club?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 SharedClass *shared = [SharedClass sharedInstance];
                                 shared.delegate =self;
                                 [shared AddCoachtoClub:_strClubID coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] passing_value:@"request_to_coach"];
                                 
                             }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
  
}

/////////  MARK : - Add Coach to Club response      ////////

-(void)getUserDetails8:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOUR REQUEST HAS BEEN SENT" message:[NSString stringWithFormat:@"When coach has approve the request, he will added as a member in your club"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClubDetailPage *cp =[storyboard instantiateViewControllerWithIdentifier:@"ClubDetailPage"];
        [self.navigationController pushViewController:cp animated:YES];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
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


///////// MARK :- Certificate Upload Methods ///////


///////  ImagePickerController Class //////////


- (IBAction)IBButtonClickAddCertificate:(id)sender
{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            @"iCloud Drive",
                            nil];
    popup.tag = 2;
    [popup showInView:self.view];
    
}

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
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    strCertificate = @"";
    imgCertificate = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSelector:@selector(UploadCertificate) withObject:nil afterDelay:0.1];
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
      
            imgCertificate = nil;
            strCertificate =@"";
            strCertificate = [strCertificate stringByAppendingString:[url path]];
            NSLog(@"strCertificate=%@",strCertificate);
            
            NSArray *parts = [strCertificate componentsSeparatedByString:@"/"];
            NSString *filename = [parts lastObject];
            
            if ([filename rangeOfString:@".doc"].location != NSNotFound || [filename rangeOfString:@".docx"].location != NSNotFound || [filename rangeOfString:@".pdf"].location != NSNotFound || [filename rangeOfString:@".png"].location != NSNotFound || [filename rangeOfString:@".PNG"].location != NSNotFound || [filename rangeOfString:@".jpg"].location != NSNotFound || [filename rangeOfString:@".jpeg"].location != NSNotFound || [filename rangeOfString:@".JPG"].location != NSNotFound || [filename rangeOfString:@".JPEG"].location != NSNotFound)
            {
                [self performSelector:@selector(UploadCertificate) withObject:nil afterDelay:0.1];
            }
            else
            {
                [appDelegate showAlertMessage:@"Please select png,jpg,pdf,doc and docx format file."];
            }
        
        
        
    }
}



/////////  MARK : - UploadCertificate request      ////////

-(void)UploadCertificate
{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    [shared AddCertificate:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] certificate:strCertificate imgcertificate:imgCertificate];
}

/////////  MARK : - UploadCertificate response      ////////

-(void)getUserDetails10:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        [self performSelector:@selector(GetAllCertificates) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
}
/////////  MARK : - Get all Certificate request      ////////

-(void)GetAllCertificates
{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    if ([_strCoachEdit isEqualToString:@"Player"])
    {
        [shared GetAllCertificates:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"]];
        
    }
    else
    {
        [shared GetAllCertificates:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
        
    }

    
}

/////////  MARK : -  Get all Certificate response      ////////

-(void)getUserDetails11:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    aryRequestList = [[NSMutableArray alloc]init];
    int codevalue = [code intValue];
    
  
    
    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Coach"])
    {
        _IBButtonAddCertificate.alpha = 1.0;
        
    }
    else
    {
        _IBButtonAddCertificate.alpha = 0.0;
    }
    

    /*
    if (codevalue == 1)
    {
        aryRequestList = [result valueForKey:@"data"];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
     */
    
    NSDictionary* resultInfo = [dicVideoDetials objectForKey:@"result"];
    NSArray* certificatesInfos = [resultInfo objectForKey:@"data"];
    self.certificatesInfos = certificatesInfos;
    NSArray* certificatesURLs = [certificatesInfos valueForKey:@"certificate_path"];
    
    if (!self.certificatesController) {
        
        CertificatesListViewController* certificatesController = [self.storyboard instantiateViewControllerWithIdentifier:@"CertificatesListViewController"];
        self.certificatesController = certificatesController;
        certificatesController.delegate = self;
        BOOL ownProfile = [[[NSUserDefaults standardUserDefaults] stringForKey:@"CoachID"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"id"]];
        certificatesController.isOwnProfile = ownProfile;
        [certificatesController setupCertificatesURLs:certificatesURLs];
        
        [self.navigationController pushViewController:certificatesController animated:NO];
    } else{
        [self.certificatesController setupCertificatesURLs:certificatesURLs];
    }

    _IBLabelHeaderPopUp.text = @"CERTIFICATE";
    _IBViewPopUp.alpha = 1.0;
    
    [_IBTblPopUp reloadData];
}




/////////  MARK : -  Delete Certificate response      ////////

-(void)getUserDetails12:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
       [self performSelector:@selector(GetAllCertificates) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
}

- (void)addShadow{
    self.IBButtonCertificate.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.IBButtonCertificate.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.IBButtonCertificate.layer.shadowRadius = 3.0f;
    self.IBButtonCertificate.layer.shadowOpacity = 0.5f;
    
    self.IBButtonResume.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.IBButtonResume.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.IBButtonResume.layer.shadowRadius = 3.0f;
    self.IBButtonResume.layer.shadowOpacity = 0.5f;
    
    self.navigationBar.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationBar.layer.shadowRadius = 3.0f;
    self.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.shortMenu.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.shortMenu.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.shortMenu.layer.shadowRadius = 3.0f;
    self.shortMenu.layer.shadowOpacity = 0.5f;
}

-(void)didClickBubbleButton:(UIButton *)bubble{
    
}

#pragma mark - CertificatesListViewControllerDelegate

- (void)certificatesViewController:(CertificatesListViewController*)certificatesViewController
              didSelectNewDocument:(NSURL*)url{
    
    strCertificate = [url path];
    [self UploadCertificate];
  
//    NSString* state = [self.userInfo valueForKey:@"state"];
//    NSString* location = [self.userInfo valueForKey:@"Location"];
//
//    SharedClass *shared =[SharedClass sharedInstance];
//    shared.delegate =self;
//    [shared coachRegistration:_IBTextFieldName.text email:_IBTextFieldEmail.text password:_IBTextFieldpwd.textField.text location:location rate:_IBLableRateforVideo.text usertype:@"Coach" sporttype:strSportType sports_club:_strClubID rateforsession:_IBLableRateforSession.text rateforvideo:_IBTextRateforVideo.textField.text bio:_IBTextviewBio.text profileImage:_IBViewPhoto.image certificate:url.absoluteString resume:strResume imgcertificate:nil state:state strflexible_days:_IBTextFlexibledays.text facebookToken:nil gmailToken:nil];
    
}

- (void)certificatesViewController:(CertificatesListViewController*)certificatesViewController
  didSelectDeleteCertificateWithID:(NSString*)certificateURLToDelete{
    
    NSLog(@"DeleteCertificateWithURL id==%@",certificateURLToDelete);
    
    NSString* certIdToDelete;
    for (NSDictionary *info in self.certificatesInfos) {
        
        NSString* certificateURL = [info objectForKey:@"certificate_path"];
        if ([certificateURLToDelete isEqualToString:certificateURL]) {
            certIdToDelete = info[@"id"];
            break;
        }
    }
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    [shared DeleteCertificate:certIdToDelete];
}

@end
