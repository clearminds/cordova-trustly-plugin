//
//  MessageHandlerOpenURLScheme.m
//  TrustlyTestObjC
//
//  Created by Akseli Nelander on 15/02/16.
//  Copyright © 2016 Akseli Nelander. All rights reserved.
//

#import "MessageHandlerOpenURLScheme.h"

@implementation MessageHandlerOpenURLScheme

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"Trying to open app based on json data: %@", message.body);

    if ([message.body isKindOfClass:[NSString class]]) {
        NSDictionary *parsed = [self getParsedJSONFromObj:message.body];
        if (parsed == nil) {
            return;
        }
        
        NSString *callback = [parsed objectForKey:@"callback"];
        NSURL *urlScheme = [[NSURL alloc] initWithString:[parsed objectForKey:@"urlscheme"]];
        BOOL success = [[UIApplication sharedApplication] openURL:urlScheme];
        NSString *successString = success ? @"true" : @"false";
        
        NSString *js = [NSString stringWithFormat:@"%@(%@,\"%@\");", callback, successString, urlScheme];
        NSLog(@"MessageHandlerOpenURLScheme evaluating the following js in webview: %@", js);
        [self.parent.webView evaluateJavaScript:js completionHandler:nil];
    }
}

- (NSDictionary *)getParsedJSONFromObj:(NSString *)object {
    NSData *jsonData = [object dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    id parsed = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingAllowFragments
                                                   error:&jsonError];
    if (parsed == nil) {
        NSLog(@"MessageHandlerOpenURLScheme json parsing failed with error: %@", jsonError);
        return nil;
    }
    
    if (![parsed isKindOfClass:[NSDictionary class]]) {
        NSLog(@"MessageHandlerOpenURLScheme json parsing succeeded but object was unexpected class. Expected NSDictionary but got %@", [parsed class]);
        return nil;
    }
    
    return (NSDictionary *)parsed;
}

@end
