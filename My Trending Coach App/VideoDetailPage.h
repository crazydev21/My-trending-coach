//
//  VideoDetailPage.h
//  My Trending Coach
//
//  Created by Nisarg on 18/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailPage : UIViewController <SharedClassDelegate>


@property (nonatomic) BOOL isPresented;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageViewthumb;
@property (weak, nonatomic) IBOutlet UITextField *IBtextFieldTitle;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *IBTextFieldSportType;


@property (weak, nonatomic) IBOutlet UITextView *IBTextViewNotes;
@property (weak, nonatomic) IBOutlet UILabel *IBLabelNotes;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonSave;


@end
