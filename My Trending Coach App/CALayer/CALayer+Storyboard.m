//
//  CALayer+Storyboard.m
//  yerdle
//
//  Created by Hugues Bernet-Rollande on 5/21/14.
//  Copyright (c) 2014 Yerdle. All rights reserved.
//

#import "CALayer+Storyboard.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end