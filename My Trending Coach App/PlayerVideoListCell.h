//
//  PlayerVideoListCell.h
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSettings)();
typedef void (^DidEdit)();
typedef void (^DidDelete)();
typedef void (^DidReloadData)();

@interface PlayerVideoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IBImageViewthumb;
@property (weak, nonatomic) IBOutlet UILabel *IBLabeltitle;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelDateTime;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelReviewed;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSDictionary *videoValue;

@property (weak, nonatomic) IBOutlet UIView *settingsView;    

@property (nonatomic, copy) DidSettings didSettings;
@property (nonatomic, copy) DidEdit didEdit;
@property (nonatomic, copy) DidDelete didDelete;
@property (nonatomic, copy) DidReloadData didReloadData;

@end
