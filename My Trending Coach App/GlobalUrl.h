//
//  GlobalUrl.h
//  My Trending Coach App
//
//  Created by Nisarg on 11/12/15.
//  Copyright © 2015 Nisarg. All rights reserved.
//

#ifndef GlobalUrl_h
#define GlobalUrl_h

#import "AppDelegate.h"
#import "JSON.h"
//#import "UIView+Toast.h"
#import "SharedClass.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlarmObject.h"
#import "IQDropDownTextField.h"
#import <MediaPlayer/MediaPlayer.h>
#import "iToast.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "DGElasticPullToRefresh.h"


#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define global_url @"http://websitetestingbox.com/php/treding_coach/web_service/"



/////////// Define Newtork   //////
#define INTERNET_RECHABLE @"rechable"
#define INTERNET_NOTRECHABLE @"notrechable"
#define CONSTANT_NETWORK_NO_NETWORK 0
#define CONSTANT_NETWORK_WIFI 1
#define CONSTANT_NETWORK_CALLULER 2

#endif /* GlobalUrl_h */
