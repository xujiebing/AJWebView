//
//  NSURLProtocol+BWTBaseWeb.h
//  NSURLProtocol+BWTBaseWeb
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (BWTBaseWeb)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
