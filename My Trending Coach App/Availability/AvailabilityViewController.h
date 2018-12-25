//
//  AvailabilityViewController.h
//  MTC
//
//  Created by Evgen Litvinenko on 30.10.17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailabilityViewController : UIViewController

@property (assign, nonatomic) BOOL makeRequestForCouch;

- (void)setupAdditionAllowed:(BOOL)allowed;

@end
