//
//  ClubPreviewViewController.h
//  MTC
//
//  Created by Developer on 25.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubPreviewViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *aryClubName;

@property (strong, nonatomic) NSArray *clubsAllInfo;
@property (strong, nonatomic) NSArray *couchClubAllInfo;

@property (assign, nonatomic) NSInteger position;
@property (assign, nonatomic) NSInteger sportType;


@end
