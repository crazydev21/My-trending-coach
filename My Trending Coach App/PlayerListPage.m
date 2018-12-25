//
//  PlayerListPage.m
//  My Trending Coach
//
//  Created by Nisarg on 17/05/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "PlayerListPage.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerListPage ()

@end

@implementation PlayerListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self GetPlayerListData];
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

- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/////////  MARK : - Get Coach List      ////////

-(void)GetPlayerListData
{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared PlayerList];
}

-(void)getUserDetails:(NSDictionary *)dicVideoDetials
{
    NSLog(@"getUserDetails_PlayerDetail  :   %@",dicVideoDetials);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    result = [dicVideoDetials valueForKey:@"result"];
    
    NSMutableArray *information = [[NSMutableArray alloc] init];
    information = [result valueForKey:@"player information"];
    
    NSString *code = [[NSString alloc] init];
    code = [result valueForKey:@"code"];
    
    NSString *message = [[NSString alloc] init];
    message = [result valueForKey:@"message"];
    
    
    
    int codevalue = [code intValue];
    
    if (codevalue == 1)
    {
        
      
            aryID = [[NSMutableArray alloc] init];
            aryID = [information valueForKey:@"id"];
            
            aryName = [[NSMutableArray alloc] init];
            aryName = [information valueForKey:@"name"];
            
            aryImages = [[NSMutableArray alloc] init];
            aryImages = [information valueForKey:@"photo"];
        
            aryImagesPath = [[NSMutableArray alloc] init];
            aryImagesPath = [information valueForKey:@"photo_path"];
        
            arySportType = [[NSMutableArray alloc] init];
            arySportType = [information valueForKey:@"sport_type"];
  
          //  NSLog(@"arySportType=%@",arySportType);
          //  NSLog(@"aryName=%@",aryName);
        
        
        [self LoadScrollView];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; [alert show];
       
    }
    
    
}



/////////  MARK : -  Coch Listing Design Method      ////////

- (void) LoadScrollView
{
    //    UIImageView *backgimg =[[UIImageView alloc] initWithFrame: CGRectMake( 0, 0, _IBScrollView.frame.size.width, _IBScrollView.frame.size.height+(aryImages.count*100) )];
    //    backgimg.image = [UIImage imageNamed:@"choches_bg"];
    //    [_IBScrollView addSubview:backgimg];
    
    int x=20, y=20;
    
    
    for (UIView *v in _IBScrollView.subviews) {
        [v removeFromSuperview];
    }
    
    
    
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //
    //        CGSize result = [[UIScreen mainScreen] bounds].size;
    //
    //        if (result.height == 480 || result.height == 568) {x =30;}
    //
    //        else if (result.height == 667) {x =45;}
    //
    //        else if (result.height >= 736) {x =55;}
    //    }
    
    
    //    NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
    //    NSArray *textary = [[NSArray alloc]initWithObjects:@"TENNIS",@"GOLF",@"BASEBALL",@"FOOTBALL",@"WRESTLING",@"CRICKET",@"PERSONAL TRAINER",@"OTHERS", nil ];
    
    for (int i = 0 ; i<aryImages.count; i++)
    {
        
        
        CGRect buttonFrame = CGRectMake( x, y, self.view.frame.size.width /2 -40, self.view.frame.size.width /2);
        UIView *view =[[UIView alloc] initWithFrame:buttonFrame];
        view.backgroundColor = [UIColor clearColor];
        [_IBScrollView addSubview:view];
        
        
        UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, view.frame.size.width, view.frame.size.height-35)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[aryImagesPath objectAtIndex:i],[aryImages objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
        //img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[aryImages objectAtIndex:i]]];
        img.contentMode = UIViewContentModeScaleToFill;
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 2.0;
        [view addSubview:img];
        
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, img.frame.size.height+5, view.frame.size.width, 25)];
        fromLabel.text = [[NSString stringWithFormat:@"%@",[aryName objectAtIndex:i]]uppercaseString ];
        fromLabel.font = [UIFont fontWithName:@"EurostileRoundW00-Bold" size:15];
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor whiteColor];
        fromLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:fromLabel];
        
        
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(  0, 0, view.frame.size.width, view.frame.size.height-35 )];
        // [button setTitle: @"My Button" forState: UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        button.tag = i;
        [view addSubview:button];
        
        
        
        x += self.view.frame.size.width /2;
        
        if (x > [[UIScreen mainScreen] bounds].size.width-10) {
            
            //            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            //
            //                CGSize result = [[UIScreen mainScreen] bounds].size;
            //
            //                if (result.height == 480 || result.height == 568) {x =20;}
            //
            //                else if (result.height == 667) {x =20;}
            //
            //                else if (result.height >= 736) {x =20;}
            //            }
            
            x = 20;
            y += self.view.frame.size.width /2+10;
        }
        
        
        if (aryImages.count % 2)
        {
            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y+self.view.frame.size.width /2+10)];
        }
        else
        {
            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y)];
        }
        
        
    }
    
    [appDelegate stopLoadingview];
}
//- (void) LoadScrollView
//{
//    //    UIImageView *backgimg =[[UIImageView alloc] initWithFrame: CGRectMake( 0, 0, _IBScrollView.frame.size.width, _IBScrollView.frame.size.height+(aryImages.count*100) )];
//    //    backgimg.image = [UIImage imageNamed:@"choches_bg"];
//    //    [_IBScrollView addSubview:backgimg];
//    
//    int x=30, y=10;
//    
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        
//        CGSize result = [[UIScreen mainScreen] bounds].size;
//        
//        if (result.height == 480 || result.height == 568) {x =30;}
//        
//        else if (result.height == 667) {x =45;}
//        
//        else if (result.height >= 736) {x =55;}
//    }
//    
//    
//    //    NSArray *imgary = [[NSArray alloc]initWithObjects:@"Tennis",@"golf",@"baseball",@"football",@"wrestling",@"cricket",@"personal-trainer",@"Others", nil ];
//    //    NSArray *textary = [[NSArray alloc]initWithObjects:@"TENNIS",@"GOLF",@"BASEBALL",@"FOOTBALL",@"WRESTLING",@"CRICKET",@"PERSONAL TRAINER",@"OTHERS", nil ];
//    
//    for (int i = 0 ; i<aryImages.count; i++)
//    {
//        
//        
//        CGRect buttonFrame = CGRectMake( x, y, 100, 75);
//        UIView *view =[[UIView alloc] initWithFrame:buttonFrame];
//        view.backgroundColor = [UIColor whiteColor];
//        [_IBScrollView addSubview:view];
//        
//        NSLog(@"images=%@",[NSString stringWithFormat:@"%@/%@",[aryImagesPath objectAtIndex:i],[aryImages objectAtIndex:i]]);
//        
//        UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake( 2, 2, 96, 71)];
//        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[aryImagesPath objectAtIndex:i],[aryImages objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"noimage"]];
//
//        //img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[aryImages objectAtIndex:i]]];
//        img.contentMode = UIViewContentModeScaleToFill;
//        
//        [view addSubview:img];
//        
//        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 100, 25)];
//        fromLabel.text = [NSString stringWithFormat:@"%@",[aryName objectAtIndex:i]];
//        fromLabel.font = [UIFont fontWithName:@"Arvo" size:12];
//        fromLabel.backgroundColor = [UIColor blackColor];
//        fromLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:77.0/255.0 blue:1.0/255.0 alpha:1.0];
//        fromLabel.textAlignment = NSTextAlignmentCenter;
//        [view addSubview:fromLabel];
//        
//        
//        
//        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 100, 75 )];
//        // [button setTitle: @"My Button" forState: UIControlStateNormal];
//        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgary objectAtIndex:i]]] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(ButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//        //        [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
//        button.tag = i;
//        [view addSubview:button];
//        
//        
//        
//        x += [[UIScreen mainScreen] bounds].size.width/2;
//        
//        if (x > [[UIScreen mainScreen] bounds].size.width-10) {
//            
//            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//                
//                CGSize result = [[UIScreen mainScreen] bounds].size;
//                
//                if (result.height == 480 || result.height == 568) {x =30;}
//                
//                else if (result.height == 667) {x =45;}
//                
//                else if (result.height >= 736) {x =55;}
//            }
//            
//            y += 120;
//        }
//        
//        
//        if (aryImages.count % 2)
//        {
//            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y+120)];
//        }
//        else
//        {
//            [_IBScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, y)];
//        }
//        
//        
//    }
//}

-(void)ButtonClickEvent:(UIButton*)btn
{
    
    NSInteger iTag  = btn.tag;
    NSLog(@"iTag %ld   %@", (long)iTag,[aryID objectAtIndex:iTag]);
    
    strPlayerId = [NSString stringWithFormat:@"%@",[aryID objectAtIndex:iTag]];
    
    
        @try {
            NSMutableArray *sport = [[NSMutableArray alloc] init];
            [sport addObject:[arySportType objectAtIndex:iTag]];
            NSLog(@"sport=%@",sport);
            
            NSMutableArray *sport_type = [[NSMutableArray alloc] init];
            [sport_type addObjectsFromArray:[sport objectAtIndex:0]];
            NSLog(@"sport_type=%@",sport_type);
            
            if (sport_type.count>0)
            {
                strsportTypes= [[NSString alloc]init ];
                for (int i=0; i<1; i++) //sport_type.count
                {
                    
                    strsportTypes = [strsportTypes stringByAppendingString:[NSString stringWithFormat:@"%@",[sport_type objectAtIndex:i]]];
                    // strsportTypes = [strsportTypes stringByAppendingString:@","];
                }
                
                // strsportTypes = [strsportTypes substringToIndex:[strsportTypes length] - 1];
                NSLog(@"strsportTypes=%@",strsportTypes);
            }
        }
        @catch (NSException *exception) {
            
            strsportTypes =@"";
            
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure you want to send Video to %@",[aryName objectAtIndex:iTag]] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 1;
        [alert show];
        
        
      
    
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



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
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
            
            
            NSLog(@"IDS===%@==%@===%@===%@===%@===%@",strPlayerId,[[NSUserDefaults standardUserDefaults]stringForKey:@"od"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
            
            int randomID = arc4random() % 90000 + 10000;
            NSString *strrandNo = [NSString stringWithFormat:@"%d",randomID];
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotificationWithVideotoPlayer:strPlayerId coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:appDelegate.strFilterTitle notes :appDelegate.strFilterNotes videoreq :@"Review" sporttype:appDelegate.strFilterSportType  randid:strrandNo videofile:appDelegate.strPlayerstrVideoPath thumbimage:thumbnail];
            
        }
        else
        {
            
            NSLog(@"IDS===%@==%@===%@===%@===%@===%@",strPlayerId,[[NSUserDefaults standardUserDefaults]stringForKey:@"id"],appDelegate.strFilterTitle,appDelegate.strFilterNotes,appDelegate.strFilterSportType,appDelegate.strPlayerstrVideoPath);
            
            NSLog(@"Paths===%@==%@===%@===%@===",appDelegate.strPlayerSendVideo,appDelegate.strPlayerSendVideoPath,appDelegate.strPlayerSendThumb,appDelegate.strPlayerSendThumbPath
                  );
            
            
            SharedClass *shared =[SharedClass sharedInstance];
            shared.delegate =self;
            [shared sendNotificationWithVideotoPlayerPath:strPlayerId coachid:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] title:appDelegate.strFilterTitle notes:appDelegate.strFilterNotes videoreq:@"Review" sporttype:appDelegate.strFilterSportType randid:appDelegate.strVideoRandId videofilename:appDelegate.strPlayerSendVideo videofile:appDelegate.strPlayerSendVideoPath thumbname:appDelegate.strPlayerSendThumb thumb:appDelegate.strPlayerSendThumbPath];
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
        
        appDelegate.isReviewed = YES;
        [appDelegate showAlertMessage:@"Video sended successfully!"];
        appDelegate.strPlayerstrVideoPath = @"";
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        [appDelegate showAlertMessage:message];
    }
    
    
}




@end
