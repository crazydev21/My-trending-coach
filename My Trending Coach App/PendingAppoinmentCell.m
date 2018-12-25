//
//  PendingAppoinmentCell.m
//  My Trending Coach
//
//  Created by Nisarg on 17/03/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "PendingAppoinmentCell.h"

@implementation PendingAppoinmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onDeltete:(id)sender{
    if(self.didDelete)
        self.didDelete();
}

- (IBAction)onStartSession:(id)sender{
    if(self.didStartSession)
        self.didStartSession();
}

@end
