//
//  CoachVideoListPage.h
//  My Trending Coach
//
//  Created by Nisarg on 22/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachVideoListPage : UIViewController  <SharedClassDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
      NSMutableArray *arythumb,*aryVideo,*arySportType,*aryRandId,*aryTitle,*arySubTitle;
       NSInteger CaptureTag;
}


@property (weak, nonatomic) IBOutlet UITableView *IBtableView;

@property (weak, nonatomic) IBOutlet UIImageView *IBImageCaptureTab;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageReviewTab;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageEditedTab;


@end
