//
//  AddPhotoAlert.m
//  MTC
//
//  Created by Developer on 18.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "AddPhotoAlert.h"

@interface AddPhotoAlert ()

@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation AddPhotoAlert

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"AddPhotoAlert" bundle:nil];
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

- (IBAction)onClose:(id)sender{
    [self removeFromSuperview];
}

- (IBAction)onCamera:(id)sender{
    [self removeFromSuperview];
    if (self.didSelectCamera)
        self.didSelectCamera();
}

- (IBAction)onLibrary:(id)sender{
    [self removeFromSuperview];
    if(self.didSelectLibrary)
        self.didSelectLibrary();
}

@end
