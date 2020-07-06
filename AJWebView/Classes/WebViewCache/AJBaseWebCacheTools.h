//
//  AJBaseWebCacheTools.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJBaseWebCacheTools : NSObject

/// 启用WKWebview缓存机制
/// @param url url地址
+ (void)configWKWebViewCache:(NSString *)url;

/// 禁用WKWebview缓存机制
/// @param url url地址
+ (void)unConfigWKWebViewCache:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
