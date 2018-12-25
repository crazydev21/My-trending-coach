//
//  ClubDetailPage.m
//  MTC
//
//  Created by Bhavin on 6/8/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "ClubDetailPage.h"
#import "CoachRegistrationPage.h"
#import "LoginPage.h"
#import "ClubSignUpPage.h"
#import "CoachDetailPage.h"
#import "PopupLogout.h"
#import "CoachInfoFromClub.h"
#import "CoachCollectionViewCell.h"
#import "GetLabelHeigth.h"

@interface ClubDetailPage () <SharedClassDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *aryCoaches_list;
}

@property (strong, nonatomic) PopupLogout *popupLogout;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *shortInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) CoachInfoFromClub *coachInfoFromClub;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ClubDetailPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       self.navigationController.navigationBarHidden = YES;
    self.popupLogout = [[PopupLogout alloc] init];
    self.coachInfoFromClub = [[CoachInfoFromClub alloc] init];
    
    self.navigationBar.layer.shadowColor = self.shortInfo.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.navigationBar.layer.shadowOffset = self.shortInfo.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.navigationBar.layer.shadowRadius = self.shortInfo.layer.shadowRadius = 3.0f;
    self.navigationBar.layer.shadowOpacity = self.shortInfo.layer.shadowOpacity = 0.3f;
    self.navigationBar.layer.masksToBounds = self.shortInfo.layer.masksToBounds = NO;
    
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] isEqualToString:@"Club"])
    {
        _IBButtonAddCoach.enabled = YES;
        _IBButtonEdit.hidden = NO;
        [_IBButtonBackLogout setImage:[UIImage imageNamed:@"logoutBlue"] forState:UIControlStateNormal];
    }
    else
    {
        _IBButtonAddCoach.enabled = NO;
        _IBButtonEdit.hidden = YES;
        [_IBButtonBackLogout setImage:[UIImage imageNamed:@"backSquare"] forState:UIControlStateNormal];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self GetClubData];
}

- (CGFloat)makeHeigth{
    CGFloat stringHeigth = [GetLabelHeigth heightStringWithEmojis:self.IBTextViewDescription.text fontType:self.IBTextViewDescription.font ForWidth:self.IBTextViewDescription.frame.size.width];
    
    return self.IBTextViewDescription.frame.origin.y + stringHeigth + 210;
}

#pragma mark - UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CoachCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoachCollectionViewCell" forIndexPath:indexPath];
    
    
    NSString *strImage = [NSString stringWithFormat:@"%@",[[aryCoaches_list valueForKey:@"image"]objectAtIndex:indexPath.row]];
    strImage = [strImage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strImage]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.nameLabel.text = [[NSString stringWithFormat:@"%@",[[aryCoaches_list valueForKey:@"name"]objectAtIndex:indexPath.row]] uppercaseString];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return aryCoaches_list.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140, 160);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[aryCoaches_list valueForKey:@"id"]objectAtIndex:indexPath.row]] forKey:@"CoachID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.coachInfoFromClub setPlaceValue:[aryCoaches_list objectAtIndex:indexPath.row]];
    
    self.coachInfoFromClub.clubImageView.image = self.IBImageClub.image;
    self.coachInfoFromClub.clubLocationLabel.text = self.IBTextLoaction.text;
    self.coachInfoFromClub.clubId = self.strClubID;
    
    __weak typeof(self) weakSelf = self;
    self.coachInfoFromClub.didRemove = ^{
        [weakSelf GetClubData];
    };
    
    [self.coachInfoFromClub show:self.view];
}

#pragma mark - Club Data

- (void) GetClubData
{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] isEqualToString:@"Club"])
    {
        [shared ClubDetail:[[NSUserDefaults standardUserDefaults]stringForKey:@"club_id" ] passing_value:@"get_club_details" sport_type:@""];
    }
    else
    {
        [shared ClubDetail:_strClubID passing_value:@"get_club_details" sport_type:[[NSUserDefaults standardUserDefaults]stringForKey:@"SportType"]];
    }
}

-(void)getUserDetails4:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  : %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    data = [result valueForKey:@"data"];
    
    
    [_IBImageClub sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[data valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    _IBTextClub.text = [NSString stringWithFormat:@"%@",[[data valueForKey:@"name"] uppercaseString]];
    _IBTextEmail.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"email"]];
    _IBTextLoaction.text = [[NSString stringWithFormat:@"%@,%@",[data valueForKey:@"state"],[data valueForKey:@"location"]] uppercaseString];
    _IBTextViewDescription.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"bio"]];
    _IBTextEmail.enabled = NO;
    _strClubID = [NSString stringWithFormat:@"%@",[data valueForKey:@"id"]];
        
    if ([[data valueForKey:@"state"] isEqualToString:@""]) {
        _IBTextLoaction.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"location"]];
    }
    
    float value = [[NSString stringWithFormat:@"%@",[data valueForKey:@"AveRating"]] floatValue];
    _RatingView.value = value;
    
    aryCoaches_list = [[NSMutableArray alloc] init];
    aryCoaches_list = [data valueForKey:@"coaches_list"];
    
    self.IBLayoutContentViewHeight.constant = [self makeHeigth];
    self.scrollView.contentSize = CGSizeMake(375, self.IBLayoutContentViewHeight.constant);
    
    [self.collectionView reloadData];
}

-(void)getUserDetails2:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails_USER_LOGIN_API_CALL  :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.popupLogout removeFromSuperview];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        [self showViewController:pr sender:self];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
    }
    
}

#pragma mark - UIButtonActions

- (IBAction)IBButtonClickEdit:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ClubSignUpPage *pr = [storyboard instantiateViewControllerWithIdentifier:@"ClubSignUpPage"];
    pr.strEditTag = @"Edit";
    [self.navigationController pushViewController:pr animated:YES];
}

- (IBAction)IBButtonClickAddCoach:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CoachRegistrationPage *cp = [storyboard instantiateViewControllerWithIdentifier:@"CoachRegistrationPage"];
    cp.strEditTag = @"Register";
    cp.strClubID = _strClubID;
    [self.navigationController pushViewController:cp animated:YES];
}

- (IBAction)IBButtonClickBack:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"Login"] isEqualToString:@"Club"])
    {
        
        __weak typeof(self) weakSelf = self;
        [self.popupLogout show:self.view];
        
        self.popupLogout.didLogout = ^{
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate = weakSelf;
            
            [shared Logout:[[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Login"]];

        };
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
