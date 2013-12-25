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
    
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.delegate = self;
    

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, ((self.view.center.x - (loginview.frame.size.width / 2))), ((self.view.center.y - (loginview.frame.size.width/2)) - 20));
    }


    //[self.view addSubview:loginview];
    [loginview sizeToFit];
    [loginview addMotionEffect: self.paralax];
    
    self.labelFirstName.textAlignment = NSTextAlignmentCenter;
    
    
    self.scrollview.contentSize =  CGSizeMake(320, 2000);
    
}



#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode

    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
  }

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    self.labelFirstName.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];

    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
    self.profilePic.alpha = 1.0;
    

    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {

    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    
    
    
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    
    self.labelFirstName.text = [NSString stringWithFormat:@"Bitte einloggen!"];
    self.profilePic.alpha = 0.0;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {

    NSLog(@"FBLoginView encountered an error=%@", error);
}


-(UIMotionEffectGroup*)paralax
{

    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    xAxis.minimumRelativeValue = @-40;
    xAxis.maximumRelativeValue = @40;
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    yAxis.minimumRelativeValue = @-40;
    yAxis.maximumRelativeValue = @40;
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc]init];
    group.motionEffects = @[xAxis, yAxis];
    
    
    return group;
}


@end
