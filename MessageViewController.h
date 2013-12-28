//
//  MessageViewController.h
//  iRequire
//
//  Created by Carsten Graf on 28.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MessageViewController : UIViewController <MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>


@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) IBOutlet UIButton *browserButton;
@property (nonatomic, strong) IBOutlet UITextField *chatBox;
@property (nonatomic, strong) IBOutlet UITextView *textBox;
@property (strong, nonatomic) IBOutlet UIButton *clearMessages;


- (IBAction) showBrowserVC:(id)sender;

- (IBAction)clearmessages:(id)sender;

@end
