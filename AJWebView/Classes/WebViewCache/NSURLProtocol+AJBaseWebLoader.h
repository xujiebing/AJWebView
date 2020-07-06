//
//  NSURLProtocol+AJBaseWebLoader.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (AJBaseWebLoader)

+ (void)ajRregisterScheme:(NSString*)scheme;

+ (void)ajUnregisterScheme:(NSString*)scheme;

@end

NS_ASSUME_NONNULL_END
