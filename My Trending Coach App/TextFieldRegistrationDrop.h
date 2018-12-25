//
//  TextFieldRegistrationDrop.h
//  MTC
//
//  Created by Developer on 18.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface TextFieldRegistrationDrop : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *textField;

@end
