//
//  EditedVideoPlayerPage.h
//  DemoVstrator
//
//  Created by Nisarg on 07/04/16.
//  Copyright © 2016 Techtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditedVideoPlayerPage : UIViewController




@property (weak, nonatomic) IBOutlet UIButton *IBButtonPlayPause;

@property (weak, nonatomic) IBOutlet UISlider *IBSliderPlay;
@property (weak, nonatomic) IBOutlet UIView *IBViewMovie;
@property (nonatomic, assign) BOOL playAfterDrag;


@end
