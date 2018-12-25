//
//  ClubPreviewCollectionViewCell.h
//  MTC
//
//  Created by Developer on 25.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DidSelectCouch)(NSInteger index);

@interface ClubPreviewCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *club;
@property (strong, nonatomic) NSArray *couchesList;

@property (nonatomic, copy) DidSelectCouch didSelectCouch;

- (void)downloadCouches;

@end
