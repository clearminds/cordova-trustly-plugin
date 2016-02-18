//
//  TrustlyViewController.m
//  TrustlyTestObjC
//
//  Created by Akseli Nelander on 15/02/16.
//  Copyright © 2016 Akseli Nelander. All rights reserved.
//

#import "TrustlyViewController.h"
#import "MessageHandlerOpenURLScheme.h"

@interface TrustlyViewController ()

@property (nonatomic) BOOL endReached;

@end

@implementation TrustlyViewController

# pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.endReached = NO;
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    MessageHandlerOpenURLScheme *handler = [MessageHandlerOpenURLScheme new];
    handler.parent = self;

    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:configuration];
    [self.webView.configuration.userContentController
        addScriptMessageHandler:handler
                           name:@"trustlyOpenURLScheme"];
    self.webView.navigationDelegate = self;
    self.view = self.webView;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.trustlyURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - WKNavigationDelegate overrides

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *next = navigationAction.request.URL;

    for (NSString *endUrl in self.endUrls) {
        if ([[next absoluteString] hasSuffix:endUrl]) {
            self.endReached = YES;
            break;
        }
    }
    
    if (self.endReached) {
        NSLog(@"Reached the end at URL: %@", [next absoluteString]);
        decisionHandler(WKNavigationActionPolicyCancel);
        [self flowDone:next];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

# pragma mark - Helpers

- (void)flowDone:(NSURL *)finalUrl {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.flowDoneBlock(finalUrl);
}

@end
