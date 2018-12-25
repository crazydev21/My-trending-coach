//
//  AvailabilityMontsCollectionViewCell.m
//  MTC
//
//  Created by Evgen Litvinenko on 30.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "AvailabilityMontsCollectionViewCell.h"

@interface AvailabilityMontsCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *monthLabel;

@end

@implementation AvailabilityMontsCollectionViewCell

- (void)setMonth:(NSString *)month {
    _month = month;
    _monthLabel.text = month;
}

@end
