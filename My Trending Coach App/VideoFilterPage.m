//
//  EditingImagePage.m
//  My Trending Coach App
//
//  Created by Nisarg on 22/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#import "VideoFilterPage.h"
#import "ACEDrawingView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import <QuartzCore/QuartzCore.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ASBPlayerScrubbing.h"
#import "CEMovieMaker.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "EditedVideoPlayerPage.h"


#define kActionSheetColor       100
#define kActionSheetTool        101


@interface VideoFilterPage () <UIActionSheetDelegate, ACEDrawingViewDelegate>
{
    AVPlayer *avPlayer;
    
    NSString *strVideo;
    AVPlayerLayer *avplayerlayer;
    
    AVAudioRecorder *recorder;
    
    AVURLAsset *audioAsset, *videoAsset;
    NSURL *outputFileAudioURL, *finalUrl;
    
    NSInteger counter;
}
@property (strong, nonatomic) IBOutlet ASBPlayerScrubbing *scrubberBehavior;

@property (nonatomic, strong) CEMovieMaker *movieMaker;
@end

@implementation VideoFilterPage



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BtnplayTag = 0;
    counter = 0;
    
    aryImg = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    // set the delegate
    self.drawingView.delegate = self;
    
    // start with a black pen
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // init the preview image
    self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.previewImageView.layer.borderWidth = 2.0f;
    
    [self clear:0];
    _drawingView.backgroundColor = [UIColor clearColor];
    _drawingView.contentMode = UIViewContentModeScaleToFill;
    self.drawingView.lineColor = [UIColor redColor];
    
    // _IBView.contentMode = UIViewContentModeScaleAspectFit;
    self.drawingView.lineWidth = 3.0;;
    
    
    [self LoadData];
    
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}





-(void) LoadData
{
    
    NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    NSTimeInterval durationInSeconds = 0.0;
    if (asset)
        durationInSeconds = CMTimeGetSeconds(asset.duration);
    
    seconds = durationInSeconds;
    NSLog(@"duration: %.2d", seconds);
    
    
    if (seconds >15)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Video is too long, Please select a smaller video clip"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        alert.tag = 5;
        [alert show];
        
        

        
    }
    else
    {
       
        strVideoPath = [[NSString alloc]init ];
        strVideoPath = appDelegate.strPlayerstrVideoPath;
        NSLog(@"strVideoPath=%@",strVideoPath);
        
        
        _IBViewProgress.hidden = NO;
        TimerProgress = [NSTimer scheduledTimerWithTimeInterval: 1
                                                        target: self
                                                        selector:@selector(ProgressChange:)
                                                        userInfo: nil repeats:YES];
        
        [self performSelector:@selector(ImageGenrator) withObject:nil afterDelay:0.1];

    }
    [self RecordAudio];
}


-(void)ProgressChange:(NSTimer *)timer
{
    if (seconds <5)
    {
        _IBProgressView.progress +=0.17;
    }
    else if (seconds <= 10)
    {
        _IBProgressView.progress +=0.08;
    }
    else if (seconds > 10)
    {
        _IBProgressView.progress +=0.05;
    }
    
    if (_IBProgressView.progress >= 1.0)
    {
        [TimerProgress invalidate];
        TimerProgress = nil;
        _IBViewProgress.hidden = YES;
        
        _ButtonPen.layer.borderWidth = 2;
        _ButtonPen.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [self performSelector:@selector(ImageSave) withObject:nil afterDelay:0.5];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    avplayerlayer.frame = _IBViewMoive.bounds;
    
}

- (void) ImageSave
{
    if (aryImg.count != 0)
    {
        _IBImageViewPlay.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:0]]];
    }
    
}



-(void)ImageGenrator
{
    aryImg = [[NSMutableArray alloc]init ];
    imagetagplay = 0;
    //  NSString *videostr = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    NSURL *videoURL = [NSURL fileURLWithPath:strVideoPath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.requestedTimeToleranceAfter =  kCMTimeZero;
    generator.requestedTimeToleranceBefore =  kCMTimeZero;
    generator.appliesPreferredTrackTransform = YES;
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        
        int FPS = 20;
        for (Float64 i = 0; i < CMTimeGetSeconds(asset.duration) *  FPS ; i++){
            @autoreleasepool {
                CMTime time = CMTimeMake(i, FPS);
                NSError *err;
                CMTime actualTime;
                CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
                UIImage *generatedImage = [[UIImage alloc] initWithCGImage:image];
                
                NSData *imgData = UIImageJPEGRepresentation(generatedImage, 0.7f);
                
                NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
                NSString *imageName = [NSString stringWithFormat:@"PlayImage%ld.png",(long)imagetagplay];
                imagetagplay+=1;
                NSString *imagePath = [docsDir stringByAppendingPathComponent:imageName];
                
                [imgData writeToFile:imagePath atomically:NO];
                
                [aryImg addObject:imagePath];
                
                CGImageRelease(image);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSLog(@"aryImg=%@",aryImg);
            
        });
    });
    
    
 
//        aryImg = [[NSMutableArray alloc]init ];
////        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
////        dispatch_async(myQueue, ^{
//            // Perform long running process
//            MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//            moviePlayer.useApplicationAudioSession = NO;
//            for (float i = 0; i < CMTimeGetSeconds(asset.duration) ; i+=0.2)
//            {
//                NSLog(@"i=%f",i);
//    
//                UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:i timeOption:MPMovieTimeOptionExact];
//    
//                _testimg.image = thumbnail;
//                NSData *imgData = UIImageJPEGRepresentation(thumbnail, 0.3f);
//    
//                NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
//                NSString *imageName = [NSString stringWithFormat:@"PlayImage%ld.png",(long)imagetagplay];
//                imagetagplay+=1;
//                NSString *imagePath = [docsDir stringByAppendingPathComponent:imageName];
//    
//                // Log the image and path being saved.  If either of these are nil, nothing will be written.
//                NSLog(@"Saving %@ to %@", thumbnail, imagePath);
//    
//              //  [UIImagePNGRepresentation(thumbnail) writeToFile:imagePath atomically:NO];
//                [imgData writeToFile:imagePath atomically:NO];
//    
//                //[moviePlayer requestThumbnailImagesAtTimes:i timeOption:MPMovieTimeOptionExact];
//                 //NSLog(@"_IBImageViewPlay.frame.size.width=%f    %f",_IBImageViewPlay.frame.size.width,_IBImageViewPlay.frame.size.height);
//    
//    
//               // _Image.image = thumbnail;
//    
//                [aryImg addObject:imagePath];
//    
//    
//               // [self imageWithImage:thumbnail scaledToWidth:_IBImageViewPlay.frame.size.width];
//    
//    
//            }
//            NSLog(@"aryImg=%@",aryImg);
    
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Update the UI
//                
//                 [moviePlayer stop];
//                 NSLog(@"aryImg=%@",aryImg);
//    
//            });
//        });
//
    
    
}


- (void)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    _Image.image = image;
    
    if (_IBImageViewPlay.image == nil) {
        _IBImageViewPlay.image = image;
    }
    
    [aryImg addObject:image];
    
}
- (IBAction)IBButtonClickSlow:(id)sender
{
    [Timer invalidate];
    Timer = nil;
    
    BtnplayTag = 1;
    [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
    

    if ([_IBButtonSlow.titleLabel.text isEqualToString:@"2.0X"])
    {
        [_IBButtonSlow setTitle:@"1.0X" forState:UIControlStateNormal];
        Timer = [NSTimer scheduledTimerWithTimeInterval: 0.045
                                                 target: self
                                               selector:@selector(Play:)
                                               userInfo: nil repeats:YES];
        

    }
    else  if ([_IBButtonSlow.titleLabel.text isEqualToString:@"0.5X"])
    {
        [_IBButtonSlow setTitle:@"2.0X" forState:UIControlStateNormal];
        Timer = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                 target: self
                                               selector:@selector(Play:)
                                               userInfo: nil repeats:YES];
        
    }
    else
    {
        [_IBButtonSlow setTitle:@"0.5X" forState:UIControlStateNormal];
        Timer = [NSTimer scheduledTimerWithTimeInterval: 0.085
                                                 target: self
                                               selector:@selector(Play:)
                                               userInfo: nil repeats:YES];
        

    }
    
    
   }



-(void)Play:(NSTimer *)timer
{
    if (counter >= aryImg.count) {
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
        
    }
    else
    {
    //    NSLog(@"imagepathhhh==%@",[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:counter]]);
        _IBImageViewPlay.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:counter]]];
        
        counter +=1;
        [self Value1:counter Value2:aryImg.count-1];
    }
  //  NSLog(@"_IBSliderVideo.value=%f",_IBSliderVideo.value);
    
}

- (IBAction)SliderVlaueChange:(id)sender forEvent:(UIEvent *)event
{
    
    double Value1 = _IBSliderVideo.value;
    double Value2 = aryImg.count;
    NSInteger FinalValue = Value1*Value2;
    
   // NSLog(@"FinalValue=%d", FinalValue);
    
    counter = FinalValue;
    
  //  NSLog(@"_IBSliderVideo.value=%f",_IBSliderVideo.value);
    if (counter >= aryImg.count)
    {
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
        
    }
    else
    {
        _IBImageViewPlay.image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:counter]]];
    }
    
    
}
#pragma mark - Actions

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)IBClickBack:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to cancel this?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)IBButtonClickFramPrev:(id)sender
{
    //    _scrubberBehavior.slider.value -= 0.01;
    //    NSLog(@" scrubberBehavior.slider.value=%f", _scrubberBehavior.slider.value);
    //    [_scrubberBehavior updatePlayer:0];
    
    
    if (counter <= 0) {
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
    }
    else
    {
        
        counter--;
        _IBImageViewPlay.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:counter]]];
        [self Value1:counter Value2:aryImg.count-1];
        
    }
    
}

- (IBAction)IBButtonClickFramNext:(id)sender
{
    //    _scrubberBehavior.slider.value += 0.01;
    //    NSLog(@" scrubberBehavior.slider.value=%f", _scrubberBehavior.slider.value);
    //    [_scrubberBehavior updatePlayer:0];
    
    if (counter+1 >= aryImg.count) {
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
    }
    else
    {
        counter++;
        _IBImageViewPlay.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[aryImg objectAtIndex:counter]]];
        [self Value1:counter Value2:aryImg.count-1];
        
    }
    
    
    
}

-(void) Value1:(double)Value1 Value2:(double)Value2
{
    
    double FinalValue = Value1/Value2;
    
    NSLog(@"FinalValue=%f", FinalValue);
    
    _IBSliderVideo.value = FinalValue;
    
    if (_IBSliderVideo.value == 1) {
        counter = 0;
        
        BtnplayTag = 0;
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPlay"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
        
        _IBProgressView.progress = 0.0;
        
    }

    
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (IBAction)IBClickRecord:(id)sender
{
    
    NSData *data1 = UIImagePNGRepresentation(_IBButtonRecord.currentImage);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"recordButton"]);
                                              
                                              
    if ([data1 isEqual:data2])
    {
        NSLog(@"is the same image");
        

  
     
        
        imgtag= 0;
        aryImgRecord = [[NSMutableArray alloc] init];
        [_IBButtonRecord setImage:[UIImage imageNamed:@"record-48"] forState:UIControlStateNormal];
        TimerRecord = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                                       target: self
                                                     selector:@selector(onTick:)
                                                     userInfo: nil repeats:YES];
        
        // [_IBView startRecording];
        //        AVAudioSession *session = [AVAudioSession sharedInstance];
        //        [session setActive:YES error:nil];
        [recorder record];
        
        timerExample = [[MZTimerLabel alloc] initWithLabel:_IBLabelCounter andTimerType:MZTimerLabelTypeTimer];
        timerExample.timeFormat = @"ss";
        [timerExample setCountDownTime:1*60]; //** Or you can use [timer3 setCountDownToDate:aDate];
        [timerExample start];
       // _IBLabelCounter.hidden = NO;
        _IBLabelCounter.text = @"59";
       
        [[[[iToast makeText:NSLocalizedString(@"Voice recording activated.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }
    else
    {
  
        
        [_IBButtonRecord setImage:[UIImage imageNamed:@"recordButton"] forState:UIControlStateNormal];
        // [_IBView stopRecording];
        [TimerRecord invalidate];
        TimerRecord= nil;
        [recorder stop];
        
        
        [[[[iToast makeText:NSLocalizedString(@"Voice recording saved.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        
        [self process];
        //        AVAudioSession *session = [AVAudioSession sharedInstance];
        //        [session setActive:NO error:nil];
        
        
    }
}

-(void)onTick:(NSTimer *)timer
{
    

    
    //NSLog(@"_IBLabelCounter.text=%@",_IBLabelCounter.text);
    if ([_IBLabelCounter.text isEqualToString:@"00"])
    {
    

        
        [appDelegate startLoadingview:@"Loading..."];
        [_IBButtonRecord setImage:[UIImage imageNamed:@"recordButton"] forState:UIControlStateNormal];
        // [_IBView stopRecording];
        [TimerRecord invalidate];
        TimerRecord= nil;
        [recorder stop];
        
        [[[[iToast makeText:NSLocalizedString(@"Voice recording saved.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        
        [self process];
        
    }

    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        CGSize size = CGSizeMake(_IBView.frame.size.width, _IBView.frame.size.height);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        
        CGRect rec = CGRectMake(0, 0, _IBView.frame.size.width, _IBView.frame.size.height);
        [_IBView drawViewHierarchyInRect:rec afterScreenUpdates:NO];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // [self imageWithImage:image scaledToWidth:1024];
        
        _testimg.image = image;
        
        //
        //        float newHeight = 320;
        //        float newWidth = 560;
        //
        //        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        //        [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        //        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        
        
        
//        
//        CGRect rect = [_IBView bounds];
//        
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [_IBView.layer renderInContext:context];
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();

        
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
        NSString *imageName = [NSString stringWithFormat:@"RecordImage%ld.png",(long)imgtag];
        imgtag+=1;
        NSString *imagePath = [docsDir stringByAppendingPathComponent:imageName];
        
        // Log the image and path being saved.  If either of these are nil, nothing will be written.
        //   NSLog(@"Saving %@ to %@", image, imagePath);
        
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:NO];
        
        [aryImgRecord addObject:imagePath];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
             _testimg.image = image;
        });
    });
    
    
    // UIGraphicsEndImageContext();
    
}


- (IBAction)IBClickPlayPause:(id)sender
{
    
    
    if (BtnplayTag == 1)
    {
        BtnplayTag = 0;
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPlay"] forState:UIControlStateNormal];
        [Timer invalidate];
        Timer = nil;
        
    }
    else
    {
        BtnplayTag = 1;
        [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
        
        if (_IBSliderVideo.value == 1) {
            counter = 0;
        }
        
        [Timer invalidate];
        Timer = nil;
        
        if ([_IBButtonSlow.titleLabel.text isEqualToString:@"0.5X"])
        {
            Timer = [NSTimer scheduledTimerWithTimeInterval: 0.085
                                                     target: self
                                                   selector:@selector(Play:)
                                                   userInfo: nil repeats:YES];
        }
        else  if ([_IBButtonSlow.titleLabel.text isEqualToString:@"1.0X"])
        {
            Timer = [NSTimer scheduledTimerWithTimeInterval: 0.045
                                                     target: self
                                                   selector:@selector(Play:)
                                                   userInfo: nil repeats:YES];
        }
        else
        {
            
            Timer = [NSTimer scheduledTimerWithTimeInterval: 0.02
                                                     target: self
                                                   selector:@selector(Play:)
                                                   userInfo: nil repeats:YES];
        }
        
    }
    
}


-(void) RecordAudio
{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudio.wav",
                               nil];
    outputFileAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSLog(@"outputFileAudioURL=%@", outputFileAudioURL);
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileAudioURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES; 
    [recorder prepareToRecord];
    
}





-(void)startLoadingview :(NSString *)strMessage
{
    // DISPLAY CUSTOM LOADING SCREEN WHEN THIS METHOD CALLS.
    
    viewShowLoad=[[UIView alloc]init];
    
    viewShowLoad.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    viewShowLoad.backgroundColor =[UIColor clearColor];
    
    // SET THE VIEW INSIDE MAIN VIEW
    UIView *viewUp=[[UIView alloc] initWithFrame:viewShowLoad.frame];
    viewUp.backgroundColor=[UIColor blackColor];
    viewUp.alpha=0.5;
    [viewShowLoad addSubview:viewUp];
    
    // CUSTOM ACTIVITY INDICATOR
    //    objSpinKit=[[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleBounce color:[UIColor whiteColor]];
    //    objSpinKit.center = CGPointMake(CGRectGetMidX(viewShowLoad.frame), CGRectGetMidY(viewShowLoad.frame));
    //    [objSpinKit startAnimating];
    //    [viewShowLoad addSubview:objSpinKit];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(viewShowLoad.frame.size.width/2.0, viewShowLoad.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    [viewShowLoad addSubview:spinner];
    
    [spinner startAnimating];
    
    // SET THE LABLE
    UILabel *lblLoading=[[UILabel alloc] initWithFrame:CGRectMake(0, spinner.frame.origin.y + 30, viewShowLoad.frame.size.width, 50)];
    lblLoading.font=[UIFont systemFontOfSize:18.0];
    lblLoading.text=strMessage;
    lblLoading.numberOfLines = 0;
    lblLoading.backgroundColor=[UIColor clearColor];
    lblLoading.textColor=[UIColor whiteColor];
    lblLoading.textAlignment=NSTextAlignmentCenter;
    [viewShowLoad addSubview:lblLoading];
    
    [appDelegate.window addSubview:viewShowLoad];
}

-(void)stopLoadingview
{
    [spinner stopAnimating];
    //[objSpinKit stopAnimating];
    [viewShowLoad removeFromSuperview];
}

-(void)StopCounting
{
    _IBLabelCounter.hidden = YES;
    timerExample = [[MZTimerLabel alloc] initWithLabel:_IBLabelCounter andTimerType:MZTimerLabelTypeTimer];
    timerExample.timeFormat = @"ss";
    [timerExample setCountDownTime:1*60]; //** Or you can use [timer3 setCountDownToDate:aDate];
    [timerExample start];

}

- (void)process
{
    
    [_IBButtonPlayPause setImage:[UIImage imageNamed:@"BtnPause"] forState:UIControlStateNormal];
    [Timer invalidate];
    Timer = nil;
    
    [self performSelector:@selector(StopCounting) withObject:nil afterDelay:2];
  
   // [self startLoadingview:@"Loading..."];
    NSLog(@"aryImgRecord=%@",aryImgRecord);
    
    //    if (finalUrl == nil)
    //    {
    //    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                   AVVideoCodecH264, AVVideoCodecKey,
    //                                   [NSNumber numberWithInt:1024], AVVideoWidthKey,
    //                                   [NSNumber numberWithInt:768], AVVideoHeightKey,
    //                                   nil];
    NSDictionary *settings;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    NSLog(@"width=%f",result.width);
    
    if(result.width == 480)
    {
        settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecJPEG withWidth:688 andHeight:416];
    }
    else if(result.width == 568)
    {
        settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecJPEG withWidth:848 andHeight:416];
    }
    else if(result.width== 667)
    {
        settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecJPEG withWidth:1056 andHeight:528];
    }
    else if(result.width == 736)
    {
        settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecJPEG withWidth:1792 andHeight:904];
    }
    else
    {
        settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecJPEG withWidth:688 andHeight:416]; 
    }

    self.movieMaker = [[CEMovieMaker alloc] initWithSettings:settings];
    
    [self.movieMaker createMovieFromImageURLs:[aryImgRecord copy] withCompletion:^(NSURL *fileURL)
    {
      
        [self mergeAndSave:fileURL];
        
//        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//        [library writeVideoAtPathToSavedPhotosAlbum:fileURL
//                                    completionBlock:^(NSURL *assetURL, NSError *error){
//                                        /*notify of completion*/
//                                        NSLog(@"Completed recording, file is stored at:  %@", fileURL);
//                                    }];
//

//                ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//                [library writeVideoAtPathToSavedPhotosAlbum:fileURL
//                                            completionBlock:^(NSURL *assetURL, NSError *error){
//                                                /*notify of completion*/
//                                                NSLog(@"Completed recording, file is stored at:  %@", fileURL);
//                                            }];
        
       // [self viewMovieAtUrl:fileURL];
        
    }];
    
    //    }
    //    else
    //    {
    //        [self viewMovieAtUrl:finalUrl];
    //    }
    
    
    
    //    NSError *error = nil;
    //
    //
    //    // set up file manager, and file videoOutputPath, remove "test_output.mp4" if it exists...
    //    //NSString *videoOutputPath = @"/Users/someuser/Desktop/test_output.mp4";
    //    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //    NSString *documentsDirectory = [NSHomeDirectory()
    //                                    stringByAppendingPathComponent:@"Documents"];
    //    NSString *videoOutputPath = [documentsDirectory stringByAppendingPathComponent:@"test_output.mp4"];
    //    NSURL    *testoutputFileUrl = [NSURL fileURLWithPath:videoOutputPath];
    //    NSLog(@"-->testoutputFileUrl= %@", testoutputFileUrl);
    //    // get rid of existing mp4 if exists...
    //    if ([fileMgr removeItemAtPath:videoOutputPath error:&error] != YES)
    //        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    //
    //
    //    CGSize imageSize = CGSizeMake(688, 320);
    //    NSUInteger fps = aryImgRecord.count;
    //
    //
    //    //NSMutableArray *imageArray;
    //    //imageArray = [[NSMutableArray alloc] initWithObjects:@"download.jpeg", @"download2.jpeg", nil];
    //    NSMutableArray *imageArray;
    //   // NSArray* imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
    //    imageArray = [[NSMutableArray alloc] initWithCapacity:aryImgRecord.count];
    //    NSLog(@"-->imageArray.count= %i", aryImgRecord.count);
    //    for (NSString* path in aryImgRecord)
    //    {
    //        [imageArray addObject:[UIImage imageWithContentsOfFile:path]];
    //
    //    }
    //    NSLog(@"-->imageArray= %@", imageArray);
    //
    //    //////////////     end setup    ///////////////////////////////////
    //
    //    NSLog(@"Start building video from defined frames.");
    //
    //    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
    //                                  [NSURL fileURLWithPath:videoOutputPath] fileType:AVFileTypeQuickTimeMovie
    //                                                              error:&error];
    //    NSParameterAssert(videoWriter);
    //
    //    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                   AVVideoCodecH264, AVVideoCodecKey,
    //                                   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
    //                                   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey,
    //                                   nil];
    //
    //    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
    //                                            assetWriterInputWithMediaType:AVMediaTypeVideo
    //                                            outputSettings:videoSettings];
    //
    //
    //    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
    //                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
    //                                                     sourcePixelBufferAttributes:nil];
    //
    //    NSParameterAssert(videoWriterInput);
    //    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    //    videoWriterInput.expectsMediaDataInRealTime = YES;
    //    [videoWriter addInput:videoWriterInput];
    //
    //    //Start a session:
    //    [videoWriter startWriting];
    //    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    //
    //    CVPixelBufferRef buffer = NULL;
    //
    //    //convert uiimage to CGImage.
    //    int frameCount = 0;
    //    double numberOfSecondsPerFrame =1;
    //    double frameDuration = fps * numberOfSecondsPerFrame;
    //
    //    //for(VideoFrame * frm in imageArray)
    //    NSLog(@"**************************************************");
    //    for(UIImage * img in imageArray)
    //    {
    //        //UIImage * img = frm._imageFrame;
    //        buffer = [self pixelBufferFromCGImage:[img CGImage]];
    //
    //        BOOL append_ok = NO;
    //        int j = 0;
    //        while (!append_ok && j < aryImgRecord.count) {
    //            if (adaptor.assetWriterInput.readyForMoreMediaData)  {
    //                //print out status:
    //                NSLog(@"Processing video frame (%d,%lu)",frameCount,(unsigned long)[imageArray count]);
    //
    //                CMTime frameTime = CMTimeMake(frameCount*frameDuration,(int32_t) fps);
    //                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
    //                if(!append_ok){
    //                    NSError *error = videoWriter.error;
    //                    if(error!=nil) {
    //                        NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
    //                    }
    //                }
    //            }
    //            else {
    //                printf("adaptor not ready %d, %d\n", frameCount, j);
    //                [NSThread sleepForTimeInterval:0.1];
    //            }
    //            j++;
    //        }
    //        if (!append_ok) {
    //            printf("error appending image %d times %d\n, with error.", frameCount, j);
    //        }
    //        frameCount++;
    //    }
    //    NSLog(@"**************************************************");
    //
    //    //Finish the session:
    //    [videoWriterInput markAsFinished];
    //    [videoWriter finishWriting];
    //    NSLog(@"Write Ended");
    //
    //
    //
    //    ////////////////////////////////////////////////////////////////////////////
    //    //////////////  OK now add an audio file to move file  /////////////////////
    //    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    //
    //    NSString *bundleDirectory = [[NSBundle mainBundle] bundlePath];
    //    // audio input file...
    //
    //    // this is the video file that was just written above, full path to file is in --> videoOutputPath
    //    NSURL    *video_inputFileUrl = [NSURL fileURLWithPath:videoOutputPath];
    //
    //    // create the final video output file as MOV file - may need to be MP4, but this works so far...
    //    NSString *outputFilePath = [documentsDirectory stringByAppendingPathComponent:@"final_video.mp4"];
    //    NSURL    *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    //
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
    //        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    //
    //    CMTime nextClipStartTime = kCMTimeZero;
    //
    //    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    //    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    //    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    //
    //    //nextClipStartTime = CMTimeAdd(nextClipStartTime, a_timeRange.duration);
    //
    //    AVURLAsset *audioAsset = [[AVURLAsset alloc]initWithURL:outputFileAudioURL options:nil];
    //    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    //    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    //
    //
    //
    //    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    //    //_assetExport.outputFileType = @"com.apple.quicktime-movie";
    //    _assetExport.outputFileType = @"public.mpeg-4";
    //    //NSLog(@"support file types= %@", [_assetExport supportedFileTypes]);
    //    _assetExport.outputURL = outputFileUrl;
    //
    //    [_assetExport exportAsynchronouslyWithCompletionHandler:
    //     ^(void ) {
    //         //[self saveVideoToAlbum:outputFilePath];
    //     }
    //     ];
    //
    //    ///// THAT IS IT DONE... the final video file will be written here...
    //    NSLog(@"DONE.....outputFileUrl--->%@", outputFileUrl);
    //
    //         [self viewMovieAtUrl:outputFileUrl];
    ////
    ////    appDelegate.UrlVideoFile = outputFileUrl;
    ////    NSLog(@"appDelegate.UrlVideoFile=%@",appDelegate.UrlVideoFile);
    ////
    ////    [aryImgRecord removeAllObjects];
    ////    EditedVideoPlayerPage *ev = [[EditedVideoPlayerPage alloc]initWithNibName:@"EditedVideoPlayerPage" bundle:nil ];
    ////    [self.navigationController pushViewController:ev animated:YES];
    //
    //
    //    // the final video file will be located somewhere like here:
    //    // /Users/caferrara/Library/Application Support/iPhone Simulator/6.0/Applications/D4B12FEE-E09C-4B12-B772-7F1BD6011BE1/Documents/outputFile.mov
    //
    //
    //    ////////////////////////////////////////////////////////////////////////////
    //    ////////////////////////////////////////////////////////////////////////////
    
}


////////////////////////
- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image {
    
    CGSize size = CGSizeMake(688, 320);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          size.width,
                                          size.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    if (status != kCVReturnSuccess){
        NSLog(@"Failed to create pixel buffer");
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    //kCGImageAlphaNoneSkipFirst);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
////////////////////////



- (void)viewMovieAtUrl:(NSURL *)fileURL
{
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [playerController.view setFrame:self.view.bounds];
    [self presentMoviePlayerViewControllerAnimated:playerController];
    [playerController.moviePlayer prepareToPlay];
    [playerController.moviePlayer play];
    [self.view addSubview:playerController.view];
}






-(void)mergeAndSave : (NSURL *)videoUrl
{
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //Now first load your audio file using AVURLAsset. Make sure you give the correct path of your videos.
    //  NSURL *audio_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MyAudio" ofType:@"m4a"]];
    audioAsset = [[AVURLAsset alloc]initWithURL:outputFileAudioURL options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    
    //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we will load video file.
    //  NSURL *video_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Asteroid_Video" ofType:@"m4v"]];
    
    videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
    
    //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //decide the path where you want to store the final video created with audio and video merge.
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.mov"]];
    appDelegate.strPlayerstrVideoPath = outputFilePath;
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    //Now create an AVAssetExportSession object that will save your final video at specified path.
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:_assetExport];
         });
     }
     ];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        appDelegate.UrlVideoFile = session.outputURL;
        NSLog(@"appDelegate.UrlVideoFile=%@",appDelegate.UrlVideoFile);
        NSLog(@"appDelegate.strPlayerstrVideoPath=%@",appDelegate.strPlayerstrVideoPath);
        //  [self viewMovieAtUrl:finalUrl];\
        
        [self RemoveImagesFromDirectory];
        
        [self stopLoadingview];
         [self stopLoadingview];
        [aryImgRecord removeAllObjects];
        [aryImg removeAllObjects];
        
        [self SendNotification];
        
        
//        EditedVideoPlayerPage *ev = [[EditedVideoPlayerPage alloc]initWithNibName:@"EditedVideoPlayerPage" bundle:nil ];
//        [self presentViewController: ev animated: NO completion: nil];
        
        //        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        //        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
        //            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
        //                                        completionBlock:^(NSURL *assetURL, NSError *error){
        //                                            dispatch_async(dispatch_get_main_queue(), ^{
        //                                                if (error) {
        //                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        //                                                    [alert show];
        //                                                }else{
        //                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //                                                    [alert show];
        //                                                    [self loadMoviePlayer:outputURL];
        //                                                }
        //                                            });
        //                                        }];
        //        }
    }
    audioAsset = nil;
    videoAsset = nil;
    
}


//////// Remove Images From Directory /////////

-(void)RemoveImagesFromDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for (int i = 0; i<aryImg.count; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"PlayImage%d.png",i];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            NSLog(@"Deleted=%@",imageName);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }

    }
   
    for (int i = 0; i<aryImgRecord.count; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"RecordImage%d.png",i];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            NSLog(@"Deleted=%@",imageName);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
    }

}



#pragma mark - crop square image method
-(UIImage *)SquareImageWithSideOfLength:(float)length image :(UIImage *)Image
{
    UIImage *thumbnail;
    
    //couldn’t find a previously created thumb image so create one first…
    UIImage *mainImage = Image;
    
    // Allocate an imageview
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    
    // Get the greater value from width and height
    BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
    //    float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
    
    float sideFull, difference;
    
    if(widthGreaterThanHeight)
    {
        sideFull = mainImage.size.height;
        difference = mainImage.size.width - sideFull;
    }
    else
    {
        sideFull = mainImage.size.width;
        difference = mainImage.size.height - sideFull;
    }
    
    // Setup a rect to generate thumbnail
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect( currentContext, clippedRect);
    
    CGFloat scaleFactor = length/sideFull;
    
    if (widthGreaterThanHeight)
    {
        //a landscape image – make context shift the original image to the left when drawn into the context
        CGContextTranslateCTM(currentContext, -(difference / 2) * scaleFactor, 0);
    }
    
    else
    {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        CGContextTranslateCTM(currentContext, 0, -(difference / 2) * scaleFactor);
    }
    
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
    
    [mainImageView.layer renderInContext:currentContext];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return thumbnail;
}



-(void)SendNotification
{
    //NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
    
    //
    [appDelegate stopLoadingview];
    NSString *Login = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"Login"];
    
    
    if ([Login isEqualToString:@"Player"])
    {
        //NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:appDelegate.UrlVideoFile];
        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [player pause];
        player = nil;
        
        if (thumbnail.size.width < thumbnail.size.height)
        {
            thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.width image:thumbnail];
        }
        else
        {
            thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.height image:thumbnail];
        }
        
        

        int randomID = arc4random() % 90000 + 10000;
        NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
        
        
        NSString *VideoReq;
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"].length == 0)
        {
            VideoReq = [NSString stringWithFormat:@"Review"]; ///Edited
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@"" title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq:VideoReq sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];

        }
        else
        {
            VideoReq = [NSString stringWithFormat:@"Review"];
            NSString *str= [[NSUserDefaults standardUserDefaults]stringForKey:@"CardNumber"];
            if (str.length > 10)
            {
                NSString *cardno = [NSString stringWithFormat:@"************%@",[str substringFromIndex: [str length] - 4]];
                NSLog(@"cardno=%@",cardno);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged from (Card no:%@) for send this Video",cardno] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
                alert.tag = 2;
                [alert show];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged to send this video"] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
                alert.tag = 2;
                [alert show];
                
            }

        }
        
        
        
    }
    else
    {
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:appDelegate.UrlVideoFile];
        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [player pause];
        player = nil;
        
        if (thumbnail.size.width < thumbnail.size.height)
        {
            thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.width image:thumbnail];
        }
        else
        {
            thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.height image:thumbnail];
        }
        

        
        int randomID = arc4random() % 90000 + 10000;
        NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];

        NSString *VideoReq;
        if (appDelegate.strPlayerId.length == 0)
        {
            appDelegate.strPlayerId = @"";
            VideoReq = [NSString stringWithFormat:@"Review"]; ///Edited
        }
        else
        {
            VideoReq = [NSString stringWithFormat:@"Review"];
        }

        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared sendNotificationWithVideotoPlayer:appDelegate.strPlayerId coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq:VideoReq sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
    }

    
 
    
   
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [self.presentingViewController dismissViewControllerAnimated: NO completion: nil];
        }
        
    }
    else  if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            [self.presentingViewController dismissViewControllerAnimated: NO completion: nil];
        }
        
    }

    else  if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            
            //NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:appDelegate.UrlVideoFile];
            UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [player pause];
            player = nil;
            
            if (thumbnail.size.width < thumbnail.size.height)
            {
                thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.width image:thumbnail];
            }
            else
            {
                thumbnail = [self SquareImageWithSideOfLength:thumbnail.size.height image:thumbnail];
            }
            

            
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
            
            
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq:@"Review" sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
            
        }
        
    }
    
    // NSLog(@"ava=%@",Aryavailability);
}
-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    [self stopLoadingview];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        appDelegate.isReviewed = YES;
        appDelegate.isSaved = YES;
        appDelegate.strFilterTitle = @"";
        appDelegate.strFilterSportType = @"";
        appDelegate.strFilterNotes = @"";
        appDelegate.isReviewed = YES;
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:NO completion:NULL];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    
    
    
}



#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}



- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [self.drawingView clear];
    [self updateButtonStatus];
    
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                {
                    
                    self.drawingView.drawTool = ACEDrawingToolTypePen;
                    break;
                }
                    
                case 1:
                {
                    self.drawingView.drawTool = ACEDrawingToolTypeArrow; //ACEDrawingToolTypeLine;
                    break;
                }
                    
                case 2:
                {
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                }
                    
                    //                case 3:
                    //                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    //                    break;
                    //
                    //                case 4:
                    //                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    //                    break;
                    //
                    //                case 5:
                    //                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    //                    break;
                    //
                    //                case 6:
                    //                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
                    //                    break;
                    //
                    //                case 7:
                    //                    self.drawingView.drawTool = ACEDrawingToolTypeText;
                    //                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeDraggableText;
                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}


#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Red", @"Black", @"Green", @"Blue", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a tool"
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"Cancel"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"Pen", @"Line",
    //                                  @"Rect (Stroke)", @"Rect (Fill)",
    //                                  @"Ellipse (Stroke)", @"Ellipse (Fill)",
    //                                  @"Eraser", @"Text", @"Text (Multiline)",
    //                                  nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Pen", @"Line",@"Rect", @"Text",nil];
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}


- (IBAction)IBClickPen:(id)sender
{
    _ButtonPen.layer.borderWidth = 2;
    _ButtonPen.layer.borderColor = [UIColor orangeColor].CGColor;
    _ButtonLine.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRound.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRectangle.layer.borderColor = [UIColor clearColor].CGColor;

    self.drawingView.drawTool = ACEDrawingToolTypePen;
}
- (IBAction)IBClickLine:(id)sender
{
    _ButtonLine.layer.borderWidth = 2;
    _ButtonPen.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonLine.layer.borderColor = [UIColor orangeColor].CGColor;
    _ButtonRound.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRectangle.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.drawingView.drawTool = ACEDrawingToolTypeArrow; //ACEDrawingToolTypeLine;
}
- (IBAction)IBClickArrow:(id)sender
{
    
    _ButtonRectangle.layer.borderWidth = 2;
    _ButtonPen.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonLine.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRound.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRectangle.layer.borderColor = [UIColor orangeColor].CGColor;

    
    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
}
- (IBAction)IBClickCircle:(id)sender
{
    _ButtonRound.layer.borderWidth = 2;
    _ButtonPen.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonLine.layer.borderColor = [UIColor clearColor].CGColor;
    _ButtonRound.layer.borderColor = [UIColor orangeColor].CGColor;
    _ButtonRectangle.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
}

-(IBAction)IBButtonClickInfo:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFORMATION"
                                                    message:@"\nFRAME ADVANCEMENT : Pressing the recording button allows voice over analysis and frame by frame drawing/editing.\n\nRIGHT HAND SIDE BUTTONS :\nProvides undo functionality, editing tools and increase/decrease the speed of the video\n"
                                               delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil] ;
    alert.tag = 1;
    [alert show];
}



@end

