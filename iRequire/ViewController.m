//
//  ViewController.m
//  iRequire
//
//  Created by Carsten Graf on 06.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end


@implementation ViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    loginview.delegate = self;
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    
    
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, ((self.view.center.x - (loginview.frame.size.width / 2))), ((self.view.center.y - (loginview.frame.size.width/2)) - 50));
    }
#endif
#endif
#endif
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
    self.labelFirstName.textAlignment = NSTextAlignmentCenter;
    
}



#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode

    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
  }

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
    self.profilePic.alpha = 1.0;
    
    
  /*  float imageY = 0;
    NSLog(@"Size Width: %f",imageY);
    float heightOfImageLayer  = self.profilePic.frame.size.width;//- (imageY * 2.0);
    NSLog(@"Size Hight: %f",heightOfImageLayer);
   self.profilePic.layer.cornerRadius = heightOfImageLayer/2;
    self.profilePic.clipsToBounds = YES;
*/
    
    //self.profilePic.layer.cornerRadius = 30.0;
   // self.profilePic.clipsToBounds = YES;

    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    
    self.labelFirstName.text = [NSString stringWithFormat:@"Bitte einloggen!"];
    self.profilePic.alpha = 0.0;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}




@end
