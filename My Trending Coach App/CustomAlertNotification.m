//
//  CustomAlertNotification.m
//  MTC
//
//  Created by Developer on 18.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CustomAlertNotification.h"

@interface CustomAlertNotification ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CustomAlertNotification

+ (void)show :(UIView*)view message:(NSString*)message{
    UINib *customNib = [UINib nibWithNibName:@"CustomAlertNotification" bundle:nil];
    CustomAlertNotification *customView = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];

    [customView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    customView.messageLabel.text = [message uppercaseString];
    
    [view addSubview:customView];
}

-(void)drawRect:(CGRect)rect{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
        
        [self bringSubviewToFront:self.contentView];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (IBAction)onOk:(id)sender{
    [self removeFromSuperview];
}

@end
