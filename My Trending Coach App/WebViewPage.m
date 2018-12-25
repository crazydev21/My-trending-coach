//
//  WebViewPage.m
//  My Trending Coach
//
//  Created by Bhavin on 4/3/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "WebViewPage.h"

@interface WebViewPage ()

@property (nonatomic, weak) IBOutlet UIButton* dismissButton;
@property (nonatomic, assign) BOOL certificatesLayout;
@end

@implementation WebViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSLog(@"_strurl==%@",_strurl);
    [appDelegate startLoadingview:@"Loading..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_strurl]];
    [_IBWebView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.certificatesLayout) {
//        self.IBWebView.userInteractionEnabled = NO;
        self.dismissButton.hidden = YES;
    } else{
//        self.IBWebView.userInteractionEnabled = YES;
        self.dismissButton.hidden = NO;
    }
}

#pragma mark - Public
- (void)setupForCertificates{
    self.certificatesLayout = YES;
}
- (void)blockGestures{
    self.IBWebView.userInteractionEnabled = NO;
}

- (void)hideDismissButton{
    self.dismissButton.hidden = YES;
}

#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [appDelegate stopLoadingview];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [appDelegate showAlertMessage:@"Somthing wrong"];
    [appDelegate stopLoadingview];
}


- (IBAction)IBButtonClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
