//
//  SelectedAvailabilityView.m
//  MTC
//
//  Created by Developer on 14.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "SelectedAvailabilityView.h"

@interface SelectedAvailabilityView ()

@property (weak, nonatomic) IBOutlet UIView *content;

@end

@implementation SelectedAvailabilityView

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"SelectedAvailabilityView" bundle:nil];
        self = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)show:(UIView*)view hours:(NSInteger)hours duration:(NSInteger)duration{
    
    NSInteger clearDel = hours;
    
    [self setFrame:CGRectMake(0, clearDel*55, view.frame.size.width, 55*duration)];
    
    self.content.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.content.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.content.layer.shadowRadius = 3.0f;
    self.content.layer.shadowOpacity = 0.5f;
    
    [view addSubview:self];
}

@end
