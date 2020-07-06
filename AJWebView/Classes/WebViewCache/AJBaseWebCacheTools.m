//
//  AJBaseWebCacheTools.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJBaseWebCacheTools.h"
#import "AJBaseWebCacheProtocol.h"
#import "NSURLProtocol+AJBaseWebLoader.h"

@implementation AJBaseWebCacheTools

+ (void)configWKWebViewCache:(NSString *)url {
    [NSURLProtocol registerClass:[AJBaseWebCacheProtocol class]];
    [NSURLProtocol ajRregisterScheme:@"http"];
    [NSURLProtocol ajRregisterScheme:@"https"];
}

+ (void)unConfigWKWebViewCache:(NSString *)url {
    [NSURLProtocol ajUnregisterScheme:@"https"];
    [NSURLProtocol ajUnregisterScheme:@"http"];
    [NSURLProtocol unregisterClass:[AJBaseWebCacheProtocol class]];
}

@end
