//
//  SharedDelegate.h



#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SharedDelegate : NSObject
{
        Reachability*  reachability;
}
+(SharedDelegate*)sharedDelegate;
- (BOOL)checkNetwork;

//  Methods to set and get the user info
//- (void)saveUser:(NSDictionary *)dict;
//- (NSDictionary*)getUser;
@end
