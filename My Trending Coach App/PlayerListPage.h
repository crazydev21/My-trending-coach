//
//  PlayerListPage.h
//  My Trending Coach
//
//  Created by Nisarg on 17/05/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerListPage : UIViewController <SharedClassDelegate>
{
      NSMutableArray *aryImages,*aryImagesPath,*aryName,*aryID,*arySportType;
    NSString *strsportTypes,*strPlayerId;
}

@property (weak, nonatomic) IBOutlet UIScrollView *IBScrollView;

@end
