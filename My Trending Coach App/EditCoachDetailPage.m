//
//  EditCoachDetailPage.m
//  My Trending Coach App
//
//  Created by Nisarg on 11/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "EditCoachDetailPage.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LoginPage.h"

#import "UIViewController+MJPopupViewController.h"
#import "CalendarViewController.h"
#import "VideoChatViewController.h"
#import "CoachVideoListPage.h"
#import "IQUIView+IQKeyboardToolbar.h"


@interface EditCoachDetailPage () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    int SportsHeight;
}
@end

@implementation EditCoachDetailPage
{
    int imageTag;
    UICollectionView *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    
    NSLog(@"id=%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]);
    strRating =[[NSString alloc]init ];
    strImagePathProfile = [[NSString alloc]init ];
    strUserType= [[NSString alloc]init ];
    strSportType= [[NSString alloc]init ];
    arySportsType = [[NSMutableArray alloc]init ];
    
    
//    _IBImageProfile.clipsToBounds=YES;
//    _IBImageProfile.layer.cornerRadius = _IBImageProfile.bounds.size.width / 2.0;
//    _IBImageProfile.layer.borderColor=[UIColor whiteColor].CGColor;
//    _IBImageProfile.layer.borderWidth=2.0f;

   //[_IBTextFieldSelectCountry setItemList:[NSArray arrayWithObjects:@"Australia",@"Brazil",@"Canada",@"India",@"South Africa",@"U.K.",@"U.S.", nil]];
  //  [_IBTextFieldSelectGraduate setItemList:[NSArray arrayWithObjects:@"test1",@"test2",@"test3",@"test4",@"test5",@"test6", nil]];
    
     [self GetCoachData];

    
    // Do any additional setup after loading the view from its nib.
    [_IBTextFieldSelectCountry addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    
    
    
  }




-(void)doneAction:(UIBarButtonItem*)barButton
{
    SaveChangeTag = YES;
    [_IBTextFieldSelectCountry resignFirstResponder];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SaveChangeTag = YES;
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setSelectedTextRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument]];
    return YES;
}
 /////////  MARK : -  For Coach Detail      ////////

-(void) GetCoachData
{
    _IBNSLayountHeightContentVew.constant = 650;
    _IBNSLayountHeightPhoto.constant = 0;
    _IBNSLayountHeightVideo.constant = 0;
    _IBNSLayountHeightAppointmentVw.constant = 0;
    
    
    SharedClass *shared =[SharedClass sharedInstance];
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
        _IBTextFieldName.text = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"Name"]]uppercaseString];
        _IBTextFieldEmail.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Email"]];
        _IBLabelRate.text = [NSString stringWithFormat:@"$%@/SESSION",[dic valueForKey:@"Rate"]];
        _IBTextFieldSelectCountry.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Location"]];
        _IBLabelEducation.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"College Name"]];
        
    
        @try
        {
            _IBTextFieldCertificate.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Certificate"]];
        }
        @catch (NSException *exception)
        {
            
        }

        
        strRating = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Rating"]];
        float value = [strRating floatValue];
        _IBViewRating.value = value;
        
        strImagePathProfile = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Coach Image Path"]];
        [_IBImageProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Coach Image Path"]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
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
        
        
        NSLog(@"aryPhotos=%@",aryPhotos);
        NSLog(@"aryVideos=%@",aryVideos);
        
        NSMutableArray *calendar= [[NSMutableArray alloc]init ];
        calendar =  [dic valueForKey:@"Calendar"];
        
        
        appDelegate.aryCalendarDate = [[NSMutableArray alloc]init ];
        [appDelegate.aryCalendarDate addObjectsFromArray:[calendar valueForKey:@"date"]];
        
        appDelegate.aryCalendarStatus = [[NSMutableArray alloc]init ];
        [appDelegate.aryCalendarStatus addObjectsFromArray:[calendar valueForKey:@"status"]];
        
        appDelegate.aryPlayerIDs = [[NSMutableArray alloc]init ];
        [appDelegate.aryPlayerIDs addObjectsFromArray:[calendar valueForKey:@"id"]];
        
        
        aryCalName = [[NSMutableArray alloc]init ];
        [aryCalName addObjectsFromArray:[calendar valueForKey:@"name"]];
        
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
                    
//                    NSString *localDate = [self getLocalDateTimeFromUTC:[appDelegate.aryCalendarDate objectAtIndex:i]];
//                    NSLog(@"localDate=%@",localDate);

                }
                
            }
        }
        
        NSLog(@"self.borderDefaultColors=%@",self.borderDefaultColors);
        
        
        [self LoadScrollViewAppointment];
      
        
        if (appDelegate.strNotiDate.length == 0)
        {
            [self performSelector:@selector(setAlarm) withObject:nil afterDelay:2];
            
        }

        /////  Types ///////

        
        NSString *sportstype = [[NSString alloc] init];
        sportstype = [dic valueForKey:@"Sport Type"];
        
        NSArray *TypesAry = [sportstype componentsSeparatedByString:@","];
        arySportsName = [[NSArray alloc]init ];
        arySportsName = [sportstype componentsSeparatedByString:@","];
        for (int i = 0; i<TypesAry.count; i++)
        {
            
            NSString *str = [NSString stringWithFormat:@"%@",[TypesAry objectAtIndex:i]];
            
            if ([str caseInsensitiveCompare:@"TENNIS"] == NSOrderedSame)
            {
                [arySportsType addObject:@"TENNIS"];
                
            }
            else if ([str caseInsensitiveCompare:@"GOLF"] == NSOrderedSame)
            {
                [arySportsType addObject:@"GOLF"];
                
            }
            else if ([str caseInsensitiveCompare:@"BASEBALL"] == NSOrderedSame)
            {
                [arySportsType addObject:@"BASEBALL"];
                
            }
            else if ([str caseInsensitiveCompare:@"SOFTBALL"] == NSOrderedSame)
            {
                [arySportsType addObject:@"SOFTBALL"];
                
            }
            else if ([str caseInsensitiveCompare:@"(American) FOOTBALL"] == NSOrderedSame)
            {
                [arySportsType addObject:@"(American) FOOTBALL"];
                
            }
            else if ([str caseInsensitiveCompare:@"(Football) SOCCER"] == NSOrderedSame)
            {
                [arySportsType addObject:@"(Football) SOCCER"];
                
            }
            else if ([str caseInsensitiveCompare:@"FITNESS"] == NSOrderedSame)
            {
                [arySportsType addObject:@"FITNESS"];
                
            }
            else if ([str caseInsensitiveCompare:@"PERSONAL TRAINER"] == NSOrderedSame)
            {
                [arySportsType addObject:@"PERSONAL TRAINER"];
                
            }
            else if ([str caseInsensitiveCompare:@"SPORT PSYCHOLOGY"] == NSOrderedSame)
            {
                [arySportsType addObject:@"SPORT PSYCHOLOGY"];
                
            }
            else if ([str caseInsensitiveCompare:@"OTHER"] == NSOrderedSame)
            {
                [arySportsType addObject:@"OTHER"];
                
            }
            
            
           

//            if ([str caseInsensitiveCompare:@"Tennis"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Tennis"];
//                [_IBButtonTennis setSelected:YES];
//                [_IBButtonTennis setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//                
//            }
//            else if ([str caseInsensitiveCompare:@"Golf"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Golf"];
//                [_IBButtonGolf setSelected:YES];
//                [_IBButtonGolf setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            else if ([str caseInsensitiveCompare:@"Baseball"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Baseball"];
//                [_IBButtonBasball setSelected:YES];
//                [_IBButtonBasball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            else if ([str caseInsensitiveCompare:@"Football"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Football"];
//                [_IBButtonFootball setSelected:YES];
//                [_IBButtonFootball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            else if ([str caseInsensitiveCompare:@"Wrestling"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Wrestling"];
//                [_IBButtonWresling setSelected:YES];
//                [_IBButtonWresling setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            else if ([str caseInsensitiveCompare:@"Cricket"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Cricket"];
//                [_IBButtonCricket setSelected:YES];
//                [_IBButtonCricket setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            else if ([str caseInsensitiveCompare:@"Personal Trainer"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Personal Trainer"];
//                [_IBButtonPerTrainer setSelected:YES];
//                [_IBButtonPerTrainer setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            else if ([str caseInsensitiveCompare:@"Other"] == NSOrderedSame)
//            {
//                [arySportsType addObject:@"Other"];
//                [_IBButtonOther setSelected:YES];
//                [_IBButtonOther setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
            
        }

    }
    
    
    
      [self LoadScrollViewSportsNames];
//    [self LoadScrollViewPhotos];
//    [self LoadScrollViewVideos];
    

}


- (void)timerTicked:(NSTimer*)timer1
{
    NSLog(@"Load");
    [self LoadScrollViewAppointment];
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [[NSUserDefaults standardUserDefaults] setObject:[timeZone name] forKey:@"TimeZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(timerTicked:)
                                           userInfo:nil
                                            repeats:YES];

//    self.borderDefaultColors = @{@"2016/04/8":[UIColor purpleColor],
//                                 @"2016/04/17":[UIColor purpleColor],
//                                 @"2016/04/21":[UIColor purpleColor],
//                                 @"2016/04/25":[UIColor purpleColor]};
   
    

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
    
    [_IBViewCalendar reloadData];
     NSLog(@"self.borderDefaultColors=%@",self.borderDefaultColors);
}


 /////////  MARK : -  Rating chanage Methods      ////////

- (IBAction)didChangeValue:(HCSStarRatingView *)sender
{
    NSLog(@"Changed rating to %.1f", sender.value);
    
    strRating = [NSString stringWithFormat:@"%f",sender.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
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



//////////////////////   LOAD APPOINTMENT METHODS  ///////////////

- (void) LoadScrollViewAppointment
{
    
   
    int y=0;
    
    for (UIView *v in _IBViewAppointment.subviews) {
        [v removeFromSuperview];
    }

    
    for (int i = 0 ; i<appDelegate.aryCalendarStatus.count; i++)
    {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate* enddate = [dateFormatter dateFromString:[appDelegate.aryCalendarDate objectAtIndex:i]];
        NSDate* currentdate1 = [NSDate date];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMinute:+5];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate* currentdate = [calendar dateByAddingComponents:dateComponents toDate:currentdate1 options:0];

        
        
        NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
        
       // double secondsInAnHour = 3600;
      //  NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        NSInteger minuteBetweenDates = distanceBetweenDates / 60;
        
//        if (minuteBetweenDates > 0)
//            NSLog(@"0 seconds");
//        else if (minuteBetweenDates < 0)
//             NSLog(@"<0 seconds");
//        else
//             NSLog(@"equl seconds");
//        NSLog(@"minuteBetweenDates=%d",minuteBetweenDates );
//        NSLog(@"status=%@",[appDelegate.aryCalendarStatus objectAtIndex:i] );
//        NSLog(@"currentdate=%@===%@",currentdate,enddate);
//        NSLog(@"appDelegate.aryCalendarDate=%@",appDelegate.aryCalendarDate);
        
        
        NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
        [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSString *strnow =[dateFormatter stringFromDate:currentdate];
        
        NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
        NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[appDelegate.aryCalendarDate objectAtIndex:i]]];
        
//        NSLog(@"now=%@",now);
//        NSLog(@"end=%@",end);
    
        
        NSComparisonResult result;
       
        result = [now compare:end]; // comparing two dates
        
//        if(result==NSOrderedAscending)
//            NSLog(@"today is less");
//        else if(result==NSOrderedDescending)
//            NSLog(@"newDate is less");
//        else
//            NSLog(@"Both dates are same");
        
       
        
        if ([[appDelegate.aryCalendarStatus objectAtIndex:i] isEqualToString:@"occupied"] && minuteBetweenDates >= -20)
        {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( 0 , y, _IBViewAppointment.frame.size.width,40) ];
            view.backgroundColor = [UIColor whiteColor];
            [_IBViewAppointment addSubview:view];
            
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, view.frame.size.width-80, 30 ) ];
            
          //  NSLog(@"date==%@",[appDelegate.aryCalendarDate objectAtIndex:i]);
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *oldDate = [dateFormatter dateFromString:[appDelegate.aryCalendarDate objectAtIndex:i]];
           // NSLog(@"oldDate==%@",oldDate);
            
            NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
            dateFormatter1.dateFormat = @"yyyy-MM-dd hh:mm:ss a";
            NSString *strDate = [dateFormatter1 stringFromDate:oldDate];
           // NSLog(@"strDate==%@",strDate);
            
            lbl.text = [NSString stringWithFormat:@"%@\n%@",[aryCalName objectAtIndex:i],strDate];
            //lbl.text = [NSString stringWithFormat:@"%@\n%@",[aryCalName objectAtIndex:i],[appDelegate.aryCalendarDate objectAtIndex:i]];
            lbl.numberOfLines = 0;
            lbl.textColor = [UIColor blackColor];
            lbl.font = [UIFont systemFontOfSize:12];
            [view addSubview:lbl];
            
            
            
            //if ([[appDelegate.aryCalendarDate objectAtIndex:i] isEqualToString:appDelegate.strNotiDate])
            if( result == NSOrderedDescending)
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
    
     _IBNSLayountHeightTopView.constant = 500 + y;
    _IBNSLayountHeightContentVew.constant = SportsHeight + 660 + y;
    
}
-(void)ButtonClickEventAppointment:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld", (long)iTag);
    
    [timer invalidate];
    timer = nil;

    VideoChatViewController *uvp = [[VideoChatViewController alloc]initWithNibName:@"VideoChatViewController" bundle:nil ];
    [self presentViewController: uvp animated: NO completion: nil];

}


//////////////////////   Sports Name View METHODS  ///////////////

- (void) LoadScrollViewSportsNames
{
    SportsHeight = 0 ;
    
    // NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
    NSLog(@"arySportsName=%@",arySportsName);
    for (int i = 0 ; i<arySportsName.count; i++)
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
    
    _IBNSLayountHeightViewSports.constant = SportsHeight;
    _IBNSLayountHeightContentVew.constant += SportsHeight;
    NSLog(@"SportsHeight=%d",SportsHeight);
}



//////////////////////   UPLOAD PHOTOS METHODS  ///////////////

- (void) LoadScrollViewPhotos
{
    int x=20, y=0 ;
    
   // NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
   
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480 || result.height == 568) {x =20;}
        
        else if (result.height == 667) {x =35;}
        
        else if (result.height >= 736) {x =45;}
    }

    
    for (int i = 0 ; i<aryPhotos.count; i++)
    {
        
         NSLog(@"photoUrl=%@",[NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryPhotos objectAtIndex:0]]);
        
         UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake( x, y, 100, 100)];
        
//        NSString *strpath = [NSString stringWithFormat:@"%@",[aryPhotos objectAtIndex:i] ];
//        NSLog(@"strpath=%@",strpath);
//        if ([strpath rangeOfString:@"/var/mobile/Containers/Data/Application/"].location != NSNotFound)
//        {
//            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[aryPhotos objectAtIndex:i]]];
//        }
//        else
//        {
            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryPhotos objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"noimage"]];

       // }
        
       //
        img.contentMode = UIViewContentModeScaleToFill;
        [_IBViewPhotos addSubview:img];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(  x, y, img.frame.size.width, img.frame.size.height )];
        // [button setTitle: @"My Button" forState: UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClickEventPhotos:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        button.tag = i;
        [_IBViewPhotos addSubview:button];
        
        
        
        x += [[UIScreen mainScreen] bounds].size.width/2;
        
        if (x > 310) {
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                
                if (result.height == 480 || result.height == 568) {x =20;}
                
                else if (result.height == 667) {x =35;}
                
                else if (result.height >= 736) {x =45;}
            }
            y += 120;
        }

        
    }
    
    if (aryPhotos.count % 2)
    {
        _IBNSLayountHeightPhoto.constant = y+120;
        _IBNSLayountHeightContentVew.constant += y+120;
    }
    else
    {
        _IBNSLayountHeightPhoto.constant = y;
        _IBNSLayountHeightContentVew.constant += y;
    }
   
    
    
}

-(void)ButtonClickEventPhotos:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld", (long)iTag);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ///MARK :-  Animation ScrollView
//    CGPoint bottomOffset = CGPointMake(0, self.IBScrollView.contentSize.height - self.IBScrollView.bounds.size.height);
//    [self.IBScrollView setContentOffset:bottomOffset animated:YES];
    
}

//////////////////////   UPLOAD VIDEOS METHODS  ///////////////

- (void) LoadScrollViewVideos
{
    int x=20, y=0;
    
    //NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"cricket",nil ];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if (result.height == 480 || result.height == 568) {x =20;}
        
        else if (result.height == 667) {x =35;}
        
        else if (result.height >= 736) {x =45;}
    }

    for (int i = 0 ; i<aryVideos.count; i++)
    {
//         NSLog(@"VideoUrl=%@",[NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryVideos objectAtIndex:0]]);
       
        UIWebView *webview =[[UIWebView alloc] initWithFrame:CGRectMake( x, y, 100, 100)];
        NSString *url= [NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryVideos objectAtIndex:i]];
        
        NSURL *nsurl;
        
//        NSString *strpath = [NSString stringWithFormat:@"%@",[aryVideos objectAtIndex:i] ];
//        NSLog(@"strpath=%@",strpath);
//        if ([strpath rangeOfString:@"/var/mobile/Containers/Data/Application/"].location != NSNotFound)
//        {
//            nsurl = [NSURL fileURLWithPath:strpath];
//        }
//        else
//        {
            nsurl = [NSURL URLWithString:url];
       // }
        
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [webview loadRequest:nsrequest];
        [_IBViewVideo addSubview:webview];
        
        
        
        x += [[UIScreen mainScreen] bounds].size.width/2;
        
        if (x > 310) {
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                
                if (result.height == 480 || result.height == 568) {x =20;}
                
                else if (result.height == 667) {x =35;}
                
                else if (result.height >= 736) {x =45;}
            }

            y += 120;
        }
        
    }
    
    
    if (aryVideos.count % 2)
    {
        _IBNSLayountHeightVideo.constant = y+120;
        _IBNSLayountHeightContentVew.constant += y+120;
    }
    else
    {
        _IBNSLayountHeightVideo.constant = y;
        _IBNSLayountHeightContentVew.constant += y;
    }

  
}

-(void)ButtonClickEventVideos:(UIButton*)btn
{
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld", (long)iTag);
    
//    NSLog(@"VideoUrl=%@",[NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryVideos objectAtIndex:iTag]]);
//    
//    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://websitetestingbox.com/php/treding_coach/coachPhoto/%@/%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[aryVideos objectAtIndex:iTag]]];
//    
//    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//    playerViewController.player = player;
//    //[playerViewController.player play];//Used to Play On start
//    [self presentViewController:playerViewController animated:YES completion:nil];

    
    
}


//
//-(void) loadView
//{
//    _IBNSLayountHeightPhoto.constant = 60*15;
//    _IBNSLayountHeightContentVew.constant = 60*15;
//    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    flowLayout.itemSize = CGSizeMake(100, 100);
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    _collectionView = [[UICollectionView alloc] initWithFrame:_IBViewPhotos.frame collectionViewLayout:flowLayout];
//    [_collectionView setDataSource:self];
//    [_collectionView setDelegate:self];
//    
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//    [_collectionView setBackgroundColor:[UIColor redColor]];
//    
//    [_IBViewPhotos addSubview:_collectionView];
//    
//    
//    
//    
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 15;
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
//    
//    cell.backgroundColor=[UIColor greenColor];
//    
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(50, 50);
//}







 /////////  MARK : -  Camera and gallery Methods      ////////



- (IBAction)IBButtonClickPhotos:(id)sender
{
    imageTag = 1;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self CameraOpen];
                    break;
                case 1:
                    [self GalleryOpen];
                    break;
                default:
                    break;
            }
            break;
        }
        case 2: {
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

        default:
            break;
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
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
   

}

-(void) GalleryOpen
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
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
    [cameraUI setVideoMaximumDuration:180.0f];
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

-(void) VideoGalleryOpen
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    SaveChangeTag = YES;
    
    if (imageTag == 0)
    {
        self.IBImageProfile.image = chosenImage;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        strImagePathProfile = [documentsDirectory stringByAppendingPathComponent:@"latest_photo.png"];
//        NSLog(@"strImagePathProfile=%@",strImagePathProfile);
    }
    else if (imageTag == 1)
    {
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared UploadCoachMediaFile:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] name:@"" video:@"" image:chosenImage];

    }
    else
    {
         NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            NSLog(@"moviePath=%@",moviePath);
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared UploadCoachMediaFile:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] name:@"" video:moviePath image:nil];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
        [self GetCoachData];
        
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }


    
}


- (IBAction)IBButtonClickVideos:(id)sender
{
    imageTag = 3;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            nil];
    popup.tag = 2;
    [popup showInView:self.view];

}

- (IBAction)IBButtonClickCalendar:(id)sender
{
//    CalenderView *detailViewController = [[CalenderView alloc] initWithNibName:@"CalenderView" bundle:nil];
//    detailViewController.delegate = self;
//    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationFade];


    _IBViewMainCalender.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    [self.view addSubview:_IBViewMainCalender];
}

- (IBAction)IBButtonClickPlayerVideo:(id)sender
{
  
    [timer invalidate];
    timer = nil;
    
    CoachVideoListPage *cp = [[CoachVideoListPage alloc]initWithNibName:@"CoachVideoListPage" bundle:nil ];
    [self.navigationController pushViewController:cp animated:YES];
}




 /////////  MARK : -  Save Information      ////////


//- (IBAction)IBButtonClickEdit:(id)sender
//{
////    MainViewController *mv = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil ];
////    [self.navigationController pushViewController:mv animated:YES];
//    
//    NSLog(@"appDelegate.aryCalendarDate=%@",appDelegate.aryCalendarDate);
//    
//    NSString *strCalenderDates= [[NSString alloc]init ];
//    if (appDelegate.aryCalendarDate.count != 0)
//    {
//        
//        for (int i = 0 ; i<appDelegate.aryCalendarDate.count ; i++)
//        {
//            strCalenderDates =[strCalenderDates stringByAppendingString:[appDelegate.aryCalendarDate objectAtIndex:i]];
//            strCalenderDates =[strCalenderDates stringByAppendingString:@","];
//        }
//        
//        strCalenderDates = [strCalenderDates substringToIndex:[strCalenderDates length] - 1];
//
//        NSLog(@"strCalenderDates=%@",strCalenderDates);
//
//    }
//    
//    NSString *strCalenderStatus= [[NSString alloc]init ];
//    
//    if (appDelegate.aryCalendarStatus.count != 0)
//    {
//       
//        for (int i = 0 ; i<appDelegate.aryCalendarStatus.count ; i++)
//        {
//            strCalenderStatus =[strCalenderStatus stringByAppendingString:[appDelegate.aryCalendarStatus objectAtIndex:i]];
//            strCalenderStatus =[strCalenderStatus stringByAppendingString:@","];
//        }
//        
//        strCalenderStatus = [strCalenderStatus substringToIndex:[strCalenderStatus length] - 1];
//        
//        NSLog(@"strCalenderStatus=%@",strCalenderStatus);
//        
//    }
//    NSString *strCalenderPlayerIDs= [[NSString alloc]init ];
//    
//    if (appDelegate.aryPlayerIDs.count != 0)
//    {
//        
//        for (int i = 0 ; i<appDelegate.aryPlayerIDs.count ; i++)
//        {
//            strCalenderPlayerIDs =[strCalenderPlayerIDs stringByAppendingString:[appDelegate.aryPlayerIDs objectAtIndex:i]];
//            strCalenderPlayerIDs =[strCalenderPlayerIDs stringByAppendingString:@","];
//        }
//        
//        strCalenderPlayerIDs = [strCalenderPlayerIDs substringToIndex:[strCalenderPlayerIDs length] - 1];
//        
//        NSLog(@"strCalenderPlayerIDs=%@",strCalenderPlayerIDs);
//        
//    }
//    
//    
//    
//    if (arySportsType.count>0)
//    {
//        strSportType= [[NSString alloc]init ];
//        for (int i=0; i<arySportsType.count; i++)
//        {
//            
//            strSportType = [strSportType stringByAppendingString:[NSString stringWithFormat:@"%@",[arySportsType objectAtIndex:i]]];
//            strSportType = [strSportType stringByAppendingString:@","];
//        }
//        
//        strSportType = [strSportType substringToIndex:[strSportType length] - 1];
//        NSLog(@"strSportType=%@",strSportType);
//        
//    }
//    
//    
//    if (_IBTextFieldRate.text.length ==0 )
//    {
//        [appDelegate showAlertMessage:@"Please enter Rate"];
//    }
//    else if (_IBTextFieldSelectGraduate.text.length ==0 )
//    {
//        [appDelegate showAlertMessage:@"Please select Garduated Form"];
//    }
//    else if (strSportType.length ==0 )
//    {
//        [appDelegate showAlertMessage:@"Please select Sports Type"];
//    }
//    else
//    {
//        SharedClass *shared =[SharedClass sharedInstance];
//        shared.delegate =self;
//        [shared coachEdit:_IBTextFieldName.text email:_IBTextFieldEmail.text coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] location:_IBTextFieldSelectCountry.text rate:_IBTextFieldRate.text usertype:@"" sporttype:strSportType rating:strRating college:_IBTextFieldSelectGraduate.text profileImage:self.IBImageProfile.image dates:strCalenderDates status:strCalenderStatus certificate:_IBTextFieldCertificate.text strplayerids:strCalenderPlayerIDs];
//    }
//}

-(void)getUserDetails:(NSDictionary *)dicVideoDetials
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
        [[NSUserDefaults standardUserDefaults] setObject:@"Coach" forKey:@"SignUp"];
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


 /////////  MARK : -  Profile photo      ////////

- (IBAction)IBButtonClickProfile:(id)sender
{
    imageTag = 0;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];

}



 /////////  MARK : -  Sport Types selection      ////////

//- (IBAction)IBButtonClickAllTypes:(id)sender
//{
//    switch ([sender tag]) {
//        case 0:
//            if([_IBButtonTennis isSelected]==YES)
//            {
//                [arySportsType removeObject:@"TENNIS"];
//                [_IBButtonTennis setSelected:NO];
//                [_IBButtonTennis setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"TENNIS"];
//                [_IBButtonTennis setSelected:YES];
//                [_IBButtonTennis setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//        case 1:
//            if([_IBButtonGolf isSelected]==YES)
//            {
//                [arySportsType removeObject:@"GOLF"];
//                [_IBButtonGolf setSelected:NO];
//                [_IBButtonGolf setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"GOLF"];
//                [_IBButtonGolf setSelected:YES];
//                [_IBButtonGolf setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//        case 2:
//            if([_IBButtonBasball isSelected]==YES)
//            {
//                [arySportsType removeObject:@"BASEBALL"];
//                [_IBButtonBasball setSelected:NO];
//                [_IBButtonBasball setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"BASEBALL"];
//                [_IBButtonBasball setSelected:YES];
//                [_IBButtonBasball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//        case 3:
//            if([_IBButtonSoftball isSelected]==YES)
//            {
//                [arySportsType removeObject:@"SOFTBALL"];
//                [_IBButtonSoftball setSelected:NO];
//                [_IBButtonSoftball setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"SOFTBALL"];
//                [_IBButtonSoftball setSelected:YES];
//                [_IBButtonSoftball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//        case 4:
//            if([_IBButtonFootball isSelected]==YES)
//            {
//                [arySportsType removeObject:@"(American) FOOTBALL"];
//                [_IBButtonFootball setSelected:NO];
//                [_IBButtonFootball setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"(American) FOOTBALL"];
//                [_IBButtonFootball setSelected:YES];
//                [_IBButtonFootball setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//        case 5:
//            if([_IBButtonSoccer isSelected]==YES)
//            {
//                [arySportsType removeObject:@"(Football) SOCCER"];
//                [_IBButtonSoccer setSelected:NO];
//                [_IBButtonSoccer setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"(Football) SOCCER"];
//                [_IBButtonSoccer setSelected:YES];
//                [_IBButtonSoccer setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//            
//        case 6:
//            if([_IBButtonPerTrainer isSelected]==YES)
//            {
//                [arySportsType removeObject:@"PERSONAL TRAINER"];
//                [_IBButtonPerTrainer setSelected:NO];
//                [_IBButtonPerTrainer setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"PERSONAL TRAINER"];
//                [_IBButtonPerTrainer setSelected:YES];
//                [_IBButtonPerTrainer setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//            
//        case 7:
//            if([_IBButtonFitness isSelected]==YES)
//            {
//                [arySportsType removeObject:@"FITNESS"];
//                [_IBButtonFitness setSelected:NO];
//                [_IBButtonFitness setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"FITNESS"];
//                [_IBButtonFitness setSelected:YES];
//                [_IBButtonFitness setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//        case 8:
//            if([_IBButtonSportP isSelected]==YES)
//            {
//                [arySportsType removeObject:@"SPORT PSYCHOLOGY"];
//                [_IBButtonSportP setSelected:NO];
//                [_IBButtonSportP setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"SPORT PSYCHOLOGY"];
//                [_IBButtonSportP setSelected:YES];
//                [_IBButtonSportP setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//        case 9:
//            if([_IBButtonOther isSelected]==YES)
//            {
//                [arySportsType removeObject:@"OTHER"];
//                [_IBButtonOther setSelected:NO];
//                [_IBButtonOther setImage:[UIImage imageNamed:@"select-inactive"] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                [arySportsType addObject:@"OTHER"];
//                [_IBButtonOther setSelected:YES];
//                [_IBButtonOther setImage:[UIImage imageNamed:@"select_active"] forState:UIControlStateSelected];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            NSLog(@"appDelegate.aryCalendarDate=%@",appDelegate.aryCalendarDate);
            
            NSString *strCalenderDates= [[NSString alloc]init ];
            if (appDelegate.aryCalendarDate.count != 0)
            {
                
                for (int i = 0 ; i<appDelegate.aryCalendarDate.count ; i++)
                {
                    strCalenderDates =[strCalenderDates stringByAppendingString:[appDelegate.aryCalendarDate objectAtIndex:i]];
                    strCalenderDates =[strCalenderDates stringByAppendingString:@","];
                }
                
                strCalenderDates = [strCalenderDates substringToIndex:[strCalenderDates length] - 1];
                
                NSLog(@"strCalenderDates=%@",strCalenderDates);
                
            }
            
            NSString *strCalenderStatus= [[NSString alloc]init ];
            
            if (appDelegate.aryCalendarStatus.count != 0)
            {
                
                for (int i = 0 ; i<appDelegate.aryCalendarStatus.count ; i++)
                {
                    strCalenderStatus =[strCalenderStatus stringByAppendingString:[appDelegate.aryCalendarStatus objectAtIndex:i]];
                    strCalenderStatus =[strCalenderStatus stringByAppendingString:@","];
                }
                
                strCalenderStatus = [strCalenderStatus substringToIndex:[strCalenderStatus length] - 1];
                
                NSLog(@"strCalenderStatus=%@",strCalenderStatus);
                
            }
            
             NSString *strCalenderPlayerIDs= [[NSString alloc]init ];
            
            if (appDelegate.aryPlayerIDs.count != 0)
            {
                
                for (int i = 0 ; i<appDelegate.aryPlayerIDs.count ; i++)
                {
                    strCalenderPlayerIDs =[strCalenderPlayerIDs stringByAppendingString:[appDelegate.aryPlayerIDs objectAtIndex:i]];
                    strCalenderPlayerIDs =[strCalenderPlayerIDs stringByAppendingString:@","];
                }
                
                strCalenderPlayerIDs = [strCalenderPlayerIDs substringToIndex:[strCalenderPlayerIDs length] - 1];
                
                NSLog(@"strCalenderPlayerIDs=%@",strCalenderPlayerIDs);
                
            }
            
            
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
            
            
//            SharedClass *shared =[SharedClass sharedInstance];
//            shared.delegate =self;
//            [shared coachEdit:_IBTextFieldName.text email:_IBTextFieldEmail.text coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] location:_IBTextFieldSelectCountry.text rate:_IBTextFieldRate.text usertype:@"" sporttype:strSportType rating:strRating college:_IBLabelEducation.text profileImage:self.IBImageProfile.image dates:strCalenderDates status:strCalenderStatus certificate:_IBTextFieldCertificate.text strplayerids:strCalenderPlayerIDs];
            

        }
        else
        {
            [timer invalidate];
            timer = nil;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
        }
        
    }
    // NSLog(@"ava=%@",Aryavailability);
}

- (IBAction)IBButtonClickBack:(id)sender
{
//    if (appDelegate.strNotiDate.length == 0)
//    {

        if (SaveChangeTag == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to save this changes?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 1;
            [alert show];

        }
        else
        {
            
            [timer invalidate];
            timer = nil;

            _IBImagebg.hidden = YES;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];

        }

//    }
//    else
//    {
//        MainViewController *mv =[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
//        
//    }
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
    [timer invalidate];
    timer = nil;

    CalendarViewController *cv = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    [self.navigationController pushViewController:cv animated:YES];

}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date
{
    
//    BOOL shouldDedeselect = [_IBViewCalendar dayOfDate:date] != 7;
//    if (!shouldDedeselect) {
//        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be deselected",[calendar stringFromDate:date]] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return NO;
//    }
    return YES;

   // return NO;
    
}

//
//if(result==NSOrderedAscending)
//NSLog(@"today is less");
//else if(result==NSOrderedDescending)
//NSLog(@"newDate is less");
//else
//NSLog(@"Both dates are same");

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
    
    SaveChangeTag = YES;
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

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date
//{
//    //    if ([_calendar dayOfDate:date] % 2 == 0) {
//    //        return appearance.selectionColor;
//    //    }
//    
//    NSDate *today = [NSDate date];
//    NSComparisonResult result = [today compare:date];
//    
//    if(result==NSOrderedDescending)
//    {
//        return [UIColor clearColor];
//    }
//    else
//    {
//        return [UIColor clearColor];
//    }
//}
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date
//{
//    //    if ([_calendar dayOfDate:date] % 2 == 0) {
//    //        return appearance.selectionColor;
//    //    }
//    NSDate *today = [NSDate date];
//    NSComparisonResult result = [today compare:date];
//    
//    if(result==NSOrderedDescending)
//    {
//        return [UIColor blackColor];
//    }
//    else
//    {
//        return [UIColor blackColor];
//    }
//}

- (IBAction)IBButtonClickCancel:(id)sender
{
    [_IBViewMainCalender removeFromSuperview];
}

- (IBAction)IBButtonClickOk:(id)sender
{
    [_IBViewMainCalender removeFromSuperview];
}



/////////////////////////  ALARM ////////////////////////////

-(void)setAlarm
{
    for (int i =0 ; i< appDelegate.aryCalendarDate.count; i++)
    {
        if ([[appDelegate.aryCalendarStatus objectAtIndex:i] isEqualToString:@"occupied"])
        {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* currentdate = [NSDate date];
            
            
            NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
            [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            
            NSString *strnow =[dateFormatter stringFromDate:currentdate];
            
            NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
            NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[appDelegate.aryCalendarDate objectAtIndex:i]]];
            //
            //            NSLog(@"now=%@",now);
            //            NSLog(@"end=%@",end);
            //
            
            NSComparisonResult result;
            
            result = [now compare:end]; // comparing two dates
            
            if(result==NSOrderedAscending)
            {
                NSLog(@"today is less");
                [self SetAlarm:[appDelegate.aryCalendarDate objectAtIndex:i]];
            }
            if(result==NSOrderedDescending)
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
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForCoach"];
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
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForCoach"];
    
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
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForCoach"];
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
    NSData *alarmListData = [defaults objectForKey:@"AlarmListDataForCoach"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    
    
    if (alarmList.count != 0)
    {
        for (int i=0; i<[alarmList count]; i++)
        {
            [alarmList removeObjectAtIndex: i];
        }
        
    }
    
    
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForCoach"];
    
  
}



///////


-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dtFormat stringFromDate:aDate];
}
////

@end
