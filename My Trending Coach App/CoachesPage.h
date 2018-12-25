//
//  CoachesPage.h
//  My Trending Coach App
//
//  Created by Nisarg on 15/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoachesPage : UIViewController <SharedClassDelegate>
{
    NSMutableArray *aryImages,*aryName,*aryID,*arySportType,*aryRateCoach, *coaches;
    NSString *strsportTypes;
    NSMutableArray *aryClubName,*aryClubID,*aryClubImage,*arystates,*arycountries;
}

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldName;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldSelectCountry;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldSelectState;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldSelectRating;

@property (strong, nonatomic) NSString *strClubID;


- (IBAction)IBButtonClickCountry:(id)sender;
//@property (weak, nonatomic) IBOutlet UIScrollView *IBScrollView;
//@property (weak, nonatomic) IBOutlet UIScrollView *IBScrollViewClubs;


@property (weak, nonatomic) IBOutlet UIView *IBContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutWidthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutHeightView;




@property (weak, nonatomic) IBOutlet UIView *IBContentViewClub;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutWidthViewClub;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutHeightViewClub;



- (IBAction)IBButtonClickBack:(id)sender;
@end
