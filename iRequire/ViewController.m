//
//  ViewController.m
//  iRequire
//
//  Created by Carsten Graf on 06.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end


@implementation ViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self roundButtons];
    
    self.labelFirstName.textAlignment = NSTextAlignmentLeft;
    self.labelFirstName.text = @"Bitte Einloggen";
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    }
    
    self.profilePic.alpha = 0.0;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


#pragma mark - FBLoginViewDelegate


- (IBAction)loginButton:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        [self LoggedOut];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
        [self sessionStateChanged:session state:state error:error];

         }];
        
    }
}


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
        {
            
            self.profilePic.alpha = 1.0;
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     self.labelFirstName.text = user.name;
                     self.profilePic.profileID = user.id;
                 }}];

        [self LoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self LoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self LoggedOut];
    }
}

}


// Show the user the logged-out UI
- (void)LoggedOut
{

     NSLog(@"UserLogOUT");
    self.profilePic.alpha = 0.0;
    self.labelFirstName.text = @"Bitte Einloggen";
    
    
}

// Show the user the logged-in UI
- (void)LoggedIn
{
    
    
    NSLog(@"UserLogIn");
    
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBSession handleOpenURL:url];
}
*/

-(void)roundButtons
{
    CALayer *musicwishlayer = [self.musicwish layer];
    [musicwishlayer setMasksToBounds:YES];
    [musicwishlayer setCornerRadius:10.0f];
    
    CALayer *musicinDBLayer = [self.musicinDB layer];
    [musicinDBLayer setMasksToBounds:YES];
    [musicinDBLayer setCornerRadius:10.0f];
    
    CALayer *messagesLayer = [self.messages layer];
    [messagesLayer setMasksToBounds:YES];
    [messagesLayer setCornerRadius:10.0f];
    
    CALayer *facebookLayer = [self.facebook layer];
    [facebookLayer setMasksToBounds:YES];
    [facebookLayer setCornerRadius:10.0f];
    
    CALayer *paypalLayer = [self.paypal layer];
    [paypalLayer setMasksToBounds:YES];
    [paypalLayer setCornerRadius:10.0f];




}


@end
