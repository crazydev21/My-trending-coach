//
//  OTKTextChatView.m
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import "OTKTextChatView.h"

@implementation OTKTextChatView {
    BOOL anchorToBottom;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

-(void)disableAnchorToBottom {
    anchorToBottom = NO;
}

-(void)anchorToBottom {
    [self anchorToBottomAnimated:false];
}

-(void)anchorToBottomAnimated:(BOOL)animated {
    anchorToBottom = YES;
    if (![self isAtBottom]) {
        [_tableView setContentOffset:CGPointMake(0, MAX(0, _tableView.contentSize.height - _tableView.bounds.size.height)) animated:animated];
    }
}

-(BOOL)isAtBottom {
    return _tableView.contentOffset.y >=  _tableView.contentSize.height - _tableView.bounds.size.height;
}

-(BOOL)isAnchoredToBottom {
    return anchorToBottom;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (anchorToBottom) {
        [self anchorToBottomAnimated:YES];
    }    
}

@end
