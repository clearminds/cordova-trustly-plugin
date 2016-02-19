//
//  CDVPayPalMPL.m
//  Paypal Plugin for PhoneGap
//
//  Created by shazron on 10-10-08.
//  Copyright 2010 Shazron Abdullah. All rights reserved.

#import "CDVTrustly.h"
#import "TrustlyViewController.h"

@interface CDVTrustly ()

@end

@implementation CDVTrustly

- (void) startTrustlyFlow:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSLog(@"startTrustlyFlow called with id: %@ and arguments %@", callbackId, arguments);

    BOOL valid = YES;
    NSString *errorMsg;

    // Validate the URL
    NSString *urlString = [arguments objectAtIndex:0];
    NSURL *trustlyURL;
    if (urlString) {
        trustlyURL = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:trustlyURL];
        valid = [NSURLConnection canHandleRequest:req];
    } else {
        errorMsg = @"Given URL is not valid";
        valid = NO;
    }
    
    // Validate the endUrls
    id possibleEndUrls = [arguments objectAtIndex:1];
    NSArray *endUrls;
    if (![possibleEndUrls isKindOfClass:NSArray.class]) {
        valid = NO;
        errorMsg = @"endUrls needs to be an array with at least one element of type string";
    } else {
        endUrls = (NSArray *)possibleEndUrls;
        if (endUrls.count < 1) {
            valid = NO;
            errorMsg = @"endUrls needs to be an array with at least one element of type string";
        } else {
            if (![endUrls[0] isKindOfClass:NSString.class]) {
                valid = NO;
                errorMsg = @"endUrls needs to be an array with at least one element of type string";
            }
        }
    }
    
    if (valid) {

        NSLog(@"Presenting the Trustly View Controller with URL: %@", trustlyURL);
            
        TrustlyViewController *trustlyVC = [TrustlyViewController new];
        trustlyVC.trustlyURL = trustlyURL;
        trustlyVC.endUrls = endUrls;

        // Flow done callback
        trustlyVC.flowDoneBlock = ^void(NSURL *finalUrl) {
            NSDictionary *result = @{@"finalUrl": [finalUrl absoluteString]};
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsDictionary:result];
            [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:callbackId];
        };
            
        // Flow cancelled callback
        trustlyVC.flowDismissBlock = ^void(void) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
            [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:callbackId];
        };
        
        [self.viewController presentViewController:trustlyVC
                                          animated:YES
                                        completion:nil];
        
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:errorMsg];
        [self.commandDelegate sendPluginResult:pluginResult 
                                    callbackId:callbackId];
    }
}

@end
