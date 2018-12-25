//
//  RequestedTableViewCell.m
//  MTC
//
//  Created by Developer on 09.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "RequestedTableViewCell.h"

@implementation RequestedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onDelete:(id)sender{
    if(self.didDelete)
        self.didDelete();
}

@end
