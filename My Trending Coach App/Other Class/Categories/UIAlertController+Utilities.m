//
//  UIAlertController+Utilities.m
//  MTC
//
//  Created by iServ on 12/18/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "UIAlertController+Utilities.h"

@implementation UIAlertController (Utilities)

+ (UIAlertController*)showOnTarget:(UIViewController*)targetController title:(NSString*)title message:(NSString*)message cancelTitle:(NSString*)cancelTitle okTitle:(NSString*)okTitle actionHandler:(void(^)(UIAlertAction *action))actionHandler {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle.length > 0 || okTitle.length <= 0) {
        
        cancelTitle = cancelTitle.length <= 0 ? @"Cancel" : cancelTitle;
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:cancelTitle
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (actionHandler) {
                                               actionHandler(action);
                                           }
                                       }];
        
        [alertController addAction:cancelAction];
    }
    
    if (okTitle.length > 0) {
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:okTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (actionHandler) {
                                           actionHandler(action);
                                       }
                                   }];
        [alertController addAction:okAction];
    }

    [targetController presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

@end
