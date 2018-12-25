//
//  CustomAlertNotification.h
//  MTC
//
//  Created by Developer on 18.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertNotification : UIView

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

+ (void)show :(UIView*)view message:(NSString*)message;

@end
