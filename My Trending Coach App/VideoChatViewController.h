//
//  VideoChatViewController.h
//  My Trending Coach App
//
//  Created by Nisarg on 01/02/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenTokUI/OTKTextChatComponent.h>
#import "MZTimerLabel.h"

@interface VideoChatViewController : UIViewController <OTSessionDelegate, OTPublisherDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate,OTKTextChatDelegate>
{
    NSTimer *timer,*timerexpire;
    BOOL OneTimeTag;
    NSInteger Seconds;
}

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutViewTextHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *IBLayoutViewVideoHeight;

@property (strong, nonatomic) IBOutlet UIView *IBViewBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *videoContainerView;
@property (retain, nonatomic) IBOutlet UIButton *cameraToggleButton;
@property (retain, nonatomic) IBOutlet UIButton *audioPubUnpubButton;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) NSTimer *overlayTimer;
@property (retain, nonatomic) IBOutlet UIButton *audioSubUnsubButton;
@property (retain, nonatomic) IBOutlet UIButton *endCallButton;
@property (retain, nonatomic) IBOutlet MZTimerLabel *IBLabelMinute;

@property (retain, nonatomic) IBOutlet UIView *UIViewVideo;
@property (retain, nonatomic) IBOutlet UIButton *IBButtonTap;


@property (retain, nonatomic) IBOutlet UIView *UIViewTextChat;
@property (strong) OTKTextChatComponent *textChat;

@property (retain, nonatomic) IBOutlet UIView *IBViewLoad;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *IBSpinner;
@property (retain, nonatomic) IBOutlet UILabel *IBLabelLoad;


- (IBAction)toggleAudioSubscribe:(id)sender;
- (IBAction)toggleCameraPosition:(id)sender;
- (IBAction)toggleAudioPublish:(id)sender;
- (IBAction)endCallAction:(UIButton *)button;



@property (strong, nonatomic) NSString *strAppointmentID;

@end
