//
//  ViewController.m
//  TrustlyTestObjC
//
//  Created by Akseli Nelander on 15/02/16.
//  Copyright © 2016 Akseli Nelander. All rights reserved.
//

#import "ViewController.h"
#import "TrustlyViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *trustlyURLTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit {
    NSString *text = self.trustlyURLTextField.text;
    
    if (text != nil && ![text isEqual: @""]) {
        NSURL *trustlyURL = [[NSURL alloc] initWithString:text];

        NSURLRequest *req = [NSURLRequest requestWithURL:trustlyURL];
        BOOL valid = [NSURLConnection canHandleRequest:req];
        if (!valid) {
            NSLog(@"Invalid URL: %@", trustlyURL);
            self.trustlyURLTextField.text = @"";
            return;
        }
        
        NSLog(@"Presenting the Trustly View Controller with URL: %@", trustlyURL);
        TrustlyViewController *trustlyVC = [TrustlyViewController new];
        trustlyVC.trustlyURL = trustlyURL;
        trustlyVC.endUrls = @[@"trustly/account/app/done/",
                              @"trustly/account/app/fail/",
                              @"trustly/p2p/app/done/",
                              @"trustly/p2p/app/fail/"];
        
        trustlyVC.flowDoneBlock = ^void(NSURL *finalUrl) {
            NSLog(@"Flow Done in original view controller: url = %@", finalUrl);
        };
        
        trustlyVC.flowDismissBlock = ^void(void) {
            NSLog(@"Flow dismissed in original view controller");
        };
        NSLog(@"color = %@, style = %ld", trustlyVC.view.backgroundColor, (long)trustlyVC.modalPresentationStyle);
        
        trustlyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;

        [self presentViewController:trustlyVC
                           animated:YES
                         completion:nil];
        
    }
}

- (void)flowHasReachedTheEnd:(NSURL *)finalUrl {
    
}

@end
