//
//  PendingAppoinmentVC.m
//  My Trending Coach
//
//  Created by Nisarg on 17/03/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "PendingAppoinmentVC.h"
#import "PendingAppoinmentCell.h"
#import "VideoChatViewController.h"
#import "UIAlertController+Utilities.h"

@interface PendingAppoinmentVC () <SharedClassDelegate>
{
    NSMutableArray *aryAllDetails;
    NSDate *newDate;
    NSString *strName;
    NSInteger selectionIndex;
}
@property(retain, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PendingAppoinmentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"eventArray=%@",eventArray);
    
    if (eventArray.count != 0)
    {
        [self CancelExistingNotification];
    }
    
    [self reloadData];
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
//    if #available(iOS 10.0, *) {
//        _IBtbleView.refreshControl = refreshControl
//    } else {
    
    _IBtbleView.backgroundView = self.refreshControl;
    
//    }
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)reloadData{
    // Reload table data
     [self.refreshControl endRefreshing];
        [self getContent];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) viewWillAppear:(BOOL)animated{
    if (appDelegate.isEndLiveStream)
        [self.navigationController popViewControllerAnimated:NO];
}

- (void)getContent{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] isEqualToString:@"Player"]) {
        [self getConentForPlayer];
    }else{
        [self getConentForCouch];
    }
}

- (void)getConentForPlayer{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared RequestAppointmentListForPlayer:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get_request_for_player"];
}

- (void)getConentForCouch{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate = self;
    [shared RequestAppointmentList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get_request_for_coach"];
}


-(void)getUserDetails4:(NSDictionary *)dicVideoDetials{
    NSLog(@"dicVideoDetials = %@", dicVideoDetials);
    
    NSDictionary* result = [dicVideoDetials objectForKey:@"result"];
    if (result) {
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        NSString* actionTitle = code == 0 ? @"Cancel" : @"OK";
        NSString* message = [result objectForKey:@"message"];
        [UIAlertController showOnTarget:self title:@"MTC" message:message cancelTitle:actionTitle okTitle:nil actionHandler:nil];
    }
}

-(void)getUserDetails:(NSDictionary *)dicVideoDetials{
    NSLog(@"dicVideoDetials = %@", dicVideoDetials);
    
    aryAllDetails = [[dicVideoDetials valueForKey:@"result"] valueForKey:@"video_list"];
    [_IBtbleView reloadData];
    
}

- (void)getUserDetails5:(NSDictionary *)dicVideoDetials{
    //player list
    NSLog(@"%@", dicVideoDetials);
    aryAllDetails = [[dicVideoDetials valueForKey:@"result"] valueForKey:@"request"];
    [_IBtbleView reloadData];
}

- (void)getUserDetails7:(NSDictionary *)dicVideoDetials{
    //couch info
    
    aryAllDetails = [[[dicVideoDetials valueForKey:@"result"] valueForKey:@"request"] firstObject];
    [_IBtbleView reloadData];
}

- (void)getUserDetails8:(NSDictionary *)dicVideoDetials{
    //delete request
    [self getContent];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return aryAllDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PendingAppoinmentCell";
    PendingAppoinmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If there is no cell to reuse, create a new one
    if(cell == nil)
    {
        cell = [[PendingAppoinmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSDictionary *value = [aryAllDetails objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatHours = [[NSDateFormatter alloc] init];
    [dateFormatHours setDateFormat:@"HH:mm"];
    
    NSDateFormatter *createFormat = [[NSDateFormatter alloc] init];
    [createFormat setDateFormat:@"EEEE, MMMM d, yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        cell.IBLabelTitle.text = [value valueForKey:@"coach_name"];
        
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[value valueForKey:@"coach_avatar"]]
                    placeholderImage:[UIImage imageNamed:@"avatarDefault"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if(image){
                                   [cell.avatar setImage:image];
                               }
                           }];
        
        NSDate *startDateTime = [dateFormat dateFromString:[value valueForKey:@"start_date_time"]];
        NSDate *endDateTime = [dateFormat dateFromString:[value valueForKey:@"end_date_time"]];
        
        NSDate *createDateTime = [dateFormat dateFromString:[value valueForKey:@"start_date_time"]];
        
        cell.IBLabelDate.text = [createFormat stringFromDate:createDateTime];
        cell.IBLabelTime.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatHours stringFromDate:startDateTime], [dateFormatHours stringFromDate:endDateTime]];
        
        [cell.IBLabelType setTitle:[value valueForKey:@"coach_type"] forState:UIControlStateNormal];
        [cell.IBLabelType setHidden:NO];
    }
    else
    {
        cell.IBLabelTitle.text = [value valueForKey:@"player_name"];
        
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[value valueForKey:@"player_avatar"]]
                    placeholderImage:[UIImage imageNamed:@"avatarDefault"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if(image){
                                   [cell.avatar setImage:image];
                               }
                           }];
        
        NSDate *startDateTime = [dateFormat dateFromString:[value valueForKey:@"start_date_time"]];
        NSDate *endDateTime = [dateFormat dateFromString:[value valueForKey:@"end_date_time"]];
        NSDate *createDateTime = [dateFormat dateFromString:[value valueForKey:@"start_date_time"]];
        
        cell.IBLabelDate.text = [createFormat stringFromDate:createDateTime];
        cell.IBLabelTime.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatHours stringFromDate:startDateTime], [dateFormatHours stringFromDate:endDateTime]];
        
        [cell.IBLabelType setHidden:YES];
        
    }
    
    cell.didDelete = ^{
        [self DeleteClick:[value valueForKey:@"id"]];
    };
    
    cell.didStartSession = ^{
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
//        [shared TalkBox:[value valueForKey:@"id"] userid:[[NSUserDefaults standardUserDefaults] stringForKey:@"id"] usertype: [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
        
        if (![shared currentUserTypePlayer]) {
            [shared RequestApproveFromCoach:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] playerid:[value valueForKey:@"user_id"] passing_value:@"confirm_request" start_date_time:[value valueForKey:@"start_date_time"] endDateTime:[value valueForKey:@"end_date_time"] request_id:[value valueForKey:@"id"]];
        }
        [self OpenLiveScreeen];
    };
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)StartSessionClick:(UIButton *) sender
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"To enhance your My Trending Coach experience"
                                              message:@"\n-Good Wifi/data\n-Phone/tablet tripod\n-Public/Private facility designated to your MTC\n-Correct equipment to perform your MTC Live stream\n"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       selectionIndex = sender.tag;
                                       [self performSelector:@selector(OpenLiveScreeen) withObject:nil afterDelay:0.5];
                                   }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else
    {
        selectionIndex = sender.tag;
        [self performSelector:@selector(OpenLiveScreeen) withObject:nil afterDelay:0.5];

    }
  
    
   }

-(void)OpenLiveScreeen
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        appDelegate.strCoachId = [NSString stringWithFormat:@"%@",[[aryAllDetails objectAtIndex:selectionIndex]valueForKey:@"coach_id"]];
    }
    
    VideoChatViewController *uvp = [[VideoChatViewController alloc]initWithNibName:@"VideoChatViewController" bundle:nil ];
    uvp.strAppointmentID = [NSString stringWithFormat:@"%@",[[aryAllDetails objectAtIndex:selectionIndex]valueForKey:@"id"]];
    [self presentViewController:uvp animated:NO completion:nil];

}


- (void)DeleteClick:(NSString*) sender
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
                             if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
                             {
                                 //delete_pending_appointment
                                 [shared DeleteRequestAppointmentFromList:sender passing_value:@"delete_coach" user_type:@"player"];
                             }
                             else
                             {
                                 //delete_pending_appointment
                                 [shared DeleteRequestAppointmentFromList:sender passing_value:@"delete_coach" user_type:@"coach"];
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


/////////////////////////  ALARM ////////////////////////////

-(void)setAlarm
{
    for (int i =0 ; i< aryAllDetails.count; i++)
    {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* currentdate = [NSDate date];
            
            
            NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
            [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            
            NSString *strnow =[dateFormatter stringFromDate:currentdate];
            
            NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
            NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]]];
        
      
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
            {
                strName = [NSString stringWithFormat:@"%@",[[aryAllDetails objectAtIndex:i]valueForKey:@"coach_name"]];
            }
            else
            {
                strName = [NSString stringWithFormat:@"%@",[[aryAllDetails objectAtIndex:i]valueForKey:@"player_name"]];
            }
        
            NSComparisonResult result;
            
            result = [now compare:end]; // comparing two dates
            
            if(result==NSOrderedAscending)
            {
                NSLog(@"today is less");
                [self SetAlarm:[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]];
            }
            if(result==NSOrderedDescending)
                NSLog(@"newDate is less");
            else
                NSLog(@"Both dates are same");

    }
    
    [self performSelector:@selector(setAlarm2) withObject:nil afterDelay:3];
    [self performSelector:@selector(setAlarm3) withObject:nil afterDelay:6];
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
    [dateComponents setMinute:-60];
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
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForPlayer"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForCoach"];
    }
    
    
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
    NSLog(@"strName==%@",strName);
    NSString *Str = [NSString stringWithFormat:@"Live session will be starting in next 30 minutes with %@",strName];
    
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


////////////

///////////////////////// Second ALARM ////////////////////////////

-(void)setAlarm2
{
    for (int i =0 ; i< aryAllDetails.count; i++)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* currentdate = [NSDate date];
        
        
        NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
        [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSString *strnow =[dateFormatter stringFromDate:currentdate];
        
        NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
        NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]]];
        
        NSComparisonResult result;
        
        result = [now compare:end]; // comparing two dates
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
            [self SetAlarm2:[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]];
        }
        if(result==NSOrderedDescending)
            NSLog(@"newDate is less");
        else
            NSLog(@"Both dates are same");
        
    }
}

-(void)SetAlarm2 : (NSString *)Date
{
    NSLog(@"Date==%@",Date);
    
    NSString *strfinal = [NSString stringWithFormat:@"%@ +0000",Date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *oldDate = [dateFormatter dateFromString:strfinal];
    NSLog(@"oldDate%@",oldDate);
    
    
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setHour:-5];
    [dateComponents setMinute:-45];
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
    
    
    
    [self scheduleLocalNotificationWithDate2:newAlarmObject.timeToSetOff atIndex:newAlarmObject.notificationID date:Date];
    
    [alarmList addObject:newAlarmObject];
    
    
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForPlayer"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForCoach"];
    }
    
    
}


- (void)scheduleLocalNotificationWithDate2:(NSDate *)fireDate
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
    
    NSString *Str = [NSString stringWithFormat:@"Live session will be starting in next 15 minutes with %@",strName];
    
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



///////////////////////// Third ALARM ////////////////////////////

-(void)setAlarm3
{
    for (int i =0 ; i< aryAllDetails.count; i++)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* currentdate = [NSDate date];
        
        
        NSDateFormatter *dateFormatternew = [[NSDateFormatter alloc] init];
        [dateFormatternew setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        
        NSString *strnow =[dateFormatter stringFromDate:currentdate];
        
        NSDate *now= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",strnow]];
        NSDate *end= [dateFormatternew dateFromString:[NSString stringWithFormat:@"%@ +0000",[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]]];
        
        NSComparisonResult result;
        
        result = [now compare:end]; // comparing two dates
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
            [self SetAlarm3:[[aryAllDetails objectAtIndex:i]valueForKey:@"start_date_time"]];
        }
        if(result==NSOrderedDescending)
            NSLog(@"newDate is less");
        else
            NSLog(@"Both dates are same");
        
    }
}

-(void)SetAlarm3 : (NSString *)Date
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
    
    
    
    [self scheduleLocalNotificationWithDate3:newAlarmObject.timeToSetOff atIndex:newAlarmObject.notificationID date:Date];
    
    [alarmList addObject:newAlarmObject];
    
    
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForPlayer"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListDataForCoach"];
    }
    
}


- (void)scheduleLocalNotificationWithDate3:(NSDate *)fireDate
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
    
    NSString *Str = [NSString stringWithFormat:@"Live session will be starting in next 5 minutes with %@",strName];
    
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

-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dtFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dtFormat stringFromDate:aDate];
}

- (IBAction)onBack:(id)sender{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];}

@end
