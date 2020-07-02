//
//  BWTJSPageApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSPageApi.h"

@implementation BWTJSPageApi

- (instancetype)init {
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
    // 路由跳转
    [self registerHandlerName:@"push" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"push"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"push" result:dic];
            return ;
        };
        
        NSString *url = [data objectForKey:@"url"];
        NSDictionary *params = [data objectForKey:@"params"];
        [BWTNativePage push:url params:params];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"路由跳转成功" result:@{}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"push" result:dic];
    }];
    
    // 路由返回
    [self registerHandlerName:@"pop" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"pop"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pop" result:dic];
            return ;
        };
        
        NSNumber *index = [data objectForKey:@"index"];
        [BWTNativePage pop:index];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"路由返回成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"pop" result:dic];
    }];
    
    // 刷新页面
    [self registerHandlerName:@"reloadWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"reloadWebview"];
        [weakSelf.webloader reloadWKWebview];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"页面刷新执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"reloadWebview" result:dic];
    }];
    
    // 进入页面
    [self registerHandlerName:@"appear" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"appear"];
        [BWTNativePage appear:^() {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"进入页面" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"appear" result:dic];
        }];
    }];
    
    // 离开页面
    [self registerHandlerName:@"disappear" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"disappear"];
        [BWTNativePage disappear:^() {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"离开页面" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"disappear" result:dic];
        }];
    }];
}

- (void)dealloc {
    NSLog(@"<BWTJSPageApi>dealloc");
}

@end
