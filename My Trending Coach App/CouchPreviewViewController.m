//
//  CouchPreviewViewController.m
//  MTC
//
//  Created by Developer on 26.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CouchPreviewViewController.h"
#import "CoachPreviewCollectionViewCell.h"
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "CoachDetailPage.h"
#import "iCarousel.h"
#import "BBView.h"

@interface CouchPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (weak, nonatomic) IBOutlet iCarousel *sportClubs;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CouchPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *backgroundImages = @[@"TennisBackgroundsSport",@"SoccerBackgroundsSport",@"FootbalBackgroundsSport",@"BaseballBackgroundsSport",@"GolfBackgroundsSport",@"PersonalBackgroundsSport",@"FitnesBackgroundsSport",@"SoftballBackgroundsSport",@"PsuhologiBackgroundsSport",@"OtherBackgroundsSport"];
    
    self.background.image = [UIImage imageNamed:[backgroundImages objectAtIndex:self.sportType]];
    
    self.sportClubs.type = 0;
    
    [self.collectionView reloadData];
    
    if (self.couchClubAllInfo.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.sportClubs scrollToItemAtIndex:self.position animated:YES];
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.position inSection:0];
            [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:0 animated:YES];
            [self.collectionView reloadData];
        });
    }
    
}

#pragma mark -
#pragma mark iCarousel methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.couchClubAllInfo count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIView *sportView;
    
    //create new view if no view is available for recycling
    if (sportView == nil)
    {
        sportView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-30, 35)];
        ((UILabel*)sportView).textColor = [UIColor whiteColor];
        ((UILabel*)sportView).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)sportView).font = [UIFont fontWithName:@"SegoeUI-Bold" size:14];
    }
    
    ((UILabel*)sportView).text = [[self.couchClubAllInfo objectAtIndex:index] valueForKey:@"name"];
    
    return sportView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSIndexPath *index = [NSIndexPath indexPathForRow:carousel.currentItemIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:0 animated:YES];
}

#pragma mark - UICollectionViewDelegate



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.couchClubAllInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CoachPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoachPreviewCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *couch = [self.couchClubAllInfo objectAtIndex:indexPath.row];
    
    [cell setCoach:couch];
    
    cell.didOpenCouch = ^(NSDictionary *coach){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CoachDetailPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"CoachDetailPage"];
        pr.strCoachEdit = @"Player";
        [[NSUserDefaults standardUserDefaults] setValue:[coach valueForKey:@"id"] forKey:@"CoachID"];
        
        [self.navigationController pushViewController:pr animated:YES];
    };
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int position = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.sportClubs scrollToItemAtIndex:position animated:YES];
}

- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender{
    [self openRightView:nil];
}

@end
