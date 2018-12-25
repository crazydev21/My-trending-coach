//
//  BBView.m
//  BubbleButtonView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import "BBView.h"
#import <QuartzCore/QuartzCore.h>



@implementation BBView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Bubble Button Methods

-(void)fillBIGGERBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize {
    // Init array
    self.bubbleButtonArray = [@[] mutableCopy];
    
    int pad = 5;
    
    for (int xx = 0; xx < strings.count; xx++) {
        
        // Find the size of the button, turn it into a rect
        NSString *bub = [strings objectAtIndex:xx];
        CGSize bSize = [bub sizeWithFont:[UIFont systemFontOfSize:fsize] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        bSize.height = bSize.height + 15;
        bSize.width = bSize.width + 15;
        
        CGRect buttonRect = CGRectMake(pad, pad, bSize.width + fsize, bSize.height + fsize/2);
        
        if (xx > 0) {
            UIButton *oldButton = [[self subviews] objectAtIndex:self.subviews.count - 1];
            if ((oldButton.frame.origin.x + (2*pad) + oldButton.frame.size.width + bSize.width + fsize) > self.frame.size.width) {
                buttonRect = CGRectMake(pad, oldButton.frame.origin.y + oldButton.frame.size.height + pad, bSize.width + fsize, bSize.height + fsize/2);
            }
            else {
                buttonRect = CGRectMake(oldButton.frame.origin.x + pad + oldButton.frame.size.width, oldButton.frame.origin.y, bSize.width + fsize, bSize.height + fsize/2);
            }
        }
        
        
        UIButton *bButton = [[UIButton alloc] initWithFrame:buttonRect];
        [bButton setShowsTouchWhenHighlighted:NO];
        [bButton setTitle:bub forState:UIControlStateNormal];
        bButton.titleLabel.textColor = textColor;
        bButton.backgroundColor = bgColor;
        bButton.layer.cornerRadius = 18;
        
        if([self.bubbleSelectedArray containsObject:bButton.titleLabel.text])
            [bButton setAlpha:1];
        else
            [bButton setAlpha:0.5];
        
        bButton.layer.masksToBounds = YES;
        
        // Give it some data and a target
        bButton.tag = xx;
        [bButton addTarget:self action:@selector(clickedBubbleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // And finally add a shadow
        bButton.layer.shadowColor = [[UIColor blackColor] CGColor];
        bButton.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
        bButton.layer.shadowRadius = 5.0f;
        bButton.layer.shadowOpacity = 0.35f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bButton.bounds cornerRadius:(3*fsize/4)];
        bButton.layer.shadowPath = [path CGPath];
        
        [bButton setBackgroundImage:[UIImage imageNamed:@"greenBuble"] forState:UIControlStateNormal];
        
        [bButton.titleLabel setFont:[UIFont fontWithName:@"SegoeUI-Bold" size:11]];
        
        // Add to the view, and to the array
        [self addSubview:bButton];
        [self.bubbleButtonArray addObject:bButton];
    }
    [self addBubbleButtonsWithInterval:0.034];
}

-(void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize {
    // Init array
    self.bubbleButtonArray = [@[] mutableCopy];
    
        int pad = 5;
    
        for (int xx = 0; xx < strings.count; xx++) {
            
            // Find the size of the button, turn it into a rect
            NSString *bub = [strings objectAtIndex:xx];
            CGSize bSize = [bub sizeWithFont:[UIFont systemFontOfSize:fsize] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            bSize.height = bSize.height + 5;
            bSize.width = bSize.width + 5;
            
            CGRect buttonRect = CGRectMake(pad, pad, bSize.width + fsize, bSize.height + fsize/2);
            
            if (xx > 0) {
                UIButton *oldButton = [[self subviews] objectAtIndex:self.subviews.count - 1];
                if ((oldButton.frame.origin.x + (2*pad) + oldButton.frame.size.width + bSize.width + fsize) > self.frame.size.width) {
                    buttonRect = CGRectMake(pad, oldButton.frame.origin.y + oldButton.frame.size.height + pad, bSize.width + fsize, bSize.height + fsize/2);
                }
                else {
                    buttonRect = CGRectMake(oldButton.frame.origin.x + pad + oldButton.frame.size.width, oldButton.frame.origin.y, bSize.width + fsize, bSize.height + fsize/2);
                }
            }
            
            
            UIButton *bButton = [[UIButton alloc] initWithFrame:buttonRect];
            [bButton setShowsTouchWhenHighlighted:NO];
            [bButton setTitle:bub forState:UIControlStateNormal];
            bButton.titleLabel.textColor = textColor;
            bButton.backgroundColor = bgColor;
            bButton.layer.cornerRadius = 12;
            
            if([self.bubbleSelectedArray containsObject:bButton.titleLabel.text])
                [bButton setAlpha:1];
            else
                [bButton setAlpha:0.5];
            
            bButton.layer.masksToBounds = YES;
            
            // Give it some data and a target
            bButton.tag = xx;
            [bButton addTarget:self action:@selector(clickedBubbleButton:) forControlEvents:UIControlEventTouchUpInside];
            
            // And finally add a shadow
            bButton.layer.shadowColor = [[UIColor blackColor] CGColor];
            bButton.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
            bButton.layer.shadowRadius = 5.0f;
            bButton.layer.shadowOpacity = 0.35f;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bButton.bounds cornerRadius:(3*fsize/4)];
            bButton.layer.shadowPath = [path CGPath];
            
            [bButton setBackgroundImage:[UIImage imageNamed:@"bgButtonLogin"] forState:UIControlStateNormal];
            
            [bButton.titleLabel setFont:[UIFont fontWithName:@"SegoeUI-Bold" size:13]];
            
            // Add to the view, and to the array
            [self addSubview:bButton];
            [self.bubbleButtonArray addObject:bButton];
        }
    
        [self addBubbleButtonsWithInterval:0.034];
    
}



-(void)addBubbleButtonsWithInterval:(float)ftime {
    
}



-(void)removeBubbleButtonsWithInterval:(float)ftime {
    
}



-(void)clickedBubbleButton:(UIButton *)bubble {
    if(!self.bubbleSelectedArray)
        self.bubbleSelectedArray = [[NSMutableArray alloc] init];
    
    if([self.bubbleSelectedArray containsObject:bubble.titleLabel.text]){
        [bubble setAlpha:0.5];
        [self.bubbleSelectedArray removeObject:bubble.titleLabel.text];
    }else{
        [bubble setAlpha:1];
        [self.bubbleSelectedArray addObject:bubble.titleLabel.text];
    }
    [delegate didClickBubbleButton:bubble];
}


@end
