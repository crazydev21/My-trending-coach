//
//  CoachCollectionViewCell.m
//  MTC
//
//  Created by Developer on 20.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CoachCollectionViewCell.h"
#import "HCSStarRatingView.h"

@interface CoachCollectionViewCell()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *IBViewRating;

@end

@implementation CoachCollectionViewCell

-(void)setCouch:(NSDictionary *)couch{
    _couch = couch;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[couch valueForKey:@"image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _avatarImageView.image = image;
        }else{
            _avatarImageView.image = [UIImage imageNamed:@"noAvatar"];
        }
    }];
    
    _nameLabel.text = [couch valueForKey:@"name"];
    
    NSString *strRating = [NSString stringWithFormat:@"%@",[couch valueForKey:@"Rating"]];
    float value = [strRating floatValue];
    _IBViewRating.value = value;
    
//    _descriptionLabel.text = [club valueForKey:@"bio"];
}

@end
