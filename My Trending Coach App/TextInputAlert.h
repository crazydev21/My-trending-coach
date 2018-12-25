//
//  TextInputAlert.h
//  MTC
//
//  Created by Developer on 19.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSubmit)();

@interface TextInputAlert : UIView

@property (nonatomic, copy) DidSubmit didSubmit;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)show:(UIView*)view;

@end
