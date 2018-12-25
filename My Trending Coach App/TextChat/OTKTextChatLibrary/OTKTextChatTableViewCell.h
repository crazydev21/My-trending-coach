//
//  OTKTextChatTableViewCell.h
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTKTextChatTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UITextView *message;

@end
