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

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImage;
@property (strong, nonatomic) IBOutlet UIImageView *forthImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthImage;

-(UIMotionEffectGroup*)paralax;


@end
