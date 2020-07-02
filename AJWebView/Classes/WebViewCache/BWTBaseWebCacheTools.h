//
//  BWTBaseWebCacheTools.h
//  BWTAbility
//
//  Created by ccc's MacBook Pro on 2017/12/27.
//

#import <Foundation/Foundation.h>

@interface BWTBaseWebCacheTools : NSObject


/**
 启用WKWebview缓存机制

 @param url url地址
 */
+ (void)configWKWebViewCache:(NSString *)url;

/**
 禁用WKWebview缓存机制
 
 @param url url地址
 */
+ (void)unConfigWKWebViewCache:(NSString *)url;

@end
