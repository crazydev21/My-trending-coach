//
//  CoachCollectionViewCell.h
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *couch;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
