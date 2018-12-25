//
//  SelectedAvailabilityView.h
//  MTC
//
//  Created by Developer on 14.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedAvailabilityView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameCouchLabel;
@property (weak, nonatomic) IBOutlet UIButton *sportNameButton;

- (void)show:(UIView*)view hours:(NSInteger)hours duration:(NSInteger)duration;

@end
