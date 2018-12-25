//
//  AvailabilityViewController.m
//  MTC
//
//  Created by Evgen Litvinenko on 30.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "AvailabilityViewController.h"

#import "AvailabilityMontsCollectionViewCell.h"
#import "AvailabilityDayCollectionViewCell.h"

#import "SelectedAvailabilityView.h"
#import "AddNewAvailability.h"

@interface AvailabilityViewController () <AddNewAvailabilityDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SharedClassDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *montsCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *daysCollectionView;

@property (nonatomic, weak) IBOutlet UIView *selectedContentView;
@property (nonatomic, weak) IBOutlet UIButton* addButton;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;

@property (nonatomic, strong) AddNewAvailability *addNewAvailability;
@property (nonatomic, assign) BOOL newItemAdditionDisallowed;

@property (nonatomic, strong) NSMutableArray* content;
@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.months = [self monthsArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showCurrentDate];
        
        self.addNewAvailability = [[AddNewAvailability alloc] init];
        self.addNewAvailability.delegate = self;
    });
    self.addButton.hidden = self.newItemAdditionDisallowed;
}

- (void)didSetNewAvailability:(AddNewAvailability*)addNewAvailability{
    [self LoadData];
}

- (void)setupAdditionAllowed:(BOOL)allowed{
    self.newItemAdditionDisallowed = !allowed;
}

#pragma mark - Data

- (void)showCurrentDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:[NSDate date]];
    self.selectedDay = [components day];
    self.selectedMonth = [components month];
    [self.montsCollectionView reloadData];
    [self.daysCollectionView reloadData];
    [self.montsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedMonth-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.daysCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedDay-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //get content for current day
    NSDate *date = [self dateFromMonth:self.selectedMonth day:self.selectedDay];
    [self didSelectDate:date];
}

- (NSInteger)numberOfDaysInMonth:(NSInteger)month {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    //set date components
    [dateComponents setDay:1];
    [dateComponents setMonth:month];
    
    //save date relative from date
    NSDate *date = [calendar dateFromComponents:dateComponents];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

- (NSString*)dayOfWeekFromMonth:(NSInteger)month day:(NSInteger)day{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | kCFCalendarUnitWeekdayOrdinal) fromDate:[NSDate date]];
    
    //set date components
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    
    //save date relative from date
    NSDate *date = [calendar dateFromComponents:dateComponents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:date];
    return [dayOfWeek uppercaseString];
}

- (NSArray*)monthsArray {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *months = [dateFormatter monthSymbols];
    return months;
}

- (NSDate*)dateFromMonth:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    [dateComponents setYear:dateComponents.year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

#pragma mark - Actions

- (IBAction)onBack:(id)sender {
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onAddAvailablity:(id)sender{
    [self.addNewAvailability show:self.view];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _montsCollectionView) {
        return self.months.count;
    } else {
        return [self numberOfDaysInMonth:self.selectedMonth];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _montsCollectionView) {
        AvailabilityMontsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AvailabilityMonts" forIndexPath:indexPath];
        cell.month = self.months[indexPath.row];
        return cell;
    } else {
        AvailabilityDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AvailabilityDay" forIndexPath:indexPath];
        cell.day = [@(indexPath.row+1) stringValue];
        cell.dayOfWeek = [self dayOfWeekFromMonth:self.selectedMonth day:indexPath.row+1];
        
        if (self.selectedDay == indexPath.row + 1)
            cell.selectedCell = YES;
        else
            cell.selectedCell = NO;
        
        cell.didTapOnDay = ^(NSInteger day) {
            _selectedDay = day;
            NSDate *date = [self dateFromMonth:self.selectedMonth day:day];
            [self didSelectDate:date];
            [self.daysCollectionView reloadData];
        };
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _montsCollectionView) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, collectionView.frame.size.height);
    } else {
        return CGSizeMake(50.,CGRectGetHeight(collectionView.frame));
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = _montsCollectionView.frame.size.width;
    NSInteger month = ((_montsCollectionView.contentOffset.x + (0.5f * width)) / width)+1;
    if (self.selectedMonth != month) {
        self.selectedMonth = month;
        [self.daysCollectionView reloadData];
    }
}


#pragma mark - Availability

- (void)didSelectDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    appDelegate.strCalendarDate = [dateFormatter stringFromDate:date];
    [self LoadData];
}

#pragma mark - Content

-(void)LoadData{
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    
    if (_makeRequestForCouch) {
        [shared GetAvaibility:[[NSUserDefaults standardUserDefaults] valueForKey:@"CoachID"] passing_value:@"get" date:appDelegate.strCalendarDate];
    }else{
        if ([ [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"] isEqualToString:@"Player"])
        {
            [shared GetAvaibility:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"get" date:appDelegate.strCalendarDate];
        }
        else
        {
            [shared GetAvaibility:appDelegate.strCoachtoPlayerId passing_value:@"get" date:appDelegate.strCalendarDate];
        }
    }
}

- (void)removeAllItems{
    [self.selectedContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SelectedAvailabilityView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)placeItems:(NSArray*)content{
    [self removeAllItems];
    
    [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger hours = [[[obj valueForKey:@"start_time"] substringToIndex:3] integerValue] - 4;
        
        NSInteger duration = [[[obj valueForKey:@"end_time"] substringToIndex:2] integerValue]-[[[obj valueForKey:@"start_time"] substringToIndex:2] integerValue];
        if (duration<1)
            duration = 1;
        
        SelectedAvailabilityView *selectTime = [[SelectedAvailabilityView alloc] init];
        [selectTime show:self.selectedContentView hours:hours duration:duration];
        
        NSString* coachName = [obj objectForKey:@"coach_name"];
        if (coachName.length > 0) {
            selectTime.nameCouchLabel.text = [obj objectForKey:@"coach_name"];
        } else{
            selectTime.nameCouchLabel.text = @"Pending";
        }
//        [selectTime.sportNameButton setTitle:[obj objectForKey:@"coach_name"]
//                                    forState:(UIControlStateNormal)];
        
    }];
}

- (void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *availability = [[NSMutableArray alloc] init];
    availability = [result valueForKey:@"availability"];
    self.content = availability;

//    [availability enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSString* playerId = [obj objectForKey:@"player_id"];
//        NSString* coachId = [obj objectForKey:@"coach_id"];
//
//        SharedClass *shared = [SharedClass sharedInstance];
//        [shared playerDetail:playerId];
//        [shared coachDetail:coachId];
//
//    }];
    
    [self placeItems:availability];
  
}

- (void)didReceivePlayerDetails:(NSDictionary *)dicVideoDetials {
    NSString* receivedPlayerId = [dicVideoDetials objectForKey:@"player_id"];
    NSString* receivedPlayerName = [dicVideoDetials objectForKey:@"player_name"];

    [self.content enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* playerId = [obj objectForKey:@"player_id"];
        if ([receivedPlayerId isEqualToString:playerId]) {
            [obj setObject:receivedPlayerName forKey:@"player_name"];
        }
    }];
    [self placeItems:self.content];
}

- (void)getUserDetails_CoachDetail:(NSDictionary *)dicVideoDetials {
    
    NSString* receivedCoachId = [dicVideoDetials objectForKey:@"coach_id"];
    NSString* receivedCoachName = [dicVideoDetials objectForKey:@"coach_name"];

    [self.content enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString* coachId = [obj objectForKey:@"coach_id"];
        if ([receivedCoachId isEqualToString:coachId]) {
            [obj setObject:receivedCoachName forKey:@"coach_name"];
        }
    }];
    [self placeItems:self.content];
}



@end
