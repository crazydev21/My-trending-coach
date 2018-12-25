//
//  CoachPreviewCollectionViewCell.m
//  MTC
//
//  Created by Developer on 26.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CoachPreviewCollectionViewCell.h"

@interface CoachPreviewCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) IBOutlet UIButton *IBButtonMonday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonTuesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonWednesday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonThursday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonFriday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSaturday;
@property (strong, nonatomic) IBOutlet UIButton *IBButtonSunday;

@end

@implementation CoachPreviewCollectionViewCell

- (void)setCoach:(NSDictionary *)coach{
    _coach = coach;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[coach valueForKey:@"image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _avatarImageView.image = image;
        }else{
           _avatarImageView.image = [UIImage imageNamed:@"noAvatar"];
        }
    }];
    
    _clubNameLabel.text = [coach valueForKey:@""];
    _clubLocationLabel.text = [coach valueForKey:@""];
    
    
}

- (IBAction)onOpenProfile:(id)sender{
    if (self.didOpenCouch)
        self.didOpenCouch(self.coach);
}

@end
