//
//  PayPalViewController.h
//  iRequire
//
//  Created by Carsten Graf on 12.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"


@interface PayPalViewController : UIViewController <PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalPayment *completedPayment;


@property (strong, nonatomic) IBOutlet UIView *successView;
@property (strong, nonatomic) IBOutlet UILabel *datalabel;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)ScanButtonTouchUpInside:(id)sender;
- (IBAction)pay:(id)sender;


@end
