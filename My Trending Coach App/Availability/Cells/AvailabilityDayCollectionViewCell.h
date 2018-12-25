//
//  AvailabilityDayCollectionViewCell.h
//  MTC
//
//  Created by Evgen Litvinenko on 30.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidTapOnDay)(NSInteger day);

@interface AvailabilityDayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *dayOfWeek;

@property (nonatomic, copy) DidTapOnDay didTapOnDay;

@property (nonatomic, assign) BOOL selectedCell;

@end
