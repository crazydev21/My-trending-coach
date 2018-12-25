//
//  AddNewAvailability.h
//  MTC
//
//  Created by Developer on 14.11.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldRegistrationDrop.h"

@class AddNewAvailability;
@protocol AddNewAvailabilityDelegate <NSObject>

- (void)didSetNewAvailability:(AddNewAvailability*)addNewAvailability;

@end

@interface AddNewAvailability : UIView
@property (nonatomic, weak) id<AddNewAvailabilityDelegate> delegate;

@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *startTimeDropDown;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *endTimeDropDown;
@property (weak, nonatomic) IBOutlet TextFieldRegistrationDrop *repeatDropDown;

- (void)show:(UIView*)view;

@end
