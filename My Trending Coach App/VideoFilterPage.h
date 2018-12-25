//
//  EditingImagePage.h
//  My Trending Coach App
//
//  Created by Nisarg on 22/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAScreenCaptureView.h"
#import "MZTimerLabel.h"

@class ACEDrawingView;

@interface VideoFilterPage : UIViewController <IAScreenCaptureViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,SharedClassDelegate,MZTimerLabelDelegate>
{
    NSTimer *Timer,*TimerRecord,*TimerProgress;
    NSMutableArray *aryImg,*aryImgRecord;
    CALayer *LayerView;
    NSString *strVideoPath;
    NSInteger imgtag,imagetagplay;
    int seconds;
    int BtnplayTag;
    UIView *viewShowLoad;
    UIActivityIndicatorView *spinner;

    MZTimerLabel *timerExample;
}

@property (weak, nonatomic) IBOutlet MZTimerLabel *IBLabelCounter;

@property (nonatomic, assign) BOOL playAfterDrag;

@property (strong, nonatomic) IBOutlet ACEDrawingView *drawingView;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *previewImageView;

@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *alphaButton;
@property (weak, nonatomic) IBOutlet UIImageView *IBImageViewPlay;

// actions
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)takeScreenshot:(id)sender;

// settings
- (IBAction)colorChange:(id)sender;
- (IBAction)toolChange:(id)sender;
- (IBAction)toggleWidthSlider:(id)sender;
- (IBAction)widthChange:(UISlider *)sender;
- (IBAction)toggleAlphaSlider:(id)sender;
- (IBAction)alphaChange:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UIView *IBView;
@property (weak, nonatomic) IBOutlet UIView *IBViewMoive;

@property (weak, nonatomic) IBOutlet UIButton *IBButtonPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonRecord;

@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UISlider *IBSliderVideo;

@property (weak, nonatomic) IBOutlet UIView *IBViewProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *IBProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *testimg;

@property (weak, nonatomic) IBOutlet UIButton *ButtonPen;
@property (weak, nonatomic) IBOutlet UIButton *ButtonLine;
@property (weak, nonatomic) IBOutlet UIButton *ButtonRound;
@property (weak, nonatomic) IBOutlet UIButton *ButtonRectangle;
@property (weak, nonatomic) IBOutlet UIButton *IBButtonSlow;



@end
