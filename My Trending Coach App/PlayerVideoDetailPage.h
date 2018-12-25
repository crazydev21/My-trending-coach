//
//  PlayerVideoDetailPage.h
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerVideoDetailPage : UIViewController <SharedClassDelegate,UIActionSheetDelegate>
{
    NSString *strVideurl,*strvideoID,*strCoachID;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *IBImageViewThumb;

@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldTitle;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldCreatedDate;
@property (weak, nonatomic) IBOutlet UITextField *IBTextFieldSportType;

@property (weak, nonatomic) IBOutlet UITextView *IBTextViewReview;

@property (weak, nonatomic) IBOutlet UIProgressView *IBProgressView;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonUpload;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonReview;

@property (weak, nonatomic) IBOutlet UILabel *IBLabelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelReviewer;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelReviewerName;

@property (weak, nonatomic) IBOutlet UIView *IBViewEdit;
@property (weak, nonatomic) IBOutlet UITextField *IBTextEditTitle;
@property (weak, nonatomic) IBOutlet UITextView *IBTextEditNotes;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelNote;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonEdit;

@property (strong, nonatomic) NSString *strVideoMainID;


@property (nonatomic, assign) BOOL isEditingMode;

@end
