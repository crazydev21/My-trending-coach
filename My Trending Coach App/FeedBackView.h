//
//  FeedBackView.h
//  My Trending Coach App
//
//  Created by Nisarg on 05/01/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@protocol MJSecondPopupDelegate;

@interface FeedBackView : UIViewController
{
    NSString *strRating;
}

@property (weak, nonatomic) IBOutlet UILabel *IbLabelCoach;
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *IBViewRating;
@property (weak, nonatomic) IBOutlet UITextView *IBTextviewFeedback;



- (IBAction)IBButtonClickCancel:(id)sender;
- (IBAction)IBButtonClickOk:(id)sender;



@end

@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(FeedBackView*)secondDetailViewController;
@end