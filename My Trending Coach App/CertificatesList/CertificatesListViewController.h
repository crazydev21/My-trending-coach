//
//  CertificatesListViewController.h
//  MTC
//
//  Created by iServ on 12/22/17.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CertificatesListViewController;

@protocol CertificatesListViewControllerDelegate <NSObject>

- (void)certificatesViewController:(CertificatesListViewController*)certificatesViewController
                  didSelectNewDocument:(NSURL*)url;

- (void)certificatesViewController:(CertificatesListViewController*)certificatesViewController
              didSelectDeleteCertificateWithID:(NSString*)certificateURLToDelete;
@end

@interface CertificatesListViewController : UIViewController

@property (nonatomic, weak) id<CertificatesListViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isOwnProfile;
- (void)setupCertificatesURLs:(NSArray<NSString*>*)certificatesURLs;


@end
