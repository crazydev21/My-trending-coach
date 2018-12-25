//
//  OTKTextChatTableViewCell.m
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import "OTKTextChatTableViewCell.h"

@implementation OTKTextChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.message.textContainer.lineFragmentPadding = 0;    
    self.message.textContainerInset = UIEdgeInsetsZero;
}

@end
