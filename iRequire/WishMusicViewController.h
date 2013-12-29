//
//  WishMusicViewController.h
//  DJReptile
//
//  Created by Carsten Graf on 04.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//



/*
 
 Zeitbegrenzung implementieren
 
 */


#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#define kGETUrl @"http://reptil1990.funpic.de/getstatus.php"


@interface WishMusicViewController : UIViewController <UIAlertViewDelegate>
{
    
NSMutableArray *json;

}


@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtArtist;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *secGenere;

@property (strong, nonatomic) NSString *UserName;

- (IBAction)ConfirmAlert:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (BOOL)connected;

-(UIMotionEffectGroup*)Animation;

@end
