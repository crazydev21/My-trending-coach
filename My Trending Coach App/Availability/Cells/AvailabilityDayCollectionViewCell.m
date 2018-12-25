//
//  AvailabilityDayCollectionViewCell.m
//  MTC
//
//  Created by Evgen Litvinenko on 30.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "AvailabilityDayCollectionViewCell.h"

@interface AvailabilityDayCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayOfWeekLabel;
@property (nonatomic, weak) IBOutlet UIView *backgroundColorView;

@end

@implementation AvailabilityDayCollectionViewCell

- (void)setDay:(NSString *)day {
    _day = day;
    _dayLabel.text = day;
}

- (void)setDayOfWeek:(NSString *)dayOfWeek {
    _dayOfWeek = dayOfWeek;
    _dayOfWeekLabel.text = dayOfWeek;
}

- (void)setSelectedCell:(BOOL)selectedCell{
    _selectedCell = selectedCell;
    
    if (selectedCell) {
        _dayLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:125.0f/255.0f blue:212.0f/255.0f alpha:1];
        _dayOfWeekLabel.textColor = [UIColor colorWithRed:165.0f/255.0f green:165.0f/255.0f blue:165.0f/255.0f alpha:1];
        _backgroundColorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    }else{
        _dayLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        _dayOfWeekLabel.textColor = [UIColor colorWithRed:227.0f/255.0f green:232.0f/255.0f blue:247.0f/255.0f alpha:1];
        _backgroundColorView.backgroundColor = [UIColor colorWithRed:86.0f/255.0f green:125.0f/255.0f blue:212.0f/255.0f alpha:1];
    }
}

- (IBAction)onDidSelectDay:(id)sender {
    if (self.didTapOnDay) {
        self.didTapOnDay([_day integerValue]);
    }
}

@end
