//
//  SharedDelegate.m



#import "SharedDelegate.h"
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@implementation SharedDelegate

static SharedDelegate *_sharedDelegate = nil;

+ (SharedDelegate *)sharedDelegate {
    @synchronized ([SharedDelegate class]) {
        if (!_sharedDelegate) {
            _sharedDelegate = [[self alloc] init];
        }
        
        return _sharedDelegate;
    }
}


#pragma mark - Check network

- (BOOL)checkNetwork {
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [internetReach currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You are not connected to the Internet. Please check your Internet connection and try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
            [alert show];
        });
        [appDelegate stopLoadingview];
        
        return NO;
    }
    else
        return YES;
}

- (int)getMyNetworkCarrier {
    
    //0 not reachable
    //1 on wifi
    //2 on 3g
    
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    if ([internetReach currentReachabilityStatus] == NotReachable) {
        return CONSTANT_NETWORK_NO_NETWORK;
    }
    else if ([internetReach currentReachabilityStatus] == ReachableViaWWAN)
    {
        return CONSTANT_NETWORK_CALLULER;
    }
    else if ([internetReach currentReachabilityStatus] == ReachableViaWiFi)
    {
        return CONSTANT_NETWORK_WIFI;
    }
    
    return 3;
}

-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {         }
    else if     (remoteHostStatus == ReachableViaWiFi)  {      }
    else if     (remoteHostStatus == ReachableViaWWAN)  {      }
    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)      {
        [[NSNotificationCenter defaultCenter]postNotificationName:INTERNET_NOTRECHABLE object:nil userInfo:nil];
        
        
    }
    else if     (remoteHostStatus == ReachableViaWiFi)  {
        [[NSNotificationCenter defaultCenter]postNotificationName:INTERNET_RECHABLE object:nil userInfo:nil];
        
        
    }
    else if     (remoteHostStatus == ReachableViaWWAN)  {
        [[NSNotificationCenter defaultCenter]postNotificationName:INTERNET_RECHABLE object:nil userInfo:nil];
    }
}

//- (void)saveUser:(NSDictionary *)dict
//{
//    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"user"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
//}
//- (NSDictionary*)getUser{
//    return   [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
//}

-(void)setPoints:(NSInteger)point
{
    [[NSUserDefaults standardUserDefaults] setInteger:point forKey:@"score"];
}
-(NSInteger)getPoints
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"score"];
}

-(void)saveCarMake
{
}

@end
