//
//  PlayerVideoListCell.m
//  My Trending Coach
//
//  Created by Nisarg on 11/04/16.
//  Copyright © 2016 Nisarg. All rights reserved.
//

#import "PlayerVideoListCell.h"

@implementation PlayerVideoListCell

- (IBAction)onSettings:(id)sender{
    if (self.didSettings)
        self.didSettings();
}

- (IBAction)onDelete:(id)sender{
    if (self.didDelete)
        self.didDelete();
}

- (IBAction)onEdit:(id)sender{
    if (self.didEdit)
        self.didEdit();
}

- (IBAction)onSend:(id)sender{
    if ([appDelegate.strPlayerCheck isEqualToString:@"Direct"])
    {
        NSString *str= [[NSUserDefaults standardUserDefaults]stringForKey:@"CardNumber"];
        if (str.length > 10)
        {
            NSString *cardno = [NSString stringWithFormat:@"************%@",[str substringFromIndex: [str length] - 4]];
            NSLog(@"cardno=%@",cardno);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged from (Card no:%@) for send this Video",cardno] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
            alert.tag = 2;
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You will be Charged to send this video"] delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
            alert.tag = 2;
            [alert show];
            
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            if (self.didReloadData)
                self.didReloadData();
            
        }
    }
}


@end
