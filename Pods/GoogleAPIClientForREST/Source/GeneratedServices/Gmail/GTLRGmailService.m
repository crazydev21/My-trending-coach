// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Gmail API (gmail/v1)
// Description:
//   Access Gmail mailboxes including sending user email.
// Documentation:
//   https://developers.google.com/gmail/api/

#import "GTLRGmail.h"

// ----------------------------------------------------------------------------
// Authorization scopes

NSString * const kGTLRAuthScopeGmailCompose         = @"https://www.googleapis.com/auth/gmail.compose";
NSString * const kGTLRAuthScopeGmailInsert          = @"https://www.googleapis.com/auth/gmail.insert";
NSString * const kGTLRAuthScopeGmailLabels          = @"https://www.googleapis.com/auth/gmail.labels";
NSString * const kGTLRAuthScopeGmailMailGoogleCom   = @"https://mail.google.com/";
NSString * const kGTLRAuthScopeGmailMetadata        = @"https://www.googleapis.com/auth/gmail.metadata";
NSString * const kGTLRAuthScopeGmailModify          = @"https://www.googleapis.com/auth/gmail.modify";
NSString * const kGTLRAuthScopeGmailReadonly        = @"https://www.googleapis.com/auth/gmail.readonly";
NSString * const kGTLRAuthScopeGmailSend            = @"https://www.googleapis.com/auth/gmail.send";
NSString * const kGTLRAuthScopeGmailSettingsBasic   = @"https://www.googleapis.com/auth/gmail.settings.basic";
NSString * const kGTLRAuthScopeGmailSettingsSharing = @"https://www.googleapis.com/auth/gmail.settings.sharing";

// ----------------------------------------------------------------------------
//   GTLRGmailService
//

@implementation GTLRGmailService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://www.googleapis.com/";
    self.servicePath = @"gmail/v1/users/";
    self.resumableUploadPath = @"resumable/upload/";
    self.simpleUploadPath = @"upload/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint" ];
  }
  return self;
}

@end
