//
//  MessageHandlerOpenURLScheme.h
//  TrustlyTestObjC
//
//  Created by Akseli Nelander on 15/02/16.
//  Copyright © 2016 Akseli Nelander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "TrustlyViewController.h"

@interface MessageHandlerOpenURLScheme : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) TrustlyViewController *parent;

@end
