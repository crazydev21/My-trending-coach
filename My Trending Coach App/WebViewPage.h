//
//  WebViewPage.h
//  My Trending Coach
//
//  Created by Bhavin on 4/3/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewPage : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *IBWebView;

@property (strong, nonatomic) NSString *strurl;

- (void)blockGestures;
- (void)hideDismissButton;
- (void)setupForCertificates;
@end
