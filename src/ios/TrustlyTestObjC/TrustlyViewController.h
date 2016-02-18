//
//  TrustlyViewController.h
//  TrustlyTestObjC
//
//  Created by Akseli Nelander on 15/02/16.
//  Copyright © 2016 Akseli Nelander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TrustlyViewController : UIViewController<WKNavigationDelegate>

@property (nonatomic) NSURL *trustlyURL; // set before presenting the view controller
@property (nonatomic) NSArray<NSString *> *endUrls;
@property (nonatomic) WKWebView *webView;
@property (nonatomic, copy) void (^flowDoneBlock)(NSURL *);
@property (nonatomic, copy) void (^flowDismissBlock)(void);

@end
