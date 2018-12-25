//
//  VideoDetailPage.m
//  My Trending Coach
//
//  Created by Nisarg on 18/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "VideoDetailPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoFilterPage.h"


@interface VideoDetailPage ()

@end

@implementation VideoDetailPage

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _isPresented = YES;
        //        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        //        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
    return self;
}

//-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
//{
//    float oldWidth = sourceImage.size.width;
//    float scaleFactor = i_width / oldWidth;
//    
//    float newHeight = sourceImage.size.height * scaleFactor;
//    float newWidth = oldWidth * scaleFactor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
  
     [appDelegate stopLoadingview];
    
     
 
    _IBtextFieldTitle.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _IBTextFieldSportType.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _IBTextViewNotes.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
    
    
    NSLog(@"IDSBoth===%@---%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"]);
    
    [_IBTextFieldSportType setItemList:[[NSArray alloc]initWithObjects:@"TENNIS",@"GOLF",@"BASEBALL",@"SOFTBALL",@"(American) FOOTBALL",@"(Football) SOCCER",@"PERSONAL TRAINER",@"FITNESS", @"SPORT PSYCHOLOGY", @"OTHER", nil ]];
    
    NSURL *videoURL = [NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath] ;
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
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
    

    _IBImageViewthumb.image = thumbnail;
    

    
    
//    if ([Login isEqualToString:@"Coach"])
//    {
        _IBtextFieldTitle.text = [appDelegate.strFilterTitle uppercaseString];
       //  _IBTextFieldSportType.text = appDelegate.strFilterSportType;
         _IBTextViewNotes.text = appDelegate.strFilterNotes;
        
        if([_IBTextViewNotes.text length] == 0)
        {
            _IBLabelNotes.hidden = NO;
        }
        else
        {
            _IBLabelNotes.hidden = YES;
        }
        
       // _IBButtonSave.enabled = NO;

   // }

    
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (appDelegate.isSaved == YES)
    {
        _isPresented = NO;
        appDelegate.isSaved = NO;
        //[self.presentingViewController dismissViewControllerAnimated: NO completion: nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)IBButtonClickCancel:(id)sender
{
    appDelegate.strFilterTitle = @"";
    appDelegate.strFilterSportType = @"";
    appDelegate.strFilterNotes = @"";
     _isPresented = NO;
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:NO completion:NULL];

}



- (IBAction)IBButtonClickReview:(id)sender
{
    if (_IBtextFieldTitle.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter title"];
        
    }
//    else if (_IBTextViewNotes.text.length ==0 )
//    {
//        [appDelegate showAlertMessage:@"Please enter notes"];
//        
//    }
    else
    {

        appDelegate.strFilterTitle = _IBtextFieldTitle.text;
        appDelegate.strFilterSportType = _IBTextFieldSportType.text;
        appDelegate.strFilterNotes = _IBTextViewNotes.text;
        
        VideoFilterPage *uvp = [[VideoFilterPage alloc]initWithNibName:@"VideoFilterPage" bundle:nil ];
        //[self.navigationController pushViewController:uvp animated:YES];
        [self presentViewController: uvp animated: NO completion: nil];
    }
}

- (IBAction)IBButtonClickSave:(id)sender
{
    
    if (_IBtextFieldTitle.text.length ==0 )
    {
        [appDelegate showAlertMessage:@"Please enter title"];
        
    }
  //    else if (_IBtextFieldTitle.text.length ==0 )
//    {
//        [appDelegate showAlertMessage:@"Please enter notes"];
//        
//    }
    else
    {
    
        
        NSString *Login = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"Login"];
        
        
        if ([Login isEqualToString:@"Coach"])
        {
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];

            
            NSString *VideoReq;
            if (appDelegate.strPlayerId.length == 0)
            {
                appDelegate.strPlayerId = @"";
                VideoReq = [NSString stringWithFormat:@"Capture"]; ///Edited
            }
            else
            {
                VideoReq = [NSString stringWithFormat:@"Review"];
            }
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotificationWithVideotoPlayer:appDelegate.strPlayerId coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:_IBtextFieldTitle.text notes :_IBTextViewNotes.text videoreq:VideoReq sporttype:_IBTextFieldSportType.text randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewthumb.image];
        
        }
        else
        {
            
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
         
           
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@"" title:_IBtextFieldTitle.text notes :_IBTextViewNotes.text videoreq :@"Capture" sporttype:_IBTextFieldSportType.text randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewthumb.image];
            

           
        }
        
    }
   
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];

            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:_IBtextFieldTitle.text notes :_IBTextViewNotes.text videoreq :@"Capture" sporttype:_IBTextFieldSportType.text randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewthumb.image];
            
        }
        
    }
    
    // NSLog(@"ava=%@",Aryavailability);
}
-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);

    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        appDelegate.isSaved = YES;
         _isPresented = NO;
        
        appDelegate.strFilterTitle = @"";
        appDelegate.strFilterSportType = @"";
        appDelegate.strFilterNotes = @"";
        _IBtextFieldTitle.text = @"";
        _IBTextFieldSportType.text = @"";
        _IBTextViewNotes.text= @"";
        [self.presentingViewController dismissViewControllerAnimated: NO completion: nil];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
}


- (IBAction)IBButtonClickPlay:(id)sender
{
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath]];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    AVPlayer *avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    avPlayer.volume = 5.0;
    // AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:avPlayer];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = avPlayer;
    [playerViewController.player play];//Used to Play On start
    [self presentViewController:playerViewController animated:YES completion:nil];

}


- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        _IBLabelNotes.hidden = NO;
    }
    else
    {
        _IBLabelNotes.hidden = YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
