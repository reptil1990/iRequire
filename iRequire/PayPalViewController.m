//
//  PayPalViewController.m
//  iRequire
//
//  Created by Carsten Graf on 12.12.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "PayPalViewController.h"
#import "ZBarSDK.h"


@interface PayPalViewController () <ZBarReaderDelegate>

@end

@implementation PayPalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.successView.hidden = YES;
    
    self.acceptCreditCards = YES;
    self.environment = PayPalEnvironmentNoNetwork;
    
    
    
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15.0f, 0, 14.0f);
    UIImage *payBackgroundImage = [[UIImage imageNamed:@"button_secondary.png"] resizableImageWithCapInsets:insets];
    UIImage *payBackgroundImageHighlighted = [[UIImage imageNamed:@"button_secondary_selected.png"] resizableImageWithCapInsets:insets];
    [self.payButton setBackgroundImage:payBackgroundImage forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:payBackgroundImageHighlighted forState:UIControlStateHighlighted];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    self.datalabel.text = @"ca.graf@web.de;01.00;Rechnung";
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Barcode reader


- (IBAction)ScanButtonTouchUpInside:(id)sender {
    ZBarReaderViewController* reader = [[ZBarReaderViewController alloc]init];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls=TRUE;
    reader.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
    
    ZBarImageScanner* scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:reader animated:YES completion:Nil];
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol* symbols = nil;
    for(symbols in results){
        break;
    }
    
    self.datalabel.text = symbols.data;
    
  NSArray* qrdata = [symbols.data componentsSeparatedByString: @";"];

    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(pay:) withObject:qrdata afterDelay:1];
    }


#pragma mark - PayPal

#define kPayPalClientId @"AU9TWhD05pOMuJuTx7TSAt7u0hZBsxPyGukyNZHSFLnPY6_WSqLiwlSkrVmq"



- (void)pay:(NSArray*)resiver{

        
        NSString* Payto = [resiver objectAtIndex: 0];
        NSString* ammount = [resiver objectAtIndex: 1];
        NSString* description = [resiver objectAtIndex: 2];

    /*
     
     QR DATA Format:   1. PayPal E-Mailadress
                        2. Ammount
                        3. Description
     
     seperatet by ";"
     
     Example: Musikpark@paypal.de;50,20;Rechnungs ID 1248237;
     
     */
    

    
    
    // Remove our last completed payment, just for demo purposes.
    self.completedPayment = nil;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:ammount];
    payment.currencyCode = @"EUR";
    payment.shortDescription = description;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Any customer identifier that you have will work here. Do NOT use a device- or
    // hardware-based identifier.
    NSString *customerId = @"user-11723";
    
    // Set the environment:
    // - For live charges, use PayPalEnvironmentProduction (default).
    // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
    // - For testing, use PayPalEnvironmentNoNetwork.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:kPayPalClientId
                                                                                                 receiverEmail:Payto
                                                                                                       payerId:customerId
                                                                                                       payment:payment
                                                                                                      delegate:self];
    paymentViewController.hideCreditCardButton = !self.acceptCreditCards;
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    paymentViewController.languageOrLocale = @"de";
    

  // [self presentViewController:paymentViewController animated:YES completion:nil];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:paymentViewController animated:YES completion:nil];

    
}

#pragma mark - Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.completedPayment = completedPayment;
    self.successView.hidden = NO;
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    NSLog(@"PayPal Payment Canceled");
    self.completedPayment = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
