//
//  EditPlayerDetailPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 11/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "EditPlayerDetailPage.h"
#import "MainViewController.h"
#import "PlayerVideoListPage.h"
#import "VideoChatViewController.h"
#import "PlayerRegistrationPage.h"
#import "EditPlayerPopUpCell.h"
#import "PendingAppoinmentVC.h"
#import "CalendarViewController.h"
#import "CoachDetailPage.h"
#import "UIViewController+MJPopupViewController.h"
#import "FeedBackView.h"
#import "AddPhotoAlert.h"
#import "BBView.h"



@interface EditPlayerDetailPage () <MJSecondPopupDelegate, BBDelegate>

{
    int SportsHeight;
    
}

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet BBView *bubbleView;
@property (strong, nonatomic) AddPhotoAlert *addPhotoAlert;
@property (weak, nonatomic) IBOutlet UIView *shortView;

@end

@implementation EditPlayerDetailPage

-(void)didClickBubbleButton:(UIButton *)bubble{}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bubbleView.delegate = self;
    self.addPhotoAlert = [[AddPhotoAlert alloc] init];
   
    
    self.bottomView.layer.shadowColor = self.shortView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.bottomView.layer.shadowOffset = self.shortView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bottomView.layer.shadowRadius = self.shortView.layer.shadowRadius = 3.0f;
    self.bottomView.layer.shadowOpacity = self.shortView.layer.shadowOpacity = 0.3f;
    self.bottomView.layer.masksToBounds = self.shortView.layer.masksToBounds = NO;
    
    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        _IBButtonVideo.hidden = NO;
        _IBButtonAR.hidden = NO;
        _IBButtonPA.hidden = NO;
        _IBButtonEdit.hidden = NO;
        
    }
    else
    {
        _IBButtonVideo.hidden = YES;
        _IBButtonAR.hidden = YES;
        _IBButtonPA.hidden = YES;
        _IBButtonEdit.hidden = YES;
    }

     appDelegate.strPlayerCoachTag = @"";
    
    /////////////   Alarm Notification /////////
    self.navigationController.navigationBarHidden = YES;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"eventArray=%@",eventArray);
    
    if (eventArray.count != 0)
    {
        [self CancelExistingNotification];
    }
    
    
    ////////////////
    
    
    strImagePath = [[NSString alloc]init ];
    strUserType= [[NSString alloc]init ];
    strSportType= [[NSString alloc]init ];
    arySportsType = [[NSMutableArray alloc]init ];
    
    _IBButtonMale.tag = 0;
    _IBButtonFemale.tag = 1;
  
    [_IBTblPopUp registerNib:[UINib nibWithNibName:@"EditPlayerPopUpCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
//     [self GetPlayerData];
    
    [self setNeedsStatusBarAppearanceUpdate];
 
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SaveChangeTag = YES;
    
    return YES;
}


- (IBAction)IBButtonClickEDIT:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    PlayerRegistrationPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"PlayerRegistrationPage"];
    pr.strEditTag = @"Edit";
    [self.navigationController pushViewController:pr animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [[NSUserDefaults standardUserDefaults] setObject:[timeZone name] forKey:@"TimeZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:2.0
//                                             target:self
//                                           selector:@selector(timerTicked:)
//                                           userInfo:nil
//                                            repeats:YES];
    
    
    
        if (appDelegate.isEndLiveStream)
        {
            appDelegate.isEndLiveStream = NO;
           
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"] && appDelegate.strCoachId.length != 0)
            {
                FeedBackView *detailViewController = [[FeedBackView alloc] initWithNibName:@"FeedBackView" bundle:nil];
                detailViewController.delegate = self;
                [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationFade];
            }
            
        }

    [self GetPlayerData];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setSelectedTextRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument]];
    return YES;
}

 /////////  MARK : -   Player Detail request response    ////////

-(void) GetPlayerData
{
    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared playerDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
    }
    else
    {
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared playerDetail:appDelegate.strCoachtoPlayerId];
    }
   
    
}

- (void)didReceivePlayerDetails:(NSDictionary *)dicVideoDetials{
    NSLog(@"getUserDetails_PlayerDetail  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    
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
    
    
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        _IBLabelBadge.hidden = YES;
        _IBLabelRequestBadge.hidden = YES;
        _IBLabelVideoBadge.hidden = YES;
    }
    
    
    for (NSDictionary *dic in information)
    {
        _IBTextFieldName.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
        // _IBTextFieldAge.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _IBTextFieldSelectCountry.text = [NSString stringWithFormat:@"%@,%@",[dic valueForKey:@"state"],[dic valueForKey:@"Location"]];
        _IBTextSkill.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Skill"]];
        strSportType =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Sport Type"]];
        
        if ([[dic valueForKey:@"state"] isEqualToString:@""]) {
            _IBTextFieldSelectCountry.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        }
        
        strImagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]];
        strImagePath = [strImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [_IBImageProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        /////  Gender ///////
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"Gender"]] isEqualToString:@"Male"])
        {
            strGender = @"Male";
            [_IBButtonMale setSelected:YES];
            [_IBButtonMale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
            
        }
        else if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"Gender"]] isEqualToString:@"Female"])
        {
            strGender = @"Female";
            [_IBButtonFemale setSelected:YES];
            [_IBButtonFemale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
        }
        else
        {
            strGender = @"N/A";
        }
        
        _IBLabelAge.text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"Age"] uppercaseString]];
        _IBLabelGender.text = [NSString stringWithFormat:@"%@",[strGender uppercaseString]];
        
        
        NSMutableArray *calendar= [[NSMutableArray alloc]init ];
        calendar =  [dic valueForKey:@"Calendar"];
        
        aryCalDate = [[NSMutableArray alloc]init ];
        [aryCalDate addObjectsFromArray:[calendar valueForKey:@"date"]];
        
        aryCalStatus = [[NSMutableArray alloc]init ];
        [aryCalStatus addObjectsFromArray:[calendar valueForKey:@"status"]];
        
        aryCalName = [[NSMutableArray alloc]init ];
        [aryCalName addObjectsFromArray:[calendar valueForKey:@"name"]];
        
        /// [self LoadScrollViewAppointment];
        
        
        if (appDelegate.strNotiDate.length == 0)
        {
            [self performSelector:@selector(setAlarm) withObject:nil afterDelay:2];
            
        }
        
        
        /////  Types ///////
        
        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        if (sportstype.length != 0)
        {
            arySportsName = [[NSArray alloc]init ];
            arySportsName = [sportstype componentsSeparatedByString:@","];
            
            [self.bubbleView fillBubbleViewWithButtons:arySportsName bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
        }
        
        [self LoadScrollViewSportsNames];
        
        NSLog(@"ary=%@",arySportsType);
        
    }
    
    
}

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_PlayerDetail  :   %@",dicVideoDetials);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    
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

    
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        _IBLabelBadge.hidden = YES;
        _IBLabelRequestBadge.hidden = YES;
        _IBLabelVideoBadge.hidden = YES;
    }
    
    
    for (NSDictionary *dic in information)
    {
        _IBTextFieldName.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
       // _IBTextFieldAge.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Age"]];
        _IBTextFieldSelectCountry.text = [NSString stringWithFormat:@"%@,%@",[dic valueForKey:@"state"],[dic valueForKey:@"Location"]];
         _IBTextSkill.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Skill"]];
         strSportType =[NSString stringWithFormat:@"%@",[dic valueForKey:@"Sport Type"]];
        
        if ([[dic valueForKey:@"state"] isEqualToString:@""]) {
             _IBTextFieldSelectCountry.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        }
        
        strImagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]];
        strImagePath = [strImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [_IBImageProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo Path"]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        /////  Gender ///////
        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"Gender"]] isEqualToString:@"Male"])
        {
            strGender = @"Male";
            [_IBButtonMale setSelected:YES];
            [_IBButtonMale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
            
        }
        else if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"Gender"]] isEqualToString:@"Female"])
        {
            strGender = @"Female";
            [_IBButtonFemale setSelected:YES];
            [_IBButtonFemale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
        }
        else
        {
            strGender = @"N/A";
        }
        
        _IBLabelAge.text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"Age"] uppercaseString]];
        _IBLabelGender.text = [NSString stringWithFormat:@"%@",[strGender uppercaseString]];
        
        
        NSMutableArray *calendar= [[NSMutableArray alloc]init ];
        calendar =  [dic valueForKey:@"Calendar"];
        
        aryCalDate = [[NSMutableArray alloc]init ];
        [aryCalDate addObjectsFromArray:[calendar valueForKey:@"date"]];
        
        aryCalStatus = [[NSMutableArray alloc]init ];
        [aryCalStatus addObjectsFromArray:[calendar valueForKey:@"status"]];
        
        aryCalName = [[NSMutableArray alloc]init ];
        [aryCalName addObjectsFromArray:[calendar valueForKey:@"name"]];

       /// [self LoadScrollViewAppointment];
        
        
        if (appDelegate.strNotiDate.length == 0)
        {
            [self performSelector:@selector(setAlarm) withObject:nil afterDelay:2];

        }
      
        
        /////  Types ///////

        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        if (sportstype.length != 0)
        {
            arySportsName = [[NSArray alloc]init ];
            arySportsName = [sportstype componentsSeparatedByString:@","];
            
            [self.bubbleView fillBubbleViewWithButtons:arySportsName bgColor:[UIColor clearColor] textColor:[UIColor blueColor] fontSize:12];
        }
    
         [self LoadScrollViewSportsNames];
        
        NSLog(@"ary=%@",arySportsType);

    }

   
}

- (void)timerTicked:(NSTimer*)timer1
{
    NSLog(@"Load");
   // [self LoadScrollViewAppointment];
    
    
}

//////////////////////   Sports Name View METHODS  ///////////////

- (void) LoadScrollViewSportsNames
{
    SportsHeight = 0 ;
    
    // NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
    NSLog(@"arySportsName=%@",arySportsName);
    for (int i = 0 ; i<arySportsName.count; i++)
    {
        if (![[arySportsName objectAtIndex:i] isEqualToString:@""])
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 0 , SportsHeight, _IBViewSports.frame.size.width,40) ];
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
            
            SportsHeight += 50;

        }
        
    }
    
    _IBNSLayountHeightViewSports.constant = SportsHeight;
    _IBNSLayountHeightContentVew.constant = _IBNSLayountHeightContentVew.constant + SportsHeight;
}


//////////////////////   LOAD APPOINTMENT METHODS  ///////////////

- (void) LoadScrollViewAppointment
{
    int y=0;
    
    for (UIView *v in _IBViewAppointment.subviews) {
        [v removeFromSuperview];
    }
    

    for (int i = 0 ; i<aryCalStatus.count; i++)
    {
        /////// Date Checker ////////
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate* enddate = [dateFormatter dateFromString:[aryCalDate objectAtIndex:i]];
        
//        NSDate* currentdate1 = [NSDate date];
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        [dateComponents setDay:-3];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDate *currentdate = [calendar dateByAddingComponents:dateComponents toDate:currentdate1 options:0];

        NSDate* currentdate1 = [NSDate date];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMinute:+5];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate* currentdate = [calendar dateByAddingComponents:dateComponents toDate:currentdate1 options:0];
       
        NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
        NSInteger minuteBetweenDates = distanceBetweenDates / 60;
       // NSLog(@"minuteBetweenDates %ld", (long)minuteBetweenDates);
        
        
        NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
        [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSString *strnow =[dateFormatter stringFromDate:currentdate];
        
        NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
        NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[aryCalDate objectAtIndex:i]]];
        
       // NSLog(@"now=%@",now);
      //  NSLog(@"end=%@",end);
        
        
        NSComparisonResult result;
        
        result = [now compare:end]; // comparing two dates
        
//        if(result==NSOrderedAscending)
//            NSLog(@"today is less");
//        else if(result==NSOrderedDescending)
//        NSLog(@"newDate is less");
//        else
//            NSLog(@"Both dates are same");

        
      
        if ([[aryCalStatus objectAtIndex:i] isEqualToString:@"occupied"] && minuteBetweenDates >= -20)
        {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 0 , y, _IBViewAppointment.frame.size.width,40) ];
            view.backgroundColor = [UIColor whiteColor];
            [_IBViewAppointment addSubview:view];
            
            
           // NSLog(@"date==%@",[aryCalDate objectAtIndex:i]);
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *oldDate = [dateFormatter dateFromString:[aryCalDate objectAtIndex:i]];
           // NSLog(@"oldDate==%@",oldDate);
            
            NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
            dateFormatter1.dateFormat = @"yyyy-MM-dd hh:mm:ss a";
            NSString *strDate = [dateFormatter1 stringFromDate:oldDate];
           // NSLog(@"strDate==%@",strDate);

            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, view.frame.size.width-80, 30 ) ];
            lbl.text = [NSString stringWithFormat:@"%@\n%@",[aryCalName objectAtIndex:i],strDate];
           // lbl.text = [NSString stringWithFormat:@"%@\n%@",[aryCalName objectAtIndex:i],[aryCalDate objectAtIndex:i]];
            lbl.numberOfLines = 0;
            lbl.textColor = [UIColor blackColor];
            lbl.font = [UIFont systemFontOfSize:12];
            [view addSubview:lbl];
            
          //  if ([[aryCalDate objectAtIndex:i] isEqualToString:appDelegate.strNotiDate])
            if(result==NSOrderedDescending)
            {
                UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(view.frame.size.width-100, 5, 90, 30 )];
                [button setTitle: @"Start Session" forState: UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                button.hidden = NO;
                //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(ButtonClickEventAppointment:) forControlEvents:UIControlEventTouchUpInside];
                //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
                [button setBackgroundColor: [UIColor colorWithRed:230/255.0 green:77/255.0 blue:1/255.0 alpha:1.0]];
                button.tag = i;
                [view addSubview:button];

            }
            else
            {
                UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(view.frame.size.width-100, 5, 90, 30 )];
                [button setTitle: @"Start Session" forState: UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                button.hidden = YES;
                //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(ButtonClickEventAppointment:) forControlEvents:UIControlEventTouchUpInside];
                //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
                [button setBackgroundColor: [UIColor colorWithRed:230/255.0 green:77/255.0 blue:1/255.0 alpha:1.0]];
                button.tag = i;
                [view addSubview:button];

            }

            y+=45;
            
        }
        
        
    }
    
    
    
    _IBNSLayountHeightTopView.constant = 400 + y;
    _IBNSLayountHeightContentVew.constant = SportsHeight + 800 + y;
    
    
   
    
}
-(void)ButtonClickEventAppointment:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld", (long)iTag);
    
    
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
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [timer invalidate];
            timer = nil;

            VideoChatViewController *uvp = [[VideoChatViewController alloc]initWithNibName:@"VideoChatViewController" bundle:nil ];
            [self presentViewController: uvp animated: NO completion: nil];
            
        }
        
    }
    
    // NSLog(@"ava=%@",Aryavailability);
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

 /////////  MARK : -  Male female Selection      ////////

- (IBAction)IBButtonMFSelection:(id)sender
{
    SaveChangeTag = YES;
    
    switch ([sender tag]) {
        case 0:
            if([_IBButtonMale isSelected]==YES)
            {
                [_IBButtonMale setSelected:NO];
                [_IBButtonMale setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            else{
                
                strGender = @"Male";
                [_IBButtonMale setSelected:YES];
                [_IBButtonFemale setSelected:NO];
                
                [_IBButtonMale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
                [_IBButtonFemale setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
            if([_IBButtonFemale isSelected]==YES)
            {
                [_IBButtonFemale setSelected:NO];
                [_IBButtonFemale setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
            }
            else{
                
                strGender = @"Female";
                [_IBButtonFemale setSelected:YES];
                [_IBButtonMale setSelected:NO];
                
                [_IBButtonMale setImage:[UIImage imageNamed:@"radio-inactive"] forState:UIControlStateNormal];
                [_IBButtonFemale setImage:[UIImage imageNamed:@"radio-active"] forState:UIControlStateSelected];
                
            }
            
            break;
        default:
            break;
    }
}


 /////////  MARK : -  Sports type Selection      ////////

- (IBAction)IBButtonClickAllTypes:(id)sender
{
    SaveChangeTag = YES;
    
    switch ([sender tag])
    {
        case 0:
            if([_IBButtonTennis isSelected]==YES)
            {
                [arySportsType removeObject:@"Tennis"];
                [_IBButtonTennis setSelected:NO];
                [_IBButtonTennis setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Tennis"];
                [_IBButtonTennis setSelected:YES];
                [_IBButtonTennis setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
        case 1:
            if([_IBButtonGolf isSelected]==YES)
            {
                [arySportsType removeObject:@"Golf"];
                [_IBButtonGolf setSelected:NO];
                [_IBButtonGolf setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Golf"];
                [_IBButtonGolf setSelected:YES];
                [_IBButtonGolf setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
        case 2:
            if([_IBButtonBasball isSelected]==YES)
            {
                [arySportsType removeObject:@"Baseball"];
                [_IBButtonBasball setSelected:NO];
                [_IBButtonBasball setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Baseball"];
                [_IBButtonBasball setSelected:YES];
                [_IBButtonBasball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        case 3:
            if([_IBButtonFootball isSelected]==YES)
            {
                [arySportsType removeObject:@"Football"];
                [_IBButtonFootball setSelected:NO];
                [_IBButtonFootball setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Football"];
                [_IBButtonFootball setSelected:YES];
                [_IBButtonFootball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        case 4:
            
            if([_IBButtonWresling isSelected]==YES)
            {
                [arySportsType removeObject:@"Wrestling"];
                [_IBButtonWresling setSelected:NO];
                [_IBButtonWresling setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Wrestling"];
                [_IBButtonWresling setSelected:YES];
                [_IBButtonWresling setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        case 5:
            if([_IBButtonCricket isSelected]==YES)
            {
                [arySportsType removeObject:@"Cricket"];
                [_IBButtonCricket setSelected:NO];
                [_IBButtonCricket setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Cricket"];
                [_IBButtonCricket setSelected:YES];
                [_IBButtonCricket setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        case 6:
            if([_IBButtonPerTrainer isSelected]==YES)
            {
                [arySportsType removeObject:@"Personal Trainer"];
                [_IBButtonPerTrainer setSelected:NO];
                [_IBButtonPerTrainer setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Personal Trainer"];
                [_IBButtonPerTrainer setSelected:YES];
                [_IBButtonPerTrainer setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        case 7:
            if([_IBButtonOther isSelected]==YES)
            {
                [arySportsType removeObject:@"Other"];
                [_IBButtonOther setSelected:NO];
                [_IBButtonOther setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
                
            }
            else
            {
                [arySportsType addObject:@"Other"];
                [_IBButtonOther setSelected:YES];
                [_IBButtonOther setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
            }
            
            break;
            
        default:
            break;
    }

    
}

 /////////  MARK : -  Save Information      ////////


- (IBAction)IBButtonClickEdit:(id)sender
{
    
    NSLog(@"ary=%@",arySportsType);
    
    if (arySportsType.count>0)
    {
        strSportType= [[NSString alloc]init ];
        for (int i=0; i<arySportsType.count; i++)
        {
            
            strSportType = [strSportType stringByAppendingString:[NSString stringWithFormat:@"%@",[arySportsType objectAtIndex:i]]];
            strSportType = [strSportType stringByAppendingString:@","];
        }
        
        strSportType = [strSportType substringToIndex:[strSportType length] - 1];
        NSLog(@"strSportType=%@",strSportType);
        
    }
    
    
    if (_IBTextFieldSelectCountry.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please select country"];
        
    }
    else if (_IBTextFieldAge.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter age"];
        
    }
    
    else if (_IBTextFieldSkill.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter skill"];
        
    }
    
    else if (strSportType.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please select Sports Type"];
        
    }
    
    else
    {
        
//        SharedClass *shared =[SharedClass sharedInstance];
//        shared.delegate =self;
//        [shared playerEdit:_IBTextFieldName.text email:_IBTextFieldEmail.text playerid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] gender:strGender location:_IBTextFieldSelectCountry.text age:@"" usertype:strUserType sporttype:strSportType skills:@"" profileImage:_IBImageProfile.image];

        
    }
}


 /////////  MARK : -  get Response for Save      ////////

-(void)getUserDetails:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_ :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:@"Login"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [timer invalidate];
        timer = nil;

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MainViewController *lp =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:lp animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
    }
    
    
}


- (IBAction)IBButtonClickBack:(id)sender
{

            [timer invalidate];
            timer = nil;
    
    
    if(self.navigationController){
        if (self.navigationController.presentingViewController){
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
//

//    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
//    }
//    else
//    {
//        if (appDelegate.isSavedProfile == YES)
//        {
//            appDelegate.isSavedProfile = NO;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
//        }
//        else
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//
//    }
    
}

 /////////  MARK : -  Camera Gallery options     ////////

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
    UIImage *chosenImage=info[UIImagePickerControllerOriginalImage];
    self.IBImageProfile.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
   
    SaveChangeTag = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
//////////////////////

- (IBAction)IBButtonClickVideo:(id)sender
{
    appDelegate.strPlayerCoachTag = @"Player";
    
    appDelegate.strPlayerCheck = @"Indirect";

    
    [timer invalidate];
    timer = nil;

    PlayerVideoListPage *cp = [[PlayerVideoListPage alloc]initWithNibName:@"PlayerVideoListPage" bundle:nil ];
    [self.navigationController pushViewController:cp animated:YES];
}



/////////////////////////  ALARM ////////////////////////////

-(void)setAlarm
{
    for (int i =0 ; i< aryCalDate.count; i++)
    {
        if ([[aryCalStatus objectAtIndex:i] isEqualToString:@"occupied"])
        {
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* currentdate = [NSDate date];
            
            
            NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
            [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            
            NSString *strnow =[dateFormatter stringFromDate:currentdate];
            
            NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
            NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[aryCalDate objectAtIndex:i]]];
//            
//            NSLog(@"now=%@",now);
//            NSLog(@"end=%@",end);
//            
            
            NSComparisonResult result;
            
            result = [now compare:end]; // comparing two dates
            
            if(result==NSOrderedAscending)
            {
                 NSLog(@"today is less");
                [self SetAlarm:[aryCalDate objectAtIndex:i]];
            }
            
            else if(result==NSOrderedDescending)
                NSLog(@"newDate is less");
            else
                NSLog(@"Both dates are same");

           
        }
    }
    
}

-(void)SetAlarm : (NSString *)Date
{
 
    
    NSLog(@"Date==%@",Date);

    
    NSString *strfinal = [NSString stringWithFormat:@"%@ +0000",Date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *oldDate = [dateFormatter dateFromString:strfinal];
    NSLog(@"oldDate%@",oldDate);
    

    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setHour:-5];
    [dateComponents setMinute:-35];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    newDate = [calendar dateByAddingComponents:dateComponents toDate:oldDate options:0];
    
    NSLog(@"newDate=%@",newDate);
    
    
    AlarmObject * newAlarmObject;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForPlayer"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    if(!alarmList)
    {
        alarmList = [[NSMutableArray alloc]init];
    }
    
    //    if(self.editMode)//Editing Alarm that already exists
    //    {
    //        newAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];
    //
    //        [self CancelExistingNotification];
    //    }
    //    else//Adding a new alarm
    //    {
    newAlarmObject = [[AlarmObject alloc]init];
    newAlarmObject.enabled = YES;
    newAlarmObject.notificationID = [self getUniqueNotificationID];
    
    //     }
    
    //    newAlarmObject.label = self.label;
    newAlarmObject.timeToSetOff = newDate;
    newAlarmObject.enabled = YES;
    
    
    NSLog(@"newAlarmObject.notificationID=%d",newAlarmObject.notificationID);
    NSLog(@"timeToSetOff=%@",newAlarmObject.timeToSetOff);
    
    
    
    [self scheduleLocalNotificationWithDate:newAlarmObject.timeToSetOff atIndex:newAlarmObject.notificationID date:Date];
    
   
    [alarmList addObject:newAlarmObject];
        
        

    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForPlayer"];
    
}


- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
                                  atIndex:(int)indexOfObject date:(NSString *)Date{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    if (!localNotification)
        return;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate* date = [dateFormatter dateFromString:[dateFormatter stringFromDate:newDate]];
    NSLog(@"date=%@",date);
    
    localNotification.repeatInterval = FALSE;
    [localNotification setFireDate:date];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    // Setup alert notification
    
    NSString *Str = [NSString stringWithFormat:@"Live Streaming Request"];
    
    [localNotification setAlertBody:Str];
    [localNotification setAlertAction:@"Open App"];
    [localNotification setHasAction:YES];
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:indexOfObject] forKey:@"notificationID"];
    [dict setObject:Date forKey:@"Date"];
 
    
    
    localNotification.userInfo = dict;
    NSLog(@"Uid Store in userInfo %@", [localNotification.userInfo objectForKey:@"notificationID"]);
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForPlayer"];
    NSLog(@"alarmListData111111=%@",alarmListData);
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"eventArray111111=%@",eventArray);
    
    
}

//Get Unique Notification ID for a new alarm O(n)
-(int)getUniqueNotificationID
{
    NSMutableDictionary * hashDict = [[NSMutableDictionary alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSNumber *uid= [userInfoCurrent valueForKey:@"notificationID"];
        NSNumber * value =[NSNumber numberWithInt:1];
        [hashDict setObject:value forKey:uid];
    }
    for (int i=0; i<[eventArray count]+1; i++)
    {
        NSNumber * value = [hashDict objectForKey:[NSNumber numberWithInt:i]];
        if(!value)
        {
            return i;
        }
    }
    return 0;
    
}

- (void)CancelExistingNotification
{
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"eventArray=%@",eventArray);
    
    if (eventArray.count != 0)
    {
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            [app cancelLocalNotification:oneEvent];
        }
    }
    
    NSLog(@"eventArray111=%@",eventArray);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForPlayer"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    if (alarmList.count != 0)
    {
        for (int i=0; i<[alarmList count]; i++)
        {
            [alarmList removeObjectAtIndex: i];
        }
    }
    
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForPlayer"];
}



-(void)LoadPlayerListData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]);
    [shared RequestAppointmentListForPlayer:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get_request_for_player"];
    
}
-(void)getUserDetails5:(NSDictionary *)dicVideoDetials
{
    
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    aryPlayerList = [[NSMutableArray alloc]init];
    
    
    NSMutableArray *appointment_noty = [[NSMutableArray alloc] init];
    appointment_noty = [result valueForKey:@"request_noty"];
    NSLog(@"request_noty  :   %@",appointment_noty);
    if (appointment_noty != (id)[NSNull null])
    {
        @try
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[appointment_noty valueForKey:@"message"]uppercaseString ]
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

        aryPlayerList = [result valueForKey:@"request"];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
     _IBViewPopUp.alpha = 1.0;
    
    _IBLabelRequestBadge.text = [NSString stringWithFormat:@"%lu",(unsigned long)aryPlayerList.count];
    if (_IBLabelRequestBadge.text.length == 0 || [_IBLabelRequestBadge.text isEqualToString:@"0"])
    {
        _IBLabelRequestBadge.hidden = YES;
    }
    else
    {
        _IBLabelRequestBadge.hidden = NO;
    }

    
    [_IBTblPopUp reloadData];
}



/////////  MARK : -  TableView Methods      ////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryPlayerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    EditPlayerPopUpCell *cell = (EditPlayerPopUpCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[EditPlayerPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.IBLabelName.text = [NSString stringWithFormat:@"%@",[[aryPlayerList objectAtIndex:indexPath.row]valueForKey:@"coach_name"]];
    
    cell.IBButtonDelete.tag = indexPath.row;
    [cell.IBButtonDelete addTarget:self action:@selector(DeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
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

    CoachDetailPage *cp = [[CoachDetailPage alloc]initWithNibName:@"CoachDetailPage" bundle:nil];
    cp.strCoachEdit = @"Player";
    [self.navigationController pushViewController:cp animated:YES];
    
}

- (void) DeleteClick:(UIButton *) sender
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
                             SharedClass *shared = [SharedClass sharedInstance];
                             shared.delegate =self;
                             [shared DeleteRequestAppointmentFromList:[[aryPlayerList objectAtIndex:sender.tag]valueForKey:@"id"] passing_value:@"delete_coach" user_type:@"player"];
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
        _IBViewPopUp.alpha = 0.0;
        [self performSelector:@selector(LoadPlayerListData) withObject:nil afterDelay:0.1];
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
    appDelegate.strPlayerCheck = @"Direct";
     [self LoadPlayerListData];
}

- (IBAction)IBButtonClosePopUp:(id)sender
{
    _IBViewPopUp.alpha = 0.0;
}

///////////////  MARK :- Live Stream ///////////////

- (IBAction)IBButtonClickAvailability:(id)sender
{
    
    appDelegate.strPlayerCheck = @"Indirect";

    _IBViewMainCalender.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    [self.view addSubview:_IBViewMainCalender];
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
    // NSLog(@"oldDate%@",oldDate);
    
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
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
        
        //        BOOL shouldDedeselect = [_IBViewCalendar dayOfDate:date] != 5;
        //        if (!shouldDedeselect) {
        //            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be selected",[calendar stringFromDate:date]] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        //            return NO;
        //        }
        
        return YES;
    }
    
    
    //  [self calendar:calendar shouldSelectDate:date];
}

-(void)GototView
{
   
    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date
{
    return YES;

}



- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"calendar.selectedDates=%@",calendar.selectedDates);
    //  calendar.selectedDates = [[NSArray alloc]init ];
    
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
        appDelegate.strCalendarDate = [NSString stringWithFormat:@"%@",[calendar stringFromDate:obj format:@"yyyy-MM-dd"]];
        
    }];
    
    NSLog(@"appDelegate.strCalendarDate %@",appDelegate.strCalendarDate);

    
    SaveChangeTag = YES;
    CalendarViewController *cv = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    [self.navigationController pushViewController:cv animated:YES];
   
    
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{
    
}



- (IBAction)IBButtonClickCancel:(id)sender
{
    [_IBViewMainCalender removeFromSuperview];
}





@end
