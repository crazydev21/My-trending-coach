//
//  PlayerVideoListPage.m
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "PlayerVideoListPage.h"
#import "PlayerVideoDetailPage.h"
#import "PlayerVideoListCell.h"
#import "VideoDetailPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CoachesPage.h"

#import "VideoFilterPage.h"

@interface PlayerVideoListPage ()
{
    NSMutableArray *aryVideoList;
}
@property(retain, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIView *selectedTypeView;
@property (weak, nonatomic) IBOutlet UIButton *reviewedButton;
@property (weak, nonatomic) IBOutlet UIButton *pendingButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;

@end

@implementation PlayerVideoListPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_IBtableView registerNib:[UINib nibWithNibName:@"PlayerVideoListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [_IBtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Do any additional setup after loading the view from its nib.
    NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login"];
    self.selectedTypeView.hidden = [type isEqualToString:@"Player"];
    
    if(self.selectedTypeView.hidden)
        self.tableViewConstraint.constant = 15;
    else
        self.tableViewConstraint.constant = 65;
        
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    //    if #available(iOS 10.0, *) {
    //        _IBtbleView.refreshControl = refreshControl
    //    } else {
    
    _IBtableView.backgroundView = self.refreshControl;
    
    //    }
    [self setNeedsStatusBarAppearanceUpdate];
    
//    [self onPendingButton:nil];
}


- (void)reloadData
{
    // Reload table data
    [self.refreshControl endRefreshing];
    [self IBButtonClickCaptured:0];

    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self onReviewedButton:nil];
}

- (IBAction)IBButtonClickBack:(id)sender{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)IBButtonClickCaptured:(id)sender{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared playerVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Player" video_request:@"Capture" usertypevideo:@"Player"];
}

- (IBAction)IBButtonClickReview:(id)sender{
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared playerVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Player" video_request:@"Review" usertypevideo:@"Coach"];
}

- (IBAction)IBButtonClickEdited:(id)sender
{
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared playerVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Player" video_request:@"Edited" usertypevideo:@"Player"];
}


/////////  MARK : -   Player Detail request response    ////////


-(void)getUserDetails:(NSDictionary *)dicUserDetials
{
    NSLog(@"getUserDetails :   %@",dicUserDetials);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicUserDetials valueForKey:@"result"];
    
    NSMutableArray *video_list = [[NSMutableArray alloc] init];
    video_list = [result valueForKey:@"video_list"];
    
    aryVideoList = [[NSMutableArray alloc] init];
    aryVideoList = [result valueForKey:@"video_list"];
    
    arythumb = [[NSMutableArray alloc] init];
    aryVideo = [[NSMutableArray alloc] init];
    arySportType = [[NSMutableArray alloc] init];
    aryRandId = [[NSMutableArray alloc] init];
    aryTitle = [[NSMutableArray alloc] init];
    arySubTitle = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in video_list)
    {
        
        NSString *str = [NSString stringWithFormat:@"%@",[dic valueForKey:@"file_path"]];
      //  NSLog(@"str=%@",str);
        if ([str rangeOfString:@".mp4"].location != NSNotFound || [str rangeOfString:@".mov"].location != NSNotFound || [str rangeOfString:@".3gp"].location != NSNotFound)
        {
            [arythumb addObject:[dic valueForKey:@"thumbnail_path"]];
            [aryVideo addObject:[dic valueForKey:@"file_path"]];
            [arySportType addObject:[dic valueForKey:@"sport_type"]];
            [aryRandId addObject:[dic valueForKey:@"random_id"]];
            [aryTitle addObject:[dic valueForKey:@"title"]];
            [arySubTitle addObject:[dic valueForKey:@"subtitle"]];
        }
    }
    NSLog(@"aryTitle :   %@",aryTitle);
//    NSLog(@"arythumb :   %@",arythumb);
//    NSLog(@"arySportType :   %@",arySportType);
    [_IBtableView reloadData];

}


/////////  MARK : -  TableView Methods      ////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return aryVideo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak PlayerVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerVideoListCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.IBLabelAuthorName.text = @"";
    cell.IBLabelReviewed.text = @"";
    cell.IBImageViewthumb.image = [UIImage imageNamed:@"noimage"];
    
    cell.settingsView.hidden = YES;
    
    [cell.IBImageViewthumb sd_setImageWithURL:[NSURL URLWithString:[arythumb objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.IBLabeltitle.text = [[NSString stringWithFormat:@"%@",[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"title"]]uppercaseString ];
    cell.IBLabelAuthorName.text = [NSString stringWithFormat:@"%@",[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"player_name"]];
    
    cell.IBLabelDateTime.text = [NSString stringWithFormat:@"%@",[self GetDate:[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"create_date"]]];
    
    cell.IBLabelReviewed.text = [NSString stringWithFormat:@"%@",[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"notes"]];
    
    cell.sendButton.hidden = [[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"video_request"] isEqualToString:@"Review"];
    
    cell.videoValue = [aryVideoList objectAtIndex:indexPath.row];
    
    cell.didEdit = ^{
        
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =self;
        if ([shared currentUserTypePlayer]) {
            
            appDelegate.strVideoRandId = [aryRandId objectAtIndex:indexPath.row];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            PlayerVideoDetailPage *vdp = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVideoDetailPage"];
            vdp.strVideoMainID = [[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"id"];
            vdp.isEditingMode = YES;
            
            [self presentViewController:vdp animated:YES completion:nil];
        } else{
            
            NSDictionary *dic = [aryVideoList objectAtIndex:indexPath.row];
            NSString *strVideurl = [dic valueForKey:@"file_path"];
            
            [self downloadVideoAtURL:strVideurl block:^(NSURL *localURL) {
                
                VideoFilterPage *vdp = [[VideoFilterPage alloc]initWithNibName:@"VideoFilterPage" bundle:nil ];
                appDelegate.strPlayerstrVideoPath = localURL.path;//strVideurl;
                [self presentViewController:vdp animated: NO completion: nil];
            }];
             
        }
    };
    
    __weak typeof(self) weakSelf = self;
    cell.didReloadData = ^{
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate = weakSelf;

        [shared sendNotificationwithPath:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"CoachID"] title:[cell.videoValue valueForKey:@"title"] notes:[cell.videoValue valueForKey:@"notes"] videoreq:@"Capture" sporttype:[cell.videoValue valueForKey:@"sport_type"] randid:[cell.videoValue valueForKey:@"random_id"] videofilename:[cell.videoValue valueForKey:@"file_name"] videofile:[cell.videoValue valueForKey:@"file_path"] thumbname:[cell.videoValue valueForKey:@"thumbnail_path"] thumb:[cell.videoValue valueForKey:@"thumbnail_path"]];
        
    };
   
    cell.didDelete = ^{
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate =weakSelf;
        
        NSDictionary* video = [aryVideoList objectAtIndex:indexPath.row];
        NSString *videoId = [video valueForKey:@"id"];
        NSString * playerId = [video objectForKey:@"player_id"];
        NSString * coachId = [video objectForKey:@"coach_id"];
        
        [shared DeleteVideo:videoId playerid:playerId coachid:coachId];
    };
    
    cell.didSettings = ^{
        cell.settingsView.hidden = !cell.settingsView.hidden;
    };
    
    return cell;
}

-(void)downloadVideoAtURL:(NSString*)videoUrl block:(void(^)(NSURL* localURL))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *yourVideoData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
        
        if (yourVideoData) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"tempvideo.mp4"];
            
            if([yourVideoData writeToFile:filePath atomically:YES]) {
                NSLog(@"write successfull");
            } else{
                NSLog(@"write failed");
            }
            if (block) {
                NSURL* url = [NSURL URLWithString:filePath];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    block(url);
                });
            }
        } else{
            if (block) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    block(nil);
                });
            }
        }
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 345;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [aryVideoList objectAtIndex:indexPath.row];
    
    NSString *strVideurl = [dic valueForKey:@"file_path"];
    
//    changeVideoStatus
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared changeVideoStatus:@"Review" requestid:[dic valueForKey:@"id"]];
    
    NSURL *videoURL = [NSURL URLWithString:strVideurl];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    player.volume = 5.0;
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [playerViewController.player play];//Used to Play On start
    [self presentViewController:playerViewController animated:YES completion:nil];
}
- (IBAction)IBButtonCaptureVideo:(id)sender
{
    
    UIAlertController* alertAS = [UIAlertController alertControllerWithTitle:@"Select option:"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* CameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSLog(@"Camera");
                                                    
                                                            [self VideoCameraOpen];
                                                           
                                                       }];
    UIAlertAction* GalleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSLog(@"Gallery");
                                    
                                                            [self VideoGalleryOpen];
                                                         }];
    
    [alertAS addAction:CameraAction];
    [alertAS addAction:GalleryAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertAS addAction:cancleAction];
    [self presentViewController:alertAS animated:YES completion:nil];

    
    // [self VideoCameraOpen];
    
}


-(NSString *) GetDate:(NSString *)string
{
    NSString *myString = string;;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"MMM dd - hh:mm";
    NSLog(@"yourDate%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

-(void) VideoCameraOpen
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
    else
    {
        [[[[iToast makeText:NSLocalizedString(@"Place camera horizontal.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationLong] show];
        
        [self startCameraControllerFromViewController: self
                                        usingDelegate: self];
    }
    
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    [cameraUI setVideoMaximumDuration:15.0f];
    cameraUI.allowsEditing = YES;
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

-(void) VideoGalleryOpen
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setVideoMaximumDuration:15.0f];
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        appDelegate.strPlayerstrVideoPath = [[NSString alloc]init ];
        appDelegate.strPlayerstrVideoPath = [videoUrl path];
        NSLog(@"strPlayerstrVideoPath=%@",appDelegate.strPlayerstrVideoPath);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self performSelector:@selector(Goto) withObject:nil afterDelay:0.1];
}

-(void)Goto
{
    appDelegate.strVideoRandId = @"";
    appDelegate.strPlayerId = @"";
    appDelegate.strFilterTitle = @"";
    appDelegate.strFilterSportType = @"";
    appDelegate.strFilterNotes = @"";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    PlayerVideoDetailPage *vdp = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVideoDetailPage"];
    [self presentViewController:vdp animated:YES completion:nil];

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


-(void)SaveVideo
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
    

    
    int randomID = arc4random() % 90000 + 10000;
    NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
    
    
    int randomID1 = arc4random() % 999 + 100;
    NSString *strFileName = [NSString stringWithFormat:@"Image%d",randomID1];
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared sendNotification:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] coachid:@"" title:strFileName notes :@"" videoreq :@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];

    
    
    
}

-(void)getUserDetails_PlayerDetail:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails  :   %@",dicVideoDetials);
    
    [appDelegate stopLoadingview];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    [self reloadData];
    
    [self.IBtableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    int codevalue = [code intValue];
    
//    if (codevalue == 1)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//
//        PlayerVideoDetailPage *vdp = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVideoDetailPage"];
//        [self presentViewController:vdp animated:YES completion:nil];
//    }
//    else
//    {
//        [appDelegate showAlertMessage:message];
//    }
}

- (IBAction)onBack:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onPendingButton:(id)sender{
    [self.pendingButton setAlpha:1.0f];
    [self.reviewedButton setAlpha:0.7f];
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared CoachVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Coach" video_request:@"Capture" usertypevideo:@"Coach"];
}

- (IBAction)onReviewedButton:(id)sender{
    [self.pendingButton setAlpha:0.7f];
    [self.reviewedButton setAlpha:1.0f];
    
    //player
    NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login"];
    if([type isEqualToString:@"Player"]){
        [self IBButtonClickCaptured:nil];
    }else{
        SharedClass *shared =[SharedClass sharedInstance];
        shared.delegate = self;
        [shared CoachVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Coach" video_request:@"Review" usertypevideo:@"Coach"];
    }
}

#pragma mark -

-(void)getUserDetails8:(NSDictionary *)dicVideoDetials{
    
    [self onReviewedButton:nil];
}

@end
