//
//  MainViewController.h
//  My Trending Coach App
//
//  Created by Nisarg on 07/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    NSArray *imgary,*textary;
}
@property (weak, nonatomic) IBOutlet UIButton *IBButtonClub;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonPlayers;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonCoaches;

@property (weak, nonatomic) IBOutlet UILabel *IBPlayerlbl;
@property (weak, nonatomic) IBOutlet UIScrollView *IBScrollView;

@property (weak, nonatomic) IBOutlet UIView *IBViewCPC;
@property (weak, nonatomic) IBOutlet UIView *IBViewUser;

- (IBAction)IBButtonClickUser:(id)sender;
- (IBAction)IBButtonClickLogout:(id)sender;

- (IBAction)IBButtonClubEvent:(id)sender;
- (IBAction)IBButtonPlayersEvent:(id)sender;
- (IBAction)IBButtonCoachesEvent:(id)sender;

@end
