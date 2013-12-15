//
//  ActualMusicInDB.h
//  DJReptile
//
//  Created by Carsten Graf on 06.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#define kGETUrl @"http://reptil1990.funpic.de/getjson.php"

@interface ActualMusicInDB : UITableViewController <UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *json;
    
    NSMutableArray *HouseArrayTitle;
    NSMutableArray *HouseArrayArtist;
    
    NSMutableArray *HipHopArrayTitle;
    NSMutableArray *HipHopArrayArtist;
    
    NSMutableArray *PartyArrayTitle;
    NSMutableArray *PartyArrayArtist;
    
    NSMutableArray *OtherArrayTitle;
    NSMutableArray *OtherArrayArtist;

    
UIRefreshControl *refreshControl;
        
    
}
@property (strong, nonatomic) NSTimer *refreshTimer;
@property (strong, nonatomic) IBOutlet UITableView *mytableview;

 -(void) refreshMyTableView;
- (IBAction)refresh:(id)sender;


- (BOOL)connected;

@end
