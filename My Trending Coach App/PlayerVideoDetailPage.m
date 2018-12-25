//
//  PlayerVideoDetailPage.m
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "PlayerVideoDetailPage.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "VideoDetailPage.h"
#import "CoachesPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PendingAppoinmentVC.h"
#import "VideoFilterPage.h"


@interface PlayerVideoDetailPage ()

@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;

@end

@implementation PlayerVideoDetailPage

- (void)viewDidLoad {
    [super viewDidLoad];

    _IBTextEditTitle.layer.sublayerTransform = CATransform3DMakeTranslation(5.0, 0, 0);
    // Do any additional setup after loading the view from its nib.
    if (appDelegate.strVideoRandId.length == 0)
    {
        [_IBButtonUpload setTitle:@"SAVE" forState:UIControlStateNormal];
        _IBViewEdit.hidden = NO;
        
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
        
        
        _IBImageViewThumb.image = thumbnail;
        
        _IBButtonEdit.hidden = YES;

    }
    else
    {
        _IBButtonEdit.hidden = NO;
        [self GetPlayerVideoData];
    }
    
    
    _IBTextEditNotes.layer.borderColor = _IBTextEditTitle.layer.borderColor = [[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1] CGColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_IBTextEditNotes.text.length == 0)
    {
        _IBLabelNote.hidden = NO;
    }
    else
    {
        _IBLabelNote.hidden = YES;
    }
}

- (IBAction)IBButtonClickEdit:(id)sender
{
    [_IBButtonUpload setTitle:@"SAVE" forState:UIControlStateNormal];
    _IBViewEdit.hidden = NO;
    
    if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"] && strCoachID.length != 0)
    {
        _IBButtonUpload.enabled = NO;
        _IBButtonUpload.alpha = 0.5;
    }
    else
    {
        _IBButtonUpload.enabled = YES;
        _IBButtonUpload.alpha = 1.0;
    }

}

- (IBAction)IBButtonClickBack:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)IBButtonClickPlayVideo:(id)sender
{
    if (strVideurl.length == 0)
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
    else
    {
        NSURL *videoURL = [NSURL URLWithString:strVideurl];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        player.volume = 5.0;
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [playerViewController.player play];//Used to Play On start
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
}

/////////  MARK : -   Player Detail request response    ////////

-(void) GetPlayerVideoData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared playerVideoDetail:_strVideoMainID];
    
    
}
-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails :   %@",dicUserDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSMutableArray *video_detail = [[NSMutableArray alloc] init];
    video_detail = [result valueForKey:@"video_detail"];
    

    for (NSDictionary *dic in video_detail)
    {
        [_IBImageViewThumb sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"thumbnail_path"]] placeholderImage:[UIImage imageNamed:@"noimage"]];
        _IBTextFieldCreatedDate.text = [dic valueForKey:@"create_date"];
        _IBTextFieldSportType.text = [dic valueForKey:@"sport_type"];
        _IBTextFieldTitle.text = [dic valueForKey:@"title"];
         strVideurl = [dic valueForKey:@"file_path"];
        _IBTextViewReview.text = [dic valueForKey:@"notes"];
         strvideoID = [dic valueForKey:@"id"];
        
        
        _IBLabelAuthorName.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"player_name"]];
        

        if (_IBLabelAuthorName.text.length ==0)
        {
            _IBLabelAuthor.text = @"";
            if ([[dic valueForKey:@"coach_id"] isEqualToString:@""])
            {
                _IBLabelReviewer.text = @"";
                _IBLabelReviewerName.text = @"";
            }
            else
            {
                _IBLabelAuthor.text = @"MTC COACH";
                _IBLabelAuthorName.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"coach_name"]];
            }
            
        }
        else
        {
            _IBLabelAuthor.text = @"PLAYER";
            if ([[dic valueForKey:@"coach_id"] isEqualToString:@""])
            {
                _IBLabelReviewer.text = @"";
                _IBLabelReviewerName.text = @"";
            }
            else
            {
                _IBLabelReviewer.text = @"MTC COACH";
                _IBLabelReviewerName.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"coach_name"]];
            }
            
        }

        
         _IBTextEditTitle.text = [dic valueForKey:@"title"];
        _IBTextEditNotes.text = [dic valueForKey:@"notes"];
        
        if(_IBTextEditNotes.text.length == 0)
        {
            _IBLabelNote.hidden = NO;
        }
        else
        {
            _IBLabelNote.hidden = YES;
        }

        
        NSLog(@"Coacch_id=%@",[dic valueForKey:@"coach_id"]);
        
        appDelegate.strFilterTitle =  [dic valueForKey:@"title"];
        appDelegate.strFilterSportType =  _IBTextFieldSportType.text;
        appDelegate.strFilterNotes =  _IBTextViewReview.text;
        
        appDelegate.strPlayerSendThumb = [dic valueForKey:@"thumbnail"];
        appDelegate.strPlayerSendThumbPath = [dic valueForKey:@"thumbnail_path"];
        appDelegate.strPlayerSendVideo = [dic valueForKey:@"file_name"];
        appDelegate.strPlayerSendVideoPath = [dic valueForKey:@"file_path"];
        strCoachID = [dic valueForKey:@"coach_id"];
        
        
        if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"] && strCoachID.length != 0)
        {
            _IBButtonUpload.enabled = NO;
            _IBButtonUpload.alpha = 0.5;
        }
        else
        {
            _IBButtonUpload.enabled = YES;
            _IBButtonUpload.alpha = 1.0;
        }

    }
}

- (IBAction)IBButtonClickDelete:(id)sender
{
    if (appDelegate.strVideoRandId.length != 0)
    {
        [self.connectionManager cancel];
        NSLog(@"Did cancel connection");
        self.connectionManager = nil;
        NSLog(@"Did release connection");
        
         appDelegate.strVideoRandId = @"";
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        [shared DeleteVideo:strvideoID playerid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@""];
       

    }
  
}



- (IBAction)IBButtonClickReview:(id)sender
{
//    if (appDelegate.strPlayerstrVideoPath.length != 0)
//    {
//        VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
//        [self presentViewController: vdp animated: NO completion: nil];
//
//    }
    
    VideoFilterPage *vdp = [[VideoFilterPage alloc]initWithNibName:@"VideoFilterPage" bundle:nil ];
    appDelegate.strPlayerstrVideoPath = strVideurl;
    [self presentViewController:vdp animated: NO completion: nil];
    
}
- (IBAction)IBButtonClickUpload:(id)sender
{

    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate =self;
    
//    if (appDelegate.strVideoRandId.length == 0)
//    {
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        if (_IBTextEditTitle.text.length ==0 || [[_IBTextEditTitle.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter valid title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        }else{
            
            if (self.isEditingMode) {
                
                [shared UpdateVideoDetail:_strVideoMainID title:_IBTextEditTitle.text notes:_IBTextEditNotes.text];
            } else {
                int randomID = arc4random() % 90000 + 10000;
                NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];

                if ([shared currentUserTypePlayer]) {
                    
                    [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@"" title:_IBTextEditTitle.text notes :_IBTextEditNotes.text videoreq :@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewThumb.image];
                } else{
                    
                    [shared sendNotificationWithVideotoPlayer:@"" coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:_IBTextEditTitle.text notes :_IBTextEditNotes.text videoreq:@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewThumb.image];
                }
//                [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@"" title:_IBTextEditTitle.text notes :_IBTextEditNotes.text videoreq :@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewThumb.image];
            }
        }
}

-(void) CallUpdateVideoDetailAPI
{
    @try
    {
        NSError *error;
        NSString  *escapedUrlString =[NSString stringWithFormat:@"%@video_details_update.php?video_id=%@&title=%@&notes=%@",global_url,strvideoID,_IBTextEditTitle.text,_IBTextEditNotes.text];
        NSLog(@"escapedUrlString : %@",escapedUrlString);
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:escapedUrlString]];
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"json: %@", json);
        
    } @catch (NSException *exception) {
        
    }
    
    [appDelegate stopLoadingview];
    
    [_IBButtonUpload setTitle:@"SEND" forState:UIControlStateNormal];
    _IBViewEdit.hidden = YES;
    [self performSelector:@selector(GetPlayerVideoData) withObject:nil afterDelay:0.1];
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            if (appDelegate.strVideoRandId.length == 0)
            {
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
                
                
                NSLog(@"IDS===%@==%@===%@===%@===%@===%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
                
                int randomID = arc4random() % 90000 + 10000;
                NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
                
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
                [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq :@"Capture" sporttype:appDelegate.strFilterSportType randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
                
            }
            else
            {
                
                NSLog(@"IDS===%@==%@===%@===%@===%@===%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
                
                NSLog(@"Paths===%@==%@===%@===%@===",appDelegate.strPlayerSendVideo,appDelegate.strPlayerSendVideoPath,appDelegate.strPlayerSendThumb,appDelegate.strPlayerSendThumbPath
                      );
                
                SharedClass *shared =[SharedClass sharedInstance];
                shared.delegate =self;
                [shared sendNotificationwithPath:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:appDelegate.strFilterTitle notes:appDelegate.strFilterNotes videoreq:@"Review" sporttype:appDelegate.strFilterSportType randid:appDelegate.strVideoRandId videofilename:appDelegate.strPlayerSendVideo videofile:appDelegate.strPlayerSendVideoPath thumbname:appDelegate.strPlayerSendThumb thumb:appDelegate.strPlayerSendThumbPath];
            }
            
            
            
            
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
        appDelegate.strFilterTitle = @"";
        appDelegate.strFilterSportType = @"";
        appDelegate.strFilterNotes = @"";
        if (appDelegate.strVideoRandId.length != 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOUR VIDEO HAS BEEN SENT" message:[NSString stringWithFormat:@"Once your video has been reviewed by your coach, You will be Charged and your reviewed video will show up under your “Videos” tab in your profile"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];

        }
        
        appDelegate.isReviewed = YES;
        [self IBButtonClickBack:nil];
    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    appDelegate.strPlayerstrVideoPath = @"";
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"])
    {
        appDelegate.strFilterSportType = [actionSheet buttonTitleAtIndex:buttonIndex];
        appDelegate.strFilterTitle = _IBTextFieldTitle.text;
        appDelegate.strFilterNotes = _IBTextViewReview.text;
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[actionSheet buttonTitleAtIndex:buttonIndex] forKey:@"SportType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CoachesPage *cp = [storyboard instantiateViewControllerWithIdentifier:@"CoachesPage"];
        [self.navigationController pushViewController:cp animated:YES];

    }
   
    
    
}

-(void)getUserDetails2:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    [_IBButtonUpload setTitle:@"SEND" forState:UIControlStateNormal];
    _IBViewEdit.hidden = YES;
    [self performSelector:@selector(GetPlayerVideoData) withObject:nil afterDelay:0.1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
