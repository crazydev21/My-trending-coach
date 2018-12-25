//
//  OTKTextChatView.h
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTKTextChatView : UIView

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *errorMessage;
@property (nonatomic, weak) IBOutlet UIButton *messageBanner;

-(void)disableAnchorToBottom;

-(void)anchorToBottom;

-(void)anchorToBottomAnimated:(BOOL)animated;

-(BOOL)isAnchoredToBottom;

-(BOOL)isAtBottom;

@end
