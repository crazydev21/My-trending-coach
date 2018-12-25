//
//  CalendarCell.h
//  CelendarDaily
//
//  Created by Nisarg on 26/02/16.
//  Copyright © 2016 Techtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *IBViewColor;
@property (weak, nonatomic) IBOutlet UIView *IBViewColor1;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelOccupy;


@property (weak, nonatomic) IBOutlet UILabel *IBLabelHour;

@property (weak, nonatomic) IBOutlet UIButton *IBButonColor;
@end
