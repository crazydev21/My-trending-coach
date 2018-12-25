//
//  CertificatesListViewController.m
//  MTC
//
//  Created by iServ on 12/22/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "CertificatesListViewController.h"

#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "WebViewPage.h"

@interface CertificatesListViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIDocumentPickerDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dismissButtonXCenterConstraint;
@property (nonatomic, weak) IBOutlet UIButton* deleteButton;
@property (nonatomic, weak) IBOutlet UIButton* addButton;

@property (nonatomic, strong) NSArray<NSString*>* certificatesURLs;
@property (nonatomic, strong) UIPageViewController* pageController;

@property (nonatomic, strong) NSArray<WebViewPage*>* pages;

//@property (nonatomic, strong) NSString* selectedCertificateURL;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation CertificatesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

     [self updateControlsVisibility];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)setupCertificatesURLs:(NSArray<NSString*>*)certificatesURLs{
    
    self.certificatesURLs = certificatesURLs;
    self.pages = [self pagesForURLs:certificatesURLs];
    
    [self updateControlsVisibility];
    
    [self setupPageController];
}

#pragma mark - Private

- (void)updateControlsVisibility{

    if (self.isOwnProfile) {
        
        if (self.pages.count > 0 ) {
            self.deleteButton.hidden = NO;
        } else{
            self.deleteButton.hidden = YES;
        }
        self.addButton.hidden = NO;
        self.dismissButtonXCenterConstraint.constant = -72.f;
    } else{
        self.deleteButton.hidden = YES;
        self.addButton.hidden = YES;
        self.dismissButtonXCenterConstraint.constant = 0;
    }
}

- (void)setupPageController{
    if (self.pageController){
        if (self.pages.count > 0) {
            
            self.currentIndex = [self.pages indexOfObject:self.pages.lastObject];
            [self.pageController setViewControllers:@[self.pages.lastObject] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
           
        }
        else{
            [self.pageController setViewControllers:@[[UIViewController new]] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];

        }
    }
}

- (NSArray*)pagesForURLs:(NSArray<NSString*>*)certificatesURLs{
    NSMutableArray* pages = [NSMutableArray new];
    for (NSString* url in self.certificatesURLs) {
        
        //UIStoryboard* storyboard = self.storyboard;
        WebViewPage* wepPage = [[WebViewPage alloc]initWithNibName:@"WebViewPage" bundle:nil];
        wepPage.strurl = url;
        [wepPage setupForCertificates];
        [pages addObject:wepPage];
    }
    return [NSArray arrayWithArray:pages];
}

-(void)presentDocumentPicker {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image",@"public.data",@"public.content",@"public.text",@"public.plain-text",@"public.composite-​content",@"public.presentation",] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    //@"public.movie" @"public.audio",
}

- (void)saveNewCerificate:(NSURL *)url {
    
    if ([self.delegate respondsToSelector:@selector(certificatesViewController:didSelectNewDocument:)]) {
        [self.delegate certificatesViewController:self didSelectNewDocument:url];
    }
}

#pragma mark - Actions

- (IBAction)onDismissButton:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddButton:(UIButton*)sender{
    [self presentDocumentPicker];
}

- (IBAction)onDeleteCertificateButton:(UIButton*)sender{
    
    
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Alert"
                                message:@"Are you sure you would like to delete this certificate?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {

                             if ([self.delegate respondsToSelector:@selector(certificatesViewController:didSelectDeleteCertificateWithID:)]) {
                                 
                                 NSString* certificateURLToDelete = @"";
                                 if(self.currentIndex < self.certificatesURLs.count && self.certificatesURLs.count > 0){
                                     certificateURLToDelete = self.certificatesURLs[self.currentIndex];
                                     if (certificateURLToDelete.length > 0) {
                                         [self.delegate certificatesViewController:self didSelectDeleteCertificateWithID:certificateURLToDelete];
                                     }
                                 }
                             }
                         }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"PageControllerSegue"]) {
        UIPageViewController* pageController = (UIPageViewController*)segue.destinationViewController;
        self.pageController = pageController;
        self.pageController.delegate = self;
        self.pageController.dataSource = self;
        [self setupPageController];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    WebViewPage* page = (WebViewPage*)viewController;
    if ([self.pages containsObject:page]) {
        NSUInteger currentIndex = [self.pages indexOfObject:page];
        NSInteger prevIndex = currentIndex - 1;
        if (prevIndex >= 0) {
            
            self.currentIndex = prevIndex;
            return self.pages[prevIndex];
        }else{
            return nil;
        }
    } else{
        return nil;
    }
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    WebViewPage* page = (WebViewPage*)viewController;
    if ([self.pages containsObject:page]) {
        NSUInteger currentIndex = [self.pages indexOfObject:page];
        NSUInteger nextIndex = currentIndex + 1;
        if (nextIndex < self.pages.count) {
            
            self.currentIndex = nextIndex;
            return self.pages[nextIndex];
        }else{
            return nil;
        }
    } else{
        return nil;
    }
    
}

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
//
//    if(completed){
//        NSInteger index = [self.pages indexOfObject:(WebViewPage*)previousViewControllers];
//        if (index < 0) {
//            self.currentIndex = 0;
//        } else if (index >= (self.pages.count-1)) {
//            self.currentIndex = self.pages.count - 1;
//        } else{
//
//        }
//        self.currentIndex = [self.pages indexOfObject:previousViewControllers];
//    }
//}

#pragma mark - UIdocumentPickerDataSource

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        
        NSString* strCertificate = [@"" stringByAppendingString:[url path]];
        NSLog(@"strCertificate=%@",strCertificate);
        
        NSArray *parts = [strCertificate componentsSeparatedByString:@"/"];
        NSString *filename = [[parts lastObject] lowercaseString];
        
        if ([filename rangeOfString:@".doc"].location != NSNotFound || [filename rangeOfString:@".docx"].location != NSNotFound || [filename rangeOfString:@".pdf"].location != NSNotFound || [filename rangeOfString:@".png"].location != NSNotFound || [filename rangeOfString:@".jpg"].location != NSNotFound || [filename rangeOfString:@".jpeg"].location != NSNotFound )
        {
            [self saveNewCerificate:url];
            
        }
        else
        {
            [appDelegate showAlertMessage:@"Please select png,jpg,pdf,doc and docx format file."];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
