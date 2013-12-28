//
//  ViewController.h
//  iRequire
//
//  Created by Carsten Graf on 06.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) ViewController *mainViewController;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *NavigationBarProfilePic;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (strong, nonatomic) IBOutlet UIButton *musicwish;
@property (strong, nonatomic) IBOutlet UIButton *musicinDB;
@property (strong, nonatomic) IBOutlet UIButton *messages;
@property (strong, nonatomic) IBOutlet UIButton *facebook;
@property (strong, nonatomic) IBOutlet UIButton *paypal;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)LoggedIn;
- (void)LoggedOut;
- (void)roundButtons;



- (IBAction)loginButton:(id)sender;




@end
