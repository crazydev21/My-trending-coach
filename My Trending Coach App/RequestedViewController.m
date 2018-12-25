//
//  RequestedViewController.m
//  MTC
//
//  Created by Developer on 31.10.2017.
//  Copyright © 2017 Nisarg. All rights reserved.
//

#import "RequestedViewController.h"
#import "RequestedTableViewCell.h"

@interface RequestedViewController () <SharedClassDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *content;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getContent];
}

- (void)getContent{
  
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] isEqualToString:@"Player"]) {
        [self getConentForPlayer];
    }else{
        [self getConentForCouch];
    }
}

- (void)getConentForPlayer{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate =self;
    [shared RequestAppointmentListForPlayer:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"pending_player_appointment"];
}

- (void)getConentForCouch{
    SharedClass *shared =[SharedClass sharedInstance];
    shared.delegate = self;
    [shared RequestAppointmentList:[[NSUserDefaults standardUserDefaults]stringForKey:@"id"] passing_value:@"pending_coach_appointment"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.content.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestedTableViewCell"];
    
    NSDictionary *request = [self.content objectAtIndex:indexPath.row];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Login"] isEqualToString:@"Player"]) {
        [cell.userName setText:[request valueForKey:@"coach_name"]];

        NSString *avatar = [NSString stringWithFormat:@"%@/%@",[request objectForKey:@"coach_photo_folder"],[request objectForKey:@"coach_photo_name"]];
        
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatarDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cell.avatar)
                [cell.avatar setImage:image];
        }];
        
        cell.sessionCost.text = [NSString stringWithFormat:@"$%@", [request valueForKey:@"session_cost"]];
        
        float value = [[NSString stringWithFormat:@"%@",[request valueForKey:@"coach_rating"]] floatValue];
        cell.rating.value = value;
        
        cell.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [request valueForKey:@"coach_location"], [request valueForKey:@"coach_state"]];
    }else{
        [cell.userName setText:[request valueForKey:@"player_name"]];
        
        cell.dateLabel.text = [request valueForKey:@"coach_location"];
        
        NSString *avatar = [NSString stringWithFormat:@"%@/%@",[request objectForKey:@"player_photo_folder"],[request objectForKey:@"player_photo_name"]];
        
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatarDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cell.avatar){
                if (image)
                    [cell.avatar setImage:image];
            }
        }];
        
        cell.sessionCost.text = [NSString stringWithFormat:@"$%@", [request valueForKey:@"session_cost"]];
        
        [cell.rating setHidden:YES];
//        [cell.sessionCost setHidden:YES];
//        [cell.sessionCostTitle setHidden:YES];
        
    }
    
    
    SharedClass *shared = [SharedClass sharedInstance];
    shared.delegate = self;
    cell.didDelete = ^{
        
        [shared DeleteRequestAppointmentFromList:[request valueForKey:@"req_noti_id"] passing_value:@"delete_pending_appointment" user_type:[[NSUserDefaults standardUserDefaults] stringForKey:@"Login"]];
    };
    
    return cell;
}


-(void)getUserDetails:(NSDictionary *)dicVideoDetials{
    NSLog(@"dicVideoDetials = %@", dicVideoDetials);
    
    self.content = [[dicVideoDetials valueForKey:@"result"] valueForKey:@"video_list"];
    [self.tableView reloadData];
    
}

- (void)getUserDetails5:(NSDictionary *)dicVideoDetials{
    //player list
    NSLog(@"%@", dicVideoDetials);
    
    if ([dicVideoDetials objectForKey:@"result"]) {
        NSDictionary* result  = [dicVideoDetials objectForKey:@"result"];
        if ([result objectForKey:@"request"] && ![[result objectForKey:@"request"] isEqual:[NSNull null]] ) {
            NSArray* items = (NSArray*)[result objectForKey:@"request"];//appointment_noty
            self.content = items;
        }
    }
//    self.content = [[dicVideoDetials objectForKey:@"result"] valueForKey:@"appointment_noty"];
    [self.tableView reloadData];
}

- (void)getUserDetails7:(NSDictionary *)dicVideoDetials{
    //couch info

    self.content = [[[dicVideoDetials valueForKey:@"result"] valueForKey:@"request"] firstObject];
    [self.tableView reloadData];
}

- (void)getUserDetails8:(NSDictionary *)dicVideoDetials{
  //delete request  
    [self getContent];
}

- (void)getUserDetails6:(NSDictionary *)dicVideoDetials{
    [self getConentForPlayer];
}

- (IBAction)onBack:(id)sender{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
