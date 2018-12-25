//
//  PopupLogout.h
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidLogout)();

@interface PopupLogout : UIView

@property (nonatomic, copy) DidLogout didLogout;

- (void)show:(UIView*)view;

@end
