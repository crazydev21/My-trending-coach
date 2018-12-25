//
//  SinglePersonView.m
//  MTC
//
//  Created by Developer on 23.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "SinglePersonView.h"

@implementation SinglePersonView

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"SinglePersonView" bundle:nil];
        self = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)show:(UIView*)view{
    
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    [view addSubview:self];
}

- (void)drawRect:(CGRect)rect{
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}


@end
