//
//  PendingAppoinmentCell.h
//  My Trending Coach
//
//  Created by Nisarg on 17/03/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidDelete)();
typedef void (^DidStartSession)();

@interface PendingAppoinmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *IBLabelTitle;
@property (weak, nonatomic) IBOutlet UIButton *IBLabelType;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelDate;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelTime;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonDelete;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonStartsession;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (nonatomic, copy) DidDelete didDelete;
@property (nonatomic, copy) DidStartSession didStartSession;

@end
