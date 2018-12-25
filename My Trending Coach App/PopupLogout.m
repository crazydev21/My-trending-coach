//
//  PopupLogout.m
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "PopupLogout.h"

@interface PopupLogout ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation PopupLogout

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"PopupLogout" bundle:nil];
        self = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)show:(UIView*)view{
    
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    [view addSubview:self];
}

- (void)drawRect:(CGRect)rect{
    
    self.alertView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.alertView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.alertView.layer.shadowRadius = 3.0f;
    self.alertView.layer.shadowOpacity = 0.5f;
    
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

- (IBAction)no:(id)sender{
    [self removeFromSuperview];
}

- (IBAction)logout:(id)sender{
    if(self.didLogout)
        self.didLogout();
}

@end
