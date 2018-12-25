//
//  ViewController.h
//  CelendarDaily
//
//  Created by Nisarg on 26/02/16.
//  Copyright © 2016 Techtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface CalendarViewController : UIViewController <UIAlertViewDelegate>
{
    NSDate *SelectedDate;
    NSArray *timeary;
    NSInteger Selectedindex;
   
    NSString *strSelectedDate;
    NSMutableArray *aryGetPlayerID;
    NSString *strRepeat,*strApprove;
    
    NSMutableArray *Aryavailability,*aryCoachName;
    
}


@property (weak, nonatomic) IBOutlet UILabel *IBLabelDate;
@property (weak, nonatomic) IBOutlet UITableView *IBTbleView;


- (IBAction)IBButtonClickNext:(id)sender;
- (IBAction)IBButtonClickPrev:(id)sender;
- (IBAction)IBButtonClickDone:(id)sender;
- (IBAction)IBButtonClickBack:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *IBViewPopUp;

@property (weak, nonatomic) IBOutlet UIView *IBViewPopupWeek;
@property (weak, nonatomic) IBOutlet UIView *IBViewPopupSelection;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextStartTime;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextEndTime;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonRepeat;


@end

