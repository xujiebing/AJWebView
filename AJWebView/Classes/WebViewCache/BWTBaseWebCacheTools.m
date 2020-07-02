//
//  BWTBaseWebCacheTools.m
//  BWTAbility
//
//  Created by ccc's MacBook Pro on 2017/12/27.
//

#import "BWTBaseWebCacheTools.h"

@implementation BWTBaseWebCacheTools

+ (void)configWKWebViewCache:(NSString *)url {
    if (![BWTBaseWebCacheTools useCache:url]) {
        return;
    }
    [NSURLProtocol registerClass:[BWTBaseWebCacheProtocol class]];
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
}

+ (void)unConfigWKWebViewCache:(NSString *)url {
    if (![BWTBaseWebCacheTools useCache:url]) {
        return;
    }
    [NSURLProtocol wk_unregisterScheme:@"https"];
    [NSURLProtocol wk_unregisterScheme:@"http"];
    [NSURLProtocol unregisterClass:[BWTBaseWebCacheProtocol class]];
}

+ (BOOL)useCache:(NSString *)url {
    NSString *whiteUrl = BWTConfigInfo.msxDomain;
    // 判断是不是白名单，失败名单的url才允许进行缓存，只有继承基础WebView的类url才为空，继承的类也是属于白名单
    if ([url hasPrefix:whiteUrl] || !url) {
        return YES;
    }
    return NO;
}

@end
