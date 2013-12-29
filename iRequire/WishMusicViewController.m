//
//  WishMusicViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 04.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "WishMusicViewController.h"

@interface WishMusicViewController ()
{

    NSString *NumberOfGenere;
    NSString *Status;
    NSString *Waittime;
    int *GenereValue;
}


@end

@implementation WishMusicViewController

bool isKeyboardVisible = FALSE;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Load!");
    
    [self start];
   

	// Do any additional setup after loading the view.
    
}



- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ConfirmAlert:(id)sender

{
    if ([self connected]) {
     
    [self start];
    
    NSDictionary *info = [json objectAtIndex:0];
    Status = [info objectForKey:@"Status"];
    if (Status == nil) {
        Status = [NSString stringWithFormat:@"1"];
        
    }
    
    NSLog(@"Status: %@", Status);
    if ([Status isEqualToString: @"1"]) {
    
    
    if (self.timer != nil || [self.timer isValid]) {
        UIAlertView *waitalert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have to wait!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [waitalert show];
        return;
    }
    
        if ([_txtName.text isEqualToString:@""] || [_txtArtist.text isEqualToString:@"" ] || [_txtTitle.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uncomplete" message:@"Please Fill all the field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else {
            
            
                        
        
        NSString *Alertshow = [NSString stringWithFormat: @"Artist: %@\nTitle: %@" ,_txtArtist.text,_txtTitle.text];
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Right Insert?" message: Alertshow delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
        
        [confirmAlert show];
            
        }
    }
    else{
    
        UIAlertView *statusalert = [[UIAlertView alloc] initWithTitle:@"Disabled" message:@"Musicwish is not active!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [statusalert show];
    }
    }
    else
    {
        
        UIAlertView *connection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Sorry you have no Internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [connection show];
    
    }
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    
    
    NSDictionary *info = [json objectAtIndex:0];
    Waittime = [info objectForKey:@"Timer"];
    
    if(buttonIndex == 1)
    {
       
        
        NSString *insertName = [_txtName.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *insertTitle = [_txtTitle.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *insertArtist = [_txtArtist.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        
        NSString *strURL = [NSString stringWithFormat:@"http://reptil1990.funpic.de/phpFile.php?Name=%1@&Artist=%2@&Titel=%3@&Genere=%ld",insertName,insertArtist,insertTitle, (long)[self.secGenere selectedSegmentIndex]];
    
        NSLog(@"%@", strURL);
    
        // to execute php code
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
        // to receive the returend value
        NSString *strResult = [[NSString alloc] initWithData:dataURL encoding: NSUTF8StringEncoding];
    

        if ([strResult isEqualToString:@"success"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succsess" message:@"Your wish is send! Tank You!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            _txtName.text = nil;
            _txtArtist.text = nil;
            _txtTitle.text = nil;
            NSLog(@"%@", strResult);

            
        }
        else
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went Wrong! Sorry!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert2 show];
                
            }
        
        }
        
    }


- (IBAction)hideKeyboard:(id)sender
{

[sender resignFirstResponder];

}



-(void)Animation
{

    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    xAxis.minimumRelativeValue = @-40;
    xAxis.maximumRelativeValue = @40;
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    yAxis.minimumRelativeValue = @-40;
    yAxis.maximumRelativeValue = @40;
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc]init];
    group.motionEffects = @[xAxis, yAxis];
    

}


@end
