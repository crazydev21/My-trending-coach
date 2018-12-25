//
//  AddPhotoAlert.h
//  MTC
//
//  Created by Developer on 18.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectCamera)();
typedef void (^DidSelectLibrary)();

@interface AddPhotoAlert : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, copy) DidSelectCamera didSelectCamera;
@property (nonatomic, copy) DidSelectLibrary didSelectLibrary;

- (void)show:(UIView*)view;

@end
