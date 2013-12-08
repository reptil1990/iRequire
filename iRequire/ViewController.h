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

@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;


@end
