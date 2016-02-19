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

    // Initialize closeView (which will close modal when tapped)
    CGFloat topOffset = self.view.bounds.size.height / 10;
    CGRect closeViewFrame = CGRectMake(0, 0,
                                       self.view.bounds.size.width,
                                       topOffset);
    UIView *closeView = [[UIView alloc] initWithFrame:closeViewFrame];
    closeView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *closeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [closeView addGestureRecognizer:closeViewTap];
    [self.view addSubview:closeView];

    // Initialize the WKWebView
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    MessageHandlerOpenURLScheme *handler = [MessageHandlerOpenURLScheme new];
    handler.parent = self;
    
    CGRect webViewFrame = CGRectMake(0, topOffset,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height - topOffset);
    self.webView = [[WKWebView alloc] initWithFrame:webViewFrame
                                      configuration:configuration];
    [self.webView.configuration.userContentController
        addScriptMessageHandler:handler
                           name:@"trustlyOpenURLScheme"];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
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

# pragma mark - UIGestureRecognizer actions

- (void)closeView:(UIGestureRecognizer *)sender {
    NSLog(@"closeView");
    [self dismissViewControllerAnimated:YES completion:nil];
    self.flowDismissBlock();
}

# pragma mark - Helpers

- (void)flowDone:(NSURL *)finalUrl {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.flowDoneBlock(finalUrl);
}

@end
