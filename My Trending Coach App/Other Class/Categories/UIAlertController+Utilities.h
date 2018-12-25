//
//  UIAlertController+Utilities.h
//  MTC
//
//  Created by iServ on 12/18/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Utilities)

+ (UIAlertController*)showOnTarget:(UIViewController*)targetController title:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle okTitle:(NSString*)okTitle actionHandler:(void(^)(UIAlertAction *action))actionHandler;

@end
