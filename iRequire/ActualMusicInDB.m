//
//  ActualMusicInDB.m
//  DJReptile
//
//  Created by Carsten Graf on 06.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "ActualMusicInDB.h"

@interface ActualMusicInDB ()

{
    
    
    NSMutableArray *allValues;
    NSMutableArray *filterdStrings;
    bool isFilterd;

}


@end

@implementation ActualMusicInDB

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

//Read JSON Data from Server
-(void) getData:(NSData *) data{
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}


-(void) start {
    
    //Read JSON Data from Server
    
    
    if ([self connected]) {
    
    NSURL *url = [NSURL URLWithString:kGETUrl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    }
    else
    {
        UIAlertView *connection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Sorry you have no Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [connection show];
        
    }
    
    
}

//Pull to Refresh
-(void)refreshMyTableView{
    
    //set the title while refreshing
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    //end the refreshing
    
    [self start];
    
    [self sortinArray];
    
    [self.tableView reloadData];
    
    [refreshControl endRefreshing];
    
    NSLog(@"TableView reload!");
    
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Load!");
    
    
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshMyTableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - Table view data source


//Names of Sections
- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
                return @"House";
            break;
        case 1:
                return @"Hip-Hop";
            break;
        case 2 :
                return @"Party";
            break;
        case 3:
                return @"Other";
            break;
        default:
                return @"Error";
            break;
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of section

    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   

    
    switch (section) {
        case 0:
            return [HouseArrayArtist count];        //HouseArrayArtist count = HouseArrayTitle count
            break;
        case 1:
            return [HipHopArrayArtist count];
            break;
        case 2:
            return [PartyArrayArtist count];
            break;
        case 3:
            return [OtherArrayArtist count];
            break;
        default: return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    

    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [HouseArrayArtist objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [HouseArrayTitle objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [HipHopArrayArtist objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [HipHopArrayTitle objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [PartyArrayArtist objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [PartyArrayTitle objectAtIndex:indexPath.row];
            break;
        case 3:
            cell.textLabel.text = [OtherArrayArtist objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [OtherArrayTitle objectAtIndex:indexPath.row];
            break;
        default:
            break;
        }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:255.0/255 green:255.0/255 blue:145.0/255 alpha:1]:[UIColor clearColor];
    
     cell.backgroundColor = color;
}


-(void)sortinArray{

    HouseArrayArtist = [NSMutableArray array];
    HouseArrayTitle = [NSMutableArray array];
    HipHopArrayArtist = [NSMutableArray array];
    HipHopArrayTitle = [NSMutableArray array];
    PartyArrayArtist = [NSMutableArray array];
    PartyArrayTitle =[NSMutableArray array];
    OtherArrayArtist = [NSMutableArray array];
    OtherArrayTitle = [NSMutableArray array];
    
    for (int i = 0; i < [json count]; i++) {
        
        NSDictionary *info =  [json objectAtIndex:i];
        NSString *TitleValue = [info objectForKey:@"Titel"];
        NSString *ArtistValue = [info objectForKey:@"Artist"];        
        NSString *GenereValue = [info objectForKey:@"Genere"];
        
        if ([GenereValue isEqualToString:@"0"])
            {
                [HouseArrayArtist addObject:ArtistValue];
                [HouseArrayTitle addObject:TitleValue];
            }
        
        if ([GenereValue isEqualToString:@"1"])
            {
                [HipHopArrayArtist addObject:ArtistValue];
                [HipHopArrayTitle addObject:TitleValue];
            }
        if ([GenereValue isEqualToString:@"2"])
            {
                [PartyArrayArtist addObject:ArtistValue];
                [PartyArrayTitle addObject:TitleValue];
            }
        if ([GenereValue isEqualToString:@"3"])
            {
                [OtherArrayArtist addObject:ArtistValue];
                [OtherArrayTitle addObject:TitleValue];
            }
        
    }
        
}

/*

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     LikeTiltleViewController *detailViewController = [[LikeTiltleViewController alloc] initWithNibName:@"pushtolikeview" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}
*/
- (IBAction)refresh:(id)sender {
    
    [self refreshMyTableView];
    
}
@end
