//
//  ClubDetailPage.h
//  MTC
//
//  Created by Bhavin on 6/8/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ClubDetailPage : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutContentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageClub;

@property (weak, nonatomic) IBOutlet UITextField *IBTextClub;
@property (weak, nonatomic) IBOutlet UITextField *IBTextLoaction;
@property (weak, nonatomic) IBOutlet UITextField *IBTextEmail;

@property (weak, nonatomic) IBOutlet UILabel *IBTextViewDescription;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonAddCoach;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *RatingView;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonEdit;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonBackLogout;

@property (strong, nonatomic) NSString *strClubID;

@end
