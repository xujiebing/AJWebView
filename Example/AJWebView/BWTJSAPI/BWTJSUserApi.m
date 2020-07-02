//
//  BWTJSUserApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSUserApi.h"

@implementation BWTJSUserApi

- (instancetype)init {
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
    
    // 获取用户token
    [self registerHandlerName:@"getToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getToken"];
        NSDictionary *tokenDic = [BWTNativeUser getToken];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:tokenDic];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getToken" result:dic];
    }];
    
    // 判断用户是否登录
    [self registerHandlerName:@"isLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"isLogin"];
        BOOL isLogin = [BWTNativeUser isLogin];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"isLogin":@(isLogin)}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"isLogin" result:dic];
    }];
    
    // 获取用户信息
    [self registerHandlerName:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getUserInfo"];
        NSDictionary *dic = @{@"nickName":ISNIL(BWTUserManager.userModel.nickname),
                              @"headPic":ISNIL(BWTUserManager.userModel.userImagePath),
                              @"phone":ISNIL(BWTUserManager.userModel.mobilePhone),};
        NSDictionary *result = [weakSelf responseDicWithCode:YES Msg:@"" result:dic];
        responseCallback(result);
        [BWTNativeUtil logEnd:@"getUserInfo" result:dic];
    }];
    
}

- (void)dealloc {
    NSLog(@"<BWTJSUserApi>dealloc");
}

@end
