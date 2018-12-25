//
//  EditedVideoPlayerPage.m
//  DemoVstrator
//
//  Created by Nisarg on 07/04/16.
//  Copyright © 2016 Techtic. All rights reserved.
//

#import "EditedVideoPlayerPage.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASBPlayerScrubbing.h"


@interface EditedVideoPlayerPage ()
{
    AVPlayer *avPlayer;
    AVPlayerLayer *avplayerlayer;
    
}
@property (strong, nonatomic) IBOutlet ASBPlayerScrubbing *scrubberBehavior;

@end


@implementation EditedVideoPlayerPage


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    avplayerlayer.frame = _IBViewMovie.bounds;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    avPlayer = [AVPlayer playerWithURL:appDelegate.UrlVideoFile];
    // avPlayer.volume = 1.0;
    avplayerlayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    
    UIView *containerView = [[UIView alloc] initWithFrame: _IBViewMovie.frame];
    avplayerlayer.frame = _IBViewMovie.frame;
    [_IBViewMovie.layer addSublayer:avplayerlayer];
    [_IBViewMovie addSubview:containerView];
    avplayerlayer.backgroundColor = [UIColor clearColor].CGColor;
    [avplayerlayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    /////////  MARK : -  Video Observer      ////////
    

    [avPlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    self.scrubberBehavior.player = avPlayer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (IBAction)sliderValueChanged:(id)sender forEvent:(UIEvent *)event
//{
//    UITouch *touch;
//    
//    touch = [[event allTouches] anyObject];
//    if(touch.phase == UITouchPhaseBegan)
//    {
//        self.playAfterDrag = (avPlayer.rate > 0);
//        [avPlayer pause];
//    }
//    
//    [self updatePlayer:(touch.phase == UITouchPhaseEnded)];
//}


- (IBAction)IBButtonClickSave:(id)sender
{
//    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:appDelegate.UrlVideoFile
//                                completionBlock:^(NSURL *assetURL, NSError *error){
//                                    /*notify of completion*/
//                                    [appDelegate showAlertMessage:@"Video successfully store in your photo library"];
//                                }];
    

}
//- (IBAction)IBButtonClickPlayPause:(id)sender
//{
//    
//    if(avPlayer.rate == 0)
//    {
//        if(CMTIME_COMPARE_INLINE(avPlayer.currentTime, == , avPlayer.currentItem.duration))
//        {
//            [avPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished)
//             {
//                 [avPlayer play];
//                 [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPlay"] forState:UIControlStateNormal];
//             }];
//        }
//        else
//        {
//            [avPlayer play];
//            
//            [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPlay"] forState:UIControlStateNormal];
//        }
//    }
//    else
//    {
//        [avPlayer pause];
//        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
//        
//        
//        
//    }
//    
//    
//}
//- (void)updatePlayer:(BOOL)playIfNeeded
//{
//    NSLog(@"playIfNeeded=%hhd",playIfNeeded);
//    CGFloat nbSecondsDuration;
//    CMTime time;
//    
//    nbSecondsDuration = CMTimeGetSeconds(avPlayer.currentItem.duration);
//    time = CMTimeMakeWithSeconds(nbSecondsDuration*_IBSliderPlay.value, NSEC_PER_SEC);
//    [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//        if(playIfNeeded && (_IBSliderPlay.value < _IBSliderPlay.maximumValue))
//        {
//            if(self.playAfterDrag)
//            {
//                [avPlayer play];
//                
//            }
//        }
//    }];
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayer *player = object;
    
    self.IBButtonPlayPause.selected = (player.rate != 0);
}

- (IBAction)IBButtonClickRedo:(id)sender
{
    [avPlayer pause];
    
    [avPlayer removeObserver:self forKeyPath:@"rate" context:nil];
    
    [self.presentingViewController dismissViewControllerAnimated: NO completion: nil];
}

@end
