//
//  AddNewAvailability.m
//  MTC
//
//  Created by Developer on 14.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "AddNewAvailability.h"
#import "SharedClass.h"

@interface AddNewAvailability() <SharedClassDelegate>

@property (weak, nonatomic) IBOutlet UIView *content;

@end

@implementation AddNewAvailability

- (instancetype)init{
    self = [super init];
    if (self) {
        UINib *customNib = [UINib nibWithNibName:@"AddNewAvailability" bundle:nil];
        self = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)makePickersContent{
    self.startTimeDropDown.textField.itemList = @[@"04:00", @"04:30", @"05:00", @"05:30", @"06:00", @"06:30",@"07:00", @"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30",  @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30", @"23:00", @"23:30"];
    
    
    self.endTimeDropDown.textField.itemList = @[@"04:00", @"04:30", @"05:00", @"05:30", @"06:00", @"06:30",@"07:00", @"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30",  @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30", @"23:00", @"23:30"];
    
    self.repeatDropDown.textField.itemList = @[@"Never",@"Every Day",@"Every Week",@"Every 2 Week",@"Every Month",@"Every Month",@"Every Year"];
}

- (void)show:(UIView*)view{
    
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    self.content.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.content.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.content.layer.shadowRadius = 3.0f;
    self.content.layer.shadowOpacity = 0.5f;
    
    [self makePickersContent];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
        
        [self bringSubviewToFront:self.content];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.startTimeDropDown.titleLabel.text = @"START TIME";
    self.endTimeDropDown.titleLabel.text = @"END TIME";
    self.repeatDropDown.titleLabel.text = @"REPEAT TIME";
    
    [view addSubview:self];
}

- (IBAction)onClose:(id)sender{
    [self removeFromSuperview];
}

- (IBAction)onSave:(id)sender{
    
    NSInteger repeat = [self.repeatDropDown.textField.itemList indexOfObject:self.repeatDropDown.textField.text]+1;
    
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;

    
    [shared SetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"set" date:appDelegate.strCalendarDate start_time:self.startTimeDropDown.textField.text end_time:self.endTimeDropDown.textField.text repeat:[NSString stringWithFormat:@"%ld", repeat] approve:@"yes"];
}

-(void)getUserDetails2:(NSDictionary *)dicVideoDetials{
    NSDictionary *result = [dicVideoDetials valueForKey:@"result"];
    if([[result valueForKey:@"code"] integerValue] != 1){
       [[[UIAlertView alloc] initWithTitle:@"" message:[result valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }else{
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        
        [shared RequestToCoachForLiveStream:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] date:appDelegate.strCalendarDate startTime:self.startTimeDropDown.textField.text endTime:self.endTimeDropDown.textField.text passing_value:@"send"];
    }
}

-(void)getUserDetails4:(NSDictionary *)dicVideoDetials{
    NSDictionary *result = [dicVideoDetials valueForKey:@"result"];
    if([[result valueForKey:@"code"] integerValue] == 0){
        [[[UIAlertView alloc] initWithTitle:@"" message:[result valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }else{
        [self removeFromSuperview];
    }
}

- (IBAction)onTap:(id)sender{
    [self.superview endEditing:YES];
}
@end
