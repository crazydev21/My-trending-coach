//
//  CoachPreviewCollectionViewCell.h
//  MTC
//
//  Created by Developer on 26.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

typedef void (^DidOpenCouch)(NSDictionary *coach);

@interface CoachPreviewCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *coach;

@property (nonatomic, copy) DidOpenCouch didOpenCouch;

@property (weak,nonatomic) IBOutlet UILabel *clubNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *clubLocationLabel;
@property (weak,nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end
