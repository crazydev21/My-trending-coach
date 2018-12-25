//
//  CoachInfoFromClub.h
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidRemove)();

@interface CoachInfoFromClub : UIView

- (void)show:(UIView*)view;

@property (nonatomic, copy) DidRemove didRemove;

@property (strong, nonatomic) NSDictionary *placeValue;
@property (weak, nonatomic) IBOutlet UIImageView *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubLocationLabel;
@property (strong, nonatomic) NSString *clubId;

@end
