//
//  CoachVideoListPage.m
//  My Trending Coach
//
//  Created by Nisarg on 22/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "CoachVideoListPage.h"
#import "PlayerVideoListCell.h"
#import "CoachVideoDetail.h"
#import "VideoDetailPage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerListPage.h"

@interface CoachVideoListPage ()
{
    NSMutableArray *aryVideoList;
    NSString *strCheck;
}
@property(retain, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CoachVideoListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strCheck = @"Reviewed";
    [self IBButtonClickReview:0];
    
    [_IBtableView registerNib:[UINib nibWithNibName:@"PlayerVideoListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [_IBtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Do any additional setup after loading the view from its nib.
    
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
}


- (void)reloadData
{
    // Reload table data
    [self.refreshControl endRefreshing];
    
    if ([strCheck isEqualToString:@"Captured"])
    {
        [self IBButtonClickCaptured:0];
    }
    else
    {
         [self IBButtonClickReview:0];
    }
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (appDelegate.isReviewed)
    {
        appDelegate.isReviewed = NO;
        [self IBButtonClickReview:0];
    }
    else if (appDelegate.isSaved == YES || appDelegate.isSavedAgain == YES)
    {
        appDelegate.isSaved = NO;
        appDelegate.isSavedAgain = NO;
        [self IBButtonClickCaptured:0];
    }
 
    
}
- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)IBButtonClickCaptured:(id)sender
{
    strCheck = @"Captured";
    _IBImageCaptureTab.hidden = NO;
    _IBImageReviewTab.hidden = YES;
    _IBImageEditedTab.hidden = YES;
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared CoachVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Coach" video_request:@"Capture" usertypevideo:@"Coach"];
}

- (IBAction)IBButtonClickReview:(id)sender
{
    strCheck = @"Reviewed";
    _IBImageReviewTab.hidden = NO;
    _IBImageCaptureTab.hidden = YES;
    _IBImageEditedTab.hidden = YES;
    
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared CoachVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Coach" video_request:@"Review" usertypevideo:@"Player"];
}

- (IBAction)IBButtonClickEdited:(id)sender
{
    _IBImageReviewTab.hidden = YES;
    _IBImageCaptureTab.hidden = YES;
    _IBImageEditedTab.hidden = NO;

    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared CoachVideoList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] usertype:@"Coach" video_request:@"Edited" usertypevideo:@"Coach"];
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
    static NSString *cellIdentifier = @"Cell";
    PlayerVideoListCell *cell = (PlayerVideoListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If there is no cell to reuse, create a new one
    if(cell == nil)
    {
        cell = [[PlayerVideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.IBLabelAuthorName.text = @"";
    cell.IBLabelReviewed.text = @"";

    [cell.IBImageViewthumb sd_setImageWithURL:[NSURL URLWithString:[arythumb objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.IBLabeltitle.text = [[NSString stringWithFormat:@"%@",[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"title"]]uppercaseString ];
    
    @try
    {
         cell.IBLabelDateTime.text = [NSString stringWithFormat:@"%@",[self GetDate:[[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"update_date"]]];
    }
    @catch (NSException *exception)
    {
         cell.IBLabelDateTime.text = @"";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.strVideoRandId = [aryRandId objectAtIndex:indexPath.row];
    
    CoachVideoDetail *cp = [[CoachVideoDetail alloc]initWithNibName:@"CoachVideoDetail" bundle:nil ];
    cp.strVideoMainID = [[aryVideoList objectAtIndex:indexPath.row]valueForKey:@"id"];
    [self.navigationController pushViewController:cp animated:YES];
    
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


- (IBAction)IBButtonCaptureVideo:(id)sender
{
//    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                            @"Camera",
//                            @"Gallery",
//                            nil];
//    popup.tag = 1;
//    [popup showInView:self.view];
    
    // [self VideoCameraOpen];
    
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
    
}

//- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//    switch (popup.tag) {
//        case 1: {
//            switch (buttonIndex) {
//                case 0:
//                    [self VideoCameraOpen];
//                    break;
//                case 1:
//                    [self VideoGalleryOpen];
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
//     
//        default:
//            break;
//    }
//}


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
        //        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //        picker.delegate = self;
        //        picker.allowsEditing = YES;
        //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //
        //        [self presentViewController:picker animated:YES completion:NULL];

        [[[[iToast makeText:NSLocalizedString(@"Place camera horizontal.", @"")]
           setGravity:iToastGravityCenter] setDuration:iToastDurationLong] show];

        [self startCameraControllerFromViewController: self
                                        usingDelegate: self];
    }

}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
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
        
        NSError *error;
        NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:videoUrl.path error:&error];
        NSNumber * size = [properties objectForKey: NSFileSize];
        NSLog(@"size=%@",size);
        NSString *strsize = [
                             NSString stringWithFormat: @"%d",(int)round([size doubleValue] / 1024)];
        NSLog(@"strsize=%@",strsize);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self performSelector:@selector(Goto) withObject:nil afterDelay:0.5];
   
}

-(void)Goto
{
    appDelegate.strVideoRandId = @"";
    appDelegate.strPlayerId = @"";
    appDelegate.strFilterTitle = @"";
    appDelegate.strFilterSportType = @"";
    appDelegate.strFilterNotes = @"";

    CoachVideoDetail *vdp = [[CoachVideoDetail alloc]initWithNibName:@"CoachVideoDetail" bundle:nil ];
    [self.navigationController pushViewController:vdp animated:YES];


//   
//    UIAlertController* alertAS = [UIAlertController alertControllerWithTitle:@"Select option:"
//                                                                     message:nil
//                                                              preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction* SaveAction = [UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              NSLog(@"SAVE");
//                                                              CaptureTag =1;
//                                                              [self performSelector:@selector(SaveVideo) withObject:nil afterDelay:0.5];
//                        
//                                                          }];
//    UIAlertAction* ReviewAction = [UIAlertAction actionWithTitle:@"REVIEW" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              NSLog(@"REVIEW");
//                                                              
//                                                              appDelegate.strFilterTitle = @"";
//                                                              appDelegate.strFilterSportType = @"";
//                                                              appDelegate.strFilterNotes = @"";
//
//                                                              CaptureTag =2;
//                                                              [self performSelector:@selector(SaveVideo) withObject:nil afterDelay:0.5];
//                                                          }];
//
//    UIAlertAction* UploadAction = [UIAlertAction actionWithTitle:@"UPLOAD" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              NSLog(@"UPLOAD");
//                                                              
//                                                              appDelegate.strFilterTitle = @"";
//                                                              appDelegate.strFilterSportType = @"";
//                                                              appDelegate.strFilterNotes = @"";
//
//                                                              CaptureTag =3;
//                                                              [self performSelector:@selector(SaveVideo) withObject:nil afterDelay:0.5];
//
//                                                          }];
//
//    [alertAS addAction:SaveAction];
//    [alertAS addAction:ReviewAction];
//    [alertAS addAction:UploadAction];
//    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    [alertAS addAction:cancleAction];
//    [self presentViewController:alertAS animated:YES completion:nil];

 
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
    [shared sendNotificationWithVideotoPlayer:@"" coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:strFileName notes :@"" videoreq :@"Capture" sporttype:@"" randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
    

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
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        appDelegate.isSavedAgain = YES;
        
        if (CaptureTag == 2)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CoachID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            VideoDetailPage *vdp = [[VideoDetailPage alloc]initWithNibName:@"VideoDetailPage" bundle:nil ];
            [self presentViewController: vdp animated: NO completion: nil];
            
        }
        else if (CaptureTag == 3)
        {
            PlayerListPage *mv =[[PlayerListPage alloc] initWithNibName:@"PlayerListPage" bundle:nil];
            [self.navigationController pushViewController:mv animated:YES];

        }
        else
        {
            [self IBButtonClickCaptured:0];
        }
        
        CaptureTag = 0;

    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
}




@end
