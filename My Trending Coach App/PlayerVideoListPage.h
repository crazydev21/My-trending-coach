//
//  PlayerVideoListPage.h
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerVideoListPage : UIViewController <SharedClassDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *arythumb,*aryVideo,*arySportType,*aryRandId,*aryTitle,*arySubTitle;
    NSInteger CaptureTag;
}

@property (weak, nonatomic) IBOutlet UITableView *IBtableView;

@end
