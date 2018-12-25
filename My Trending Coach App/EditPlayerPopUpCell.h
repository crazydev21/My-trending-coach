//
//  EditPlayerPopUpCell.h
//  My Trending Coach
//
//  Created by Nisarg on 18/03/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPlayerPopUpCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *IBButtonDelete;
@property (strong, nonatomic) IBOutlet UILabel *IBLabelName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutHeightDelete;



@end
