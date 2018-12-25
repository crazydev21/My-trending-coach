//
//  RequestedTableViewCell.h
//  MTC
//
//  Created by Developer on 09.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

typedef void (^DidDelete)();

@interface RequestedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *sessionCost;
@property (weak, nonatomic) IBOutlet UILabel *sessionCostTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rating;


@property (nonatomic, copy) DidDelete didDelete;

@end
