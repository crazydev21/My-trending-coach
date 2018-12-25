//
//  CoachVideoDetail.m
//  My Trending Coach
//
//  Created by Nisarg on 22/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "CoachVideoDetail.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "VideoDetailPage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PlayerListPage.h"
#import <MediaPlayer/MediaPlayer.h>


@interface CoachVideoDetail ()

@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;

@end

@implementation CoachVideoDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strVideurl = [[NSString alloc]init ];
    
     _IBTextEditTitle.layer.sublayerTransform = CATransform3DMakeTranslation(5.0, 0, 0);
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        
//        CGSize result = [[UIScreen mainScreen] bounds].size;
//        
//        if (result.height == 480 || result.height == 568) {_IBLayoutViewHeight.constant = 150;}
//        
//        else if (result.height == 667) {_IBLayoutViewHeight.constant = 200;}
//        
//        else if (result.height >= 736) {_IBLayoutViewHeight.constant = 220;}
//    }

    if (appDelegate.strVideoRandId.length == 0)
    {
        _IBViewEdit.hidden = NO;
        _IBButtonReview.enabled = YES;
        [_IBButtonReview setTitle:@"REVIEW" forState:UIControlStateNormal];
        
        _IBButtonUpload.enabled = YES;
        [_IBButtonUpload setTitle:@"SAVE" forState:UIControlStateNormal];
        
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

   
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)IBButtonClickEdit:(id)sender
{
    [_IBButtonUpload setTitle:@"SAVE" forState:UIControlStateNormal];
    _IBViewEdit.hidden = NO;
    
    if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"] && appDelegate.strPlayerId.length ==0)
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
    

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (appDelegate.isReviewed || appDelegate.isSaved)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)IBButtonClickBack:(id)sender
{
    if (appDelegate.strVideoRandId.length == 0)
    {
        [self.connectionManager cancel];
        NSLog(@"Did cancel connection");
        self.connectionManager = nil;
        NSLog(@"Did release connection");

        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SAVE"])
        {
            [_IBButtonUpload setTitle:@"SEND" forState:UIControlStateNormal];
            _IBViewEdit.hidden = YES;
            
        }
        else if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"])
        {
            [self.connectionManager cancel];
            NSLog(@"Did cancel connection");
            self.connectionManager = nil;
            NSLog(@"Did release connection");
            
            [self.navigationController popViewControllerAnimated:YES];

            
        }
        
        if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"] && appDelegate.strPlayerId.length ==0)
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
- (IBAction)IBButtonClickPlayVideo:(id)sender
{
    if (strVideurl.length != 0)
    {
        NSURL *videoURL = [NSURL URLWithString:strVideurl];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        player.volume = 5.0;
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [playerViewController.player play];//Used to Play On start
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
    else
    {
        AVAsset *avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:appDelegate.strPlayerstrVideoPath]];
        AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
        AVPlayer *avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
        avPlayer.volume = 5.0;
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = avPlayer;
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
        _IBTextFieldTitle.text = [[dic valueForKey:@"title"]uppercaseString ];
        strVideurl = [dic valueForKey:@"file_path"];
        _IBTextViewReview.text = [dic valueForKey:@"notes"];
        strvideoID = [dic valueForKey:@"id"];
        appDelegate.strPlayerId =  [dic valueForKey:@"player_id"];
        
 
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
        
        appDelegate.strFilterTitle =  [dic valueForKey:@"title"];
        appDelegate.strFilterSportType =  _IBTextFieldSportType.text;
        appDelegate.strFilterNotes =  _IBTextViewReview.text;
        
        appDelegate.strPlayerSendThumb = [dic valueForKey:@"thumbnail"];
        appDelegate.strPlayerSendThumbPath = [dic valueForKey:@"thumbnail_path"];
        appDelegate.strPlayerSendVideo = [dic valueForKey:@"file_name"];
        appDelegate.strPlayerSendVideoPath = [dic valueForKey:@"file_path"];
        
        appDelegate.strFilterSportType = _IBTextFieldSportType.text;
        appDelegate.strFilterTitle = _IBTextEditTitle.text;
        appDelegate.strFilterNotes = _IBTextEditNotes.text;
    }
    
    if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"] && appDelegate.strPlayerId.length ==0)
    {
        _IBButtonUpload.enabled = NO;
        _IBButtonUpload.alpha = 0.5;
    }
    else
    {
        _IBButtonUpload.enabled = YES;
        _IBButtonUpload.alpha = 1.0;
    }
    
    
    [self DownloadVideo];
   
      
    //    @try
    //    {
    //        _IBTextViewReview.text = [NSString stringWithFormat:@"Review: %@",[result valueForKey:@"review_text"]];
    //
    //        if ([_IBTextViewReview.text  rangeOfString:@"(null)"].location != NSNotFound || [_IBTextViewReview.text rangeOfString:@"<null>"].location != NSNotFound)
    //        {
    //            _IBTextViewReview.text = @"Review pending";
    //        }
    //
    //    }
    //    @catch (NSException *exception)
    //    {
    //        _IBTextViewReview.text = @"Review pending";
    //    }
    
}

- (IBAction)IBButtonClickDelete:(id)sender
{
    
    [self.connectionManager cancel];
    NSLog(@"Did cancel connection");
    self.connectionManager = nil;
    NSLog(@"Did release connection");
    
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared DeleteVideo:strvideoID playerid:@"" coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"]];
    
}
-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    appDelegate.isSaved = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)IBButtonClickReview:(id)sender
{
    if (appDelegate.strPlayerstrVideoPath.length != 0)
    {
        
        if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SAVE"])
        {
            appDelegate.strFilterTitle =  _IBTextEditTitle.text;
            appDelegate.strFilterNotes =  _IBTextEditNotes.text;
        }
        
        VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
        [self presentViewController: vdp animated: NO completion: nil];
    }
}

- (IBAction)IBButtonClickUpload:(id)sender
{
    
//    [self.connectionManager cancel];
//    NSLog(@"Did cancel connection");
//    self.connectionManager = nil;
//    NSLog(@"Did release connection");
    
    
    if (appDelegate.strVideoRandId.length == 0)
    {
        int randomID = arc4random() % 90000 + 10000;
        NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
      
        
        NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
        if (_IBTextEditTitle.text.length ==0 )
        {
            [appDelegate showAlertMessage:@"Please enter title"];
            
        }
        else if ([[_IBTextEditTitle.text stringByTrimmingCharactersInSet:charSet] isEqualToString:@""])
        {
            // it's empty or contains only white spaces
            [appDelegate showAlertMessage:@"Please enter valid title"];
        }
        else
        {
            SharedClass *shared = [SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotificationWithVideotoPlayer:@"" coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:_IBTextEditTitle.text notes :_IBTextEditNotes.text videoreq :@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:_IBImageViewThumb.image];
        }
    }
    else
    {
        if ([_IBButtonUpload.titleLabel.text isEqualToString:@"SEND"])
        {
//            PlayerListPage *mv =[[PlayerListPage alloc] initWithNibName:@"PlayerListPage" bundle:nil];
//            [self.navigationController pushViewController:mv animated:YES];
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotificationWithVideotoPlayerPath:appDelegate.strPlayerId coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:appDelegate.strFilterTitle notes:appDelegate.strFilterNotes videoreq:@"Review" sporttype:appDelegate.strFilterSportType randid:appDelegate.strVideoRandId videofilename:appDelegate.strPlayerSendVideo videofile:appDelegate.strPlayerSendVideoPath thumbname:appDelegate.strPlayerSendThumb thumb:appDelegate.strPlayerSendThumbPath];

        }
        else
        {
//            SharedClass *shared = [SharedClass sharedInstance];
//            shared.delegate =self;
//            [shared UpdateVideoDetail:strvideoID title:_IBTextEditTitle.text notes:_IBTextEditNotes.text];
            [appDelegate startLoadingview:@"Loading..."];
            [self performSelector:@selector(CallUpdateVideoDetailAPI) withObject:nil afterDelay:0.1];
            
        }
    }
}
    
-(void)getUserDetails2:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    [_IBButtonUpload setTitle:@"SEND" forState:UIControlStateNormal];
    _IBViewEdit.hidden = YES;
    [self performSelector:@selector(GetPlayerVideoData) withObject:nil afterDelay:0.1];
        
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


-(void)DownloadVideo
{
    self.downloadedMutableData = [[NSMutableData alloc] init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strVideurl]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
    self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
//    //download the file in a seperate thread.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"Downloading Started");
//        NSString *urlToDownload = strVideurl;
//        NSURL  *url = [NSURL URLWithString:urlToDownload];
//        NSData *urlData = [NSData dataWithContentsOfURL:url];
//        if ( urlData )
//        {
//            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString  *documentsDirectory = [paths objectAtIndex:0];
//            
//            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"DownloadLatest.mp4"];
//            NSLog(@"appDelegate.strPlayerstrVideoPathold=%@",appDelegate.strPlayerstrVideoPath);
//
//            //saving is done on main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [urlData writeToFile:filePath atomically:YES];
//                NSLog(@"File Saved !");
//                appDelegate.strPlayerstrVideoPath = filePath;
//                NSLog(@"appDelegate.strPlayerstrVideoPath=%@",appDelegate.strPlayerstrVideoPath);
////                VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
////                [self presentViewController: vdp animated: NO completion: nil];
//                
//                [appDelegate showAlertMessage:@"Downloading Completed"];
//
//            });
//        }
//        
//    });
}


#pragma mark - Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%lld", response.expectedContentLength);
    self.urlResponse = response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedMutableData appendData:data];
    self.IBProgressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)/100;
    if (self.IBProgressView.progress == 1) {
        self.IBProgressView.hidden = YES;
    } else {
        self.IBProgressView.hidden = NO;
    }
    NSLog(@"%.0f%%", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length));
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"DownloadLatest.mp4"];
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.downloadedMutableData length]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.downloadedMutableData writeToFile:filePath atomically:YES];
    self.IBProgressView.hidden = YES;
    
    _IBButtonReview.enabled = YES;
    [_IBButtonReview setTitle:@"REVIEW" forState:UIControlStateNormal];
    
     appDelegate.strPlayerstrVideoPath = filePath;
    
//    NSURL *outputFileUrl = [NSURL fileURLWithPath:filePath];
//    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:outputFileUrl
//                                completionBlock:^(NSURL *assetURL, NSError *error){
//                                    /*notify of completion*/
//                                    NSLog(@"Completed recording, file is stored at:  %@", filePath);
//                                }];
//    VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
//    [self presentViewController: vdp animated: NO completion: nil];

    NSLog(@"appDelegate.strPlayerstrVideoPath===%@",appDelegate.strPlayerstrVideoPath);
 

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
