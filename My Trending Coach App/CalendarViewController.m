//
//  ViewController.m
//  CelendarDaily
//
//  Created by Nisarg on 26/02/16.
//  Copyright © 2016 Techtic. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "MainViewController.h"


@interface CalendarViewController () <SharedClassDelegate>

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
   // timeary = [[NSArray alloc]initWithObjects:@"00:00", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00",
   //            @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", @"00:00", nil ];
    
    timeary = [[NSArray alloc]initWithObjects:@"00:00", @"00:30", @"01:00",@"01:30", @"02:00", @"02:30", @"03:00", @"03:30", @"04:00", @"04:30", @"05:00", @"05:30", @"06:00", @"06:30",
                @"07:00", @"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30",  @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30", @"23:00", @"23:30",  nil];

    [_IBTextStartTime setItemList:[NSArray arrayWithObjects:@"00:00", @"00:30", @"01:00",@"01:30", @"02:00", @"02:30", @"03:00", @"03:30", @"04:00", @"04:30", @"05:00", @"05:30", @"06:00", @"06:30",@"07:00", @"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30",  @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30", @"23:00", @"23:30", nil]];
    
    
     [_IBTextEndTime setItemList:[NSArray arrayWithObjects:@"00:00", @"00:30", @"01:00",@"01:30", @"02:00", @"02:30", @"03:00", @"03:30", @"04:00", @"04:30", @"05:00", @"05:30", @"06:00", @"06:30",@"07:00", @"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30",  @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30", @"23:00", @"23:30", nil ]];
    
    aryCoachName  = [[NSMutableArray alloc] init];
    for (int i = 0; i<timeary.count; i++)
    {
        [Aryavailability addObject:@""];
        [aryCoachName addObject:@""];
        
    }
    
    strRepeat = @"1";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now= [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",appDelegate.strCalendarDate]];
    NSLog(@"now=%@",now);
  
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"EEEE - MMMM dd, yyyy";
    _IBLabelDate.text =  [dateFormatter1 stringFromDate:now];



    [_IBTbleView registerNib:[UINib nibWithNibName:@"CalendarCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [_IBTbleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    

    [self LoadData];

    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)LoadData
{
    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        [shared GetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get" date:appDelegate.strCalendarDate];
    }
    else
    {
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        [shared GetAvaibility:appDelegate.strCoachtoPlayerId passing_value:@"get" date:appDelegate.strCalendarDate];
    }
}

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    NSMutableArray *availability = [[NSMutableArray alloc] init];
    availability = [result valueForKey:@"availability"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        Aryavailability = [[NSMutableArray alloc] init];
        aryCoachName  = [[NSMutableArray alloc] init];
        for (int i = 0; i<timeary.count; i++)
        {
            [Aryavailability addObject:@""];
            [aryCoachName addObject:@""];
            
        }
        
        for (int i = 0; i<timeary.count; i++)
        {
            for (int j = 0; j<availability.count; j++)
            {
               // NSLog(@"start_time==%@",[[availability valueForKey:@"start_time"]objectAtIndex:j]);
                if ([[timeary objectAtIndex:i] isEqualToString:[[availability valueForKey:@"start_time"]objectAtIndex:j]])
                {
                    [Aryavailability replaceObjectAtIndex:i withObject:@"1"];
                    NSLog(@"coach===%@",[[availability valueForKey:@"coach_name"]objectAtIndex:j]);
                    if (![[[availability valueForKey:@"coach_name"]objectAtIndex:j] isEqualToString:@""])
                    {
                        [aryCoachName replaceObjectAtIndex:i withObject:[[availability valueForKey:@"coach_name"]objectAtIndex:j]];
                        
                    }

         
                }
               
            }
        }
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    NSLog(@"Aryavailability=%@",Aryavailability);
    NSLog(@"aryCoachName=%@",aryCoachName);
    [_IBTbleView reloadData];
    
}

//-(void) getDetail
//{
//    Aryavailability = [[NSMutableArray alloc]init ];
//    
//    for (int i = 0; i<timeary.count; i++)
//    {
//        [Aryavailability addObject:@""];
//    }
//    
//    for (int i = 0; i<dateary.count; i++)
//    {
//        NSString *datestr = [NSString stringWithFormat:@"%@",[dateary objectAtIndex:i]];
//        
//        if (![datestr isEqualToString:@""])
//        {
//            datestr=[datestr substringToIndex:10];
//            NSLog(@"datestr=%@    %@",datestr,_IBLabelDate.text);
//            
//            
//            if ([datestr rangeOfString:_IBLabelDate.text].location != NSNotFound)
//            {
//                
//                NSString *time = [NSString stringWithFormat:@"%@",[dateary objectAtIndex:i]];
//                time = [time substringWithRange:NSMakeRange(11, 5)];
//               // time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
//                NSLog(@"time=%@",time);
//                
//                NSString *statusstr = [NSString stringWithFormat:@"%@",[statusary objectAtIndex:i]];
//                NSString *pleyerid;
//                
//                @try
//                {
//                    pleyerid = [NSString stringWithFormat:@"%@",[playeridary objectAtIndex:i]];
//                }
//                @catch (NSException *exception)
//                {
//                    pleyerid = @"";
//                }
//                
//                @try
//                {
//                    NSString *firstCapChar = [[statusstr substringToIndex:1] capitalizedString];
//                    statusstr = [statusstr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
//                }
//                @catch (NSException *exception)
//                {
//                    statusstr = @"";
//                }
//               
//                for (int i = 0; i<timeary.count; i++)
//                {
//                    if ([[timeary objectAtIndex:i] isEqualToString:time])
//                    {
//                         NSLog(@"i=%d",i);
//                        [Aryavailability replaceObjectAtIndex:i withObject:statusstr];
//                        NSLog(@"Aryavailability=%@",Aryavailability);
//                        
//                        [aryGetPlayerID replaceObjectAtIndex:i withObject:pleyerid];
//                    }
//                    
//                }
//            }
//        }
//     }
//    
//     [_IBTbleView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////  MARK : -  TableView Methods      ////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return timeary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If there is no cell to reuse, create a new one
    if(cell == nil)
    {
        cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.IBLabelHour.text = [NSString stringWithFormat:@"%@",[timeary objectAtIndex:indexPath.row]];
    cell.IBLabelOccupy.text = [[NSString stringWithFormat:@"%@",[aryCoachName objectAtIndex:indexPath.row]]uppercaseString];
   
    if (![[aryCoachName objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        cell.IBViewColor.backgroundColor = [UIColor colorWithRed:242/255.0 green:97/255.0 blue:34/255.0 alpha:1.0];
    }
    else if ([[Aryavailability objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        cell.IBViewColor.backgroundColor = [UIColor colorWithRed:254/255.0 green:220/255.0 blue:197/255.0 alpha:1.0];
    }
    else
    {
        cell.IBViewColor.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row != 0)
    {
        if (![[aryCoachName objectAtIndex:indexPath.row-1] isEqualToString:@""])
        {
            cell.IBViewColor1.backgroundColor = [UIColor colorWithRed:242/255.0 green:97/255.0 blue:34/255.0 alpha:1.0];
        }
        else if ([[Aryavailability objectAtIndex:indexPath.row-1] isEqualToString:@"1"])
        {
            cell.IBViewColor1.backgroundColor  = [UIColor colorWithRed:254/255.0 green:220/255.0 blue:197/255.0 alpha:1.0];
        }
        else
        {
            cell.IBViewColor1.backgroundColor = [UIColor clearColor];
        }

    }
    
    if (indexPath.row == 0)
    {
        cell.IBViewColor1.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
 //   cell.backgroundColor = [UIColor clearColor];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row=%ld",(long)indexPath.row);
    Selectedindex = indexPath.row;
    if ([appDelegate.strPlayerCheck isEqualToString:@"Indirect"] && [ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        
//        if ([[Aryavailability objectAtIndex:indexPath.row] rangeOfString:@"1"].location != NSNotFound && [[aryCoachName objectAtIndex:indexPath.row] isEqualToString:@""])
//        {
//            CalendarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            
//            if (indexPath.row == 48)
//            {
//                strSelectedDate = [NSString stringWithFormat:@"\n%@ - %@\non\n%@",_IBLabelDate.text,[timeary objectAtIndex:0],cell.IBLabelHour.text];
//            }
//            else
//            {
//                strSelectedDate = [NSString stringWithFormat:@"\n%@ - %@\non\n%@",cell.IBLabelHour.text,[timeary objectAtIndex:indexPath.row+1],_IBLabelDate.text];
//            }
//            
//            
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WOULD YOU LIKE TO DELETE THIS TIME AVAIBILITY?"
//                                                            message:strSelectedDate delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"CONFIRM" , nil];
//            alert.tag = 3;
//            [alert show];
//        }

    }
    else
    {
        if ([[Aryavailability objectAtIndex:indexPath.row] rangeOfString:@"1"].location != NSNotFound && [[aryCoachName objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            CalendarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (indexPath.row == 48)
            {
                strSelectedDate = [NSString stringWithFormat:@"\n%@ - %@\non\n%@",_IBLabelDate.text,[timeary objectAtIndex:0],cell.IBLabelHour.text];
            }
            else
            {
                strSelectedDate = [NSString stringWithFormat:@"\n%@ - %@\non\n%@",cell.IBLabelHour.text,[timeary objectAtIndex:indexPath.row+1],_IBLabelDate.text];
            }
                
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WOULD YOU LIKE TO CONFIRM THIS APPOINTMENT?"
                                                            message:strSelectedDate delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"CONFIRM" , nil];
            alert.tag = 2;
            [alert show];
        }
        
    }

    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            NSLog(@"timeslot=%@",[timeary objectAtIndex:Selectedindex]);
            NSString *startTime = [NSString stringWithFormat:@"%@ %@:00",appDelegate.strCalendarDate,[timeary objectAtIndex:Selectedindex]];

            NSUInteger indx = Selectedindex == timeary.count-1 ? 0 : Selectedindex;
            NSString *endTime = [NSString stringWithFormat:@"%@ %@:00",appDelegate.strCalendarDate,[timeary objectAtIndex:indx]];
            NSLog(@"str=%@==%@",startTime,appDelegate.strRequestID);
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared RequestApproveFromCoach:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] playerid:appDelegate.strCoachtoPlayerId passing_value:@"confirm_request" start_date_time:startTime endDateTime:endTime request_id:appDelegate.strRequestID];
        }
    }
    else if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            strApprove = @"yes";
            SharedClass *shared = [SharedClass sharedInstance];
            shared.delegate =self;
            [shared SetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"set" date:appDelegate.strCalendarDate start_time:_IBTextStartTime.text end_time:_IBTextEndTime.text repeat:strRepeat approve:strApprove];

        }
    }
    
   // NSLog(@"ava=%@",Aryavailability);
}

-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails  :   %@",dicUserDetials);
    [appDelegate stopLoadingview];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *mv =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    appDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:mv];
    
}

-(void)getUserDetails4:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    NSMutableArray *availability = [[NSMutableArray alloc] init];
    availability = [result valueForKey:@"availability"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.1];
        
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
   

    
    
}

//- (IBAction)IBButtonClickNext:(id)sender
//{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//    
//    NSDate *now = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 18:30:00 +0000",_IBLabelDate.text]];
//    NSLog(@"now=%@",now);
//
//   
//    int daysToAdd = 1;
//    SelectedDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
//    
//    NSString *datestr = [NSString stringWithFormat:@"%@",SelectedDate];
//    datestr=[datestr substringToIndex:10];
//    _IBLabelDate.text = datestr;
//    
//    [self getDetail];
//    
//}
//
//- (IBAction)IBButtonClickPrev:(id)sender
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//    
//    NSDate *now = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 18:30:00 +0000",_IBLabelDate.text]];
//    NSLog(@"now=%@",now);
//
//    int daysToAdd = -1;
//    SelectedDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
//    
//    NSString *datestr = [NSString stringWithFormat:@"%@",SelectedDate];
//    datestr=[datestr substringToIndex:10];
//    _IBLabelDate.text = datestr;
//    
//    [self getDetail];
//    
//}



- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




//////////  MARK :- Timer DropDown Code ////////

- (IBAction)IBButtonClickSetAvailability:(id)sender
{

    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
    {
        _IBViewPopUp.alpha = 1.0;
        _IBViewPopupWeek.alpha = 0.0;
        _IBViewPopupSelection.alpha = 1.0;
    }

}


- (IBAction)IBButtonClickClosePopup:(id)sender
{
    _IBViewPopUp.alpha = 0.0;
    _IBTextStartTime.text = @"";
    _IBTextEndTime.text = @"";
}


- (IBAction)IBButtonClickRepeat:(id)sender
{
    _IBViewPopupWeek.alpha = 1.0;
    _IBViewPopupSelection.alpha = 0.0;
}
- (IBAction)IBButtonClickSave:(id)sender
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    
//    
//    NSString *strStart = [NSString stringWithFormat:@"%@ %@",appDelegate.strCalendarDate,_IBTextStartTime.text];
//    NSString *strEnd = [NSString stringWithFormat:@"%@ %@",appDelegate.strCalendarDate,_IBTextEndTime.text];
//    
//    NSDate *date1= [formatter dateFromString:strStart];
//    NSDate *date2 = [formatter dateFromString:strEnd];
//    
//    NSLog(@"Test===%@===%@====%@====%@",_IBTextStartTime.text,_IBTextEndTime.text,date1,date2);
    
    if (![_IBTextEndTime.text isEqualToString:@"00:00"])
    {
//        if (date1 == nil)
//        {
//            [appDelegate showAlertMessage:@"Please select start time"];
//        }
//        else if (date2 == nil)
//        {
//            [appDelegate showAlertMessage:@"Please select end time"];
//        }
//        if (date1 == nil && _IBTextStartTime.text.length == 0)
//        {
//            [appDelegate showAlertMessage:@"Please select start time"];
//        }
//        else if (date2 == nil && _IBTextStartTime.text.length == 0)
//        {
//            [appDelegate showAlertMessage:@"Please select end time"];
//        }
//        else
//        {
//            NSComparisonResult result = [date1 compare:date2];
//            if(result == NSOrderedDescending)
//            {
//                NSLog(@"date1 is later than date2");
//                [appDelegate showAlertMessage:@"Start time not more then end time"];
//            }
//            else if(result == NSOrderedSame)
//            {
//                [appDelegate showAlertMessage:@"Both time are same"];
//                NSLog(@"date1 is equal to date2");
//            }
//            else
//            {
                SharedClass *shared = [SharedClass sharedInstance];
                shared.delegate =self;
                [shared SetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"set" date:appDelegate.strCalendarDate start_time:_IBTextStartTime.text end_time:_IBTextEndTime.text repeat:strRepeat approve:strApprove];
//            }
//        }

    }
    else
    {
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        [shared SetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"set" date:appDelegate.strCalendarDate start_time:_IBTextStartTime.text end_time:@"23:59" repeat:strRepeat approve:strApprove];

    }

    
    
}

-(void)getUserDetails2:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails2  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        _IBTextStartTime.text = @"";
        _IBTextEndTime.text = @"";
        _IBViewPopUp.alpha = 0.0;
        
        [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.1];
        
    }
    else if (codevalue == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Some time slots are already availables, Are you sure you want to replace this time slots?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No" , nil];
        alert.tag = 5;
        [alert show];

    }
    else
    {
        [appDelegate showAlertMessage:message];
     
    }


    
}

- (IBAction)IBButtonClickNever:(id)sender
{
    strRepeat = @"1";
    [_IBButtonRepeat setTitle:@"Never" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
    
}
- (IBAction)IBButtonClickEDay:(id)sender
{
     strRepeat = @"2";
    [_IBButtonRepeat setTitle:@"Every Day" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
}
- (IBAction)IBButtonClickEWeek:(id)sender
{
     strRepeat = @"3";
    [_IBButtonRepeat setTitle:@"Every Week" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
}
- (IBAction)IBButtonClickE2Week:(id)sender
{
     strRepeat = @"4";
    [_IBButtonRepeat setTitle:@"Every 2 Week" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
}
- (IBAction)IBButtonClickEMonth:(id)sender
{
     strRepeat = @"5";
    [_IBButtonRepeat setTitle:@"Every Month" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
}
- (IBAction)IBButtonClickEYear:(id)sender
{
     strRepeat = @"6";
    [_IBButtonRepeat setTitle:@"Every Year" forState:UIControlStateNormal];
    _IBViewPopupWeek.alpha = 0.0;
    _IBViewPopupSelection.alpha = 1.0;
}




@end
