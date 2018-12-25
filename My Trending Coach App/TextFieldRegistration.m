//
//  TextFieldRegistration.m
//  MTC
//
//  Created by Developer on 17.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "TextFieldRegistration.h"

@implementation TextFieldRegistration

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldRegistration"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.textField.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.textField.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.textField.layer.shadowRadius = 3.0f;
    self.textField.layer.shadowOpacity = 0.5f;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
