//
//  CoachInfoFromClub.m
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CoachInfoFromClub.h"

@interface CoachInfoFromClub () <SharedClassDelegate>

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation CoachInfoFromClub

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"CoachInfoFromClub" bundle:nil];
        self = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    self.content.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.content.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.content.layer.shadowRadius = 3.0f;
    self.content.layer.shadowOpacity = 0.5f;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
        
        [self bringSubviewToFront:self.container];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)show:(UIView*)view{
    
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    [view addSubview:self];
}

#pragma mark - values

- (void)setPlaceValue:(NSDictionary *)placeValue{
    _placeValue = placeValue;
    
    NSString *strImage = [NSString stringWithFormat:@"%@",[placeValue valueForKey:@"image"]];
    strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strImage]] placeholderImage:[UIImage imageNamed:@"noimage"]];

    self.nameLabel.text = [[NSString stringWithFormat:@"%@",[placeValue valueForKey:@"name"]] uppercaseString];
}


#pragma mark - UIButton Actions

- (IBAction)onClose:(id)sender{
    [self removeFromSuperview];
}

- (IBAction)onRemoveUser:(id)sender{
    
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    NSString *couchId = [self.placeValue valueForKey:@"id"];
    [shared deleteCoach:couchId clubId:self.clubId];
    
    
//    [shared DeleteRequestAppointmentFromList:couchId passing_value:@"delete_coach" user_type:@"club"];
    
    [self removeFromSuperview];
}

-(void)getUserDetails4:(NSDictionary *)dicVideoDetials{
    if (self.didRemove)
        self.didRemove();
}

@end
