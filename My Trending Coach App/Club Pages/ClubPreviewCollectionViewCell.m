//
//  ClubPreviewCollectionViewCell.m
//  MTC
//
//  Created by Developer on 25.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "ClubPreviewCollectionViewCell.h"
#import "CoachCollectionViewCell.h"
#import "HCSStarRatingView.h"

@interface ClubPreviewCollectionViewCell () <SharedClassDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *clubImage;
@property (weak, nonatomic) IBOutlet UILabel *clubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clubLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ClubPreviewCollectionViewCell

- (void)setClub:(NSDictionary *)club{
    _club = club;
    
    [self.clubImage sd_setImageWithURL:[NSURL URLWithString:[club valueForKey:@"image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _clubImage.image = image;
        }else{
            _clubImage.image = [UIImage imageNamed:@"noAvatar"];
        }
    }];
    
    _clubLocationLabel.text = [[NSString stringWithFormat:@"%@, %@", [club valueForKey:@"location"], [club valueForKey:@"state"]] uppercaseString];
    
    _clubNameLabel.text = [club valueForKey:@"name"];
    
    _descriptionLabel.text = [club valueForKey:@"bio"];
}

- (void)downloadCouches{
        SharedClass *shared = [SharedClass sharedInstance];
        shared.delegate =self;
        
        if (!self.couchesList.count)
            [shared ClubDetail:[self.club valueForKey:@"id"] passing_value:@"get_club_details" sport_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]];
}

- (void)setCouchesList:(NSArray *)couchesList{
    _couchesList = couchesList;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)getUserDetails4:(NSDictionary *)dicVideoDetials{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    data = [result valueForKey:@"data"];
    
    self.couchesList = [data valueForKey:@"coaches_list"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.couchesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CoachCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoachCollectionViewCell" forIndexPath:indexPath];
    
    [cell setCouch:[self.couchesList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.didSelectCouch)
        self.didSelectCouch(indexPath.row);
}

@end
