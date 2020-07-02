//
//  BWTJSRuntimeApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSRuntimeApi.h"

@interface BWTJSRuntimeApi ()

@property (nonatomic, strong) NSMutableDictionary *typeDic;

@end

@implementation BWTJSRuntimeApi

- (instancetype)init {
    self.typeDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [self p_addObserve];
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
    // 检测API在当前版本是否可用
    [self registerHandlerName:@"launchApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"launchApp"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"launchApp" result:dic];
            return ;
        };
        
        NSString *scheme = [data objectForKey:@"scheme"];
        [BWTNativeRuntime launchApp:scheme success:^(BOOL success) {
            if (!success) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"打开第三方app失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"launchApp" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"打开第三方app成功" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"launchApp" result:dic];
        }];
    }];
    
    // 获取JSBridge版本号
    [self registerHandlerName:@"getBridgeVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getBridgeVersion"];
        NSString *version = [BWTNativeRuntime getBridgeVersion];
        if (!version) {
            version = @"";
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"version":version}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getBridgeVersion" result:dic];
    }];
    
    // 获取Webview版本号
    [self registerHandlerName:@"getWebviewVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getWebviewVersion"];
        NSString *version = [BWTNativeRuntime getWebviewVersion];
        if (!version) {
            version = @"";
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"version":version}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getWebviewVersion" result:dic];
    }];
    
    // 获取定位
    [self registerHandlerName:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getLocation"];
        [BWTNativeRuntime getLocation:^(NSString * _Nonnull latitude, NSString * _Nonnull longitude) {
            if (!latitude || !longitude) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"定位获取失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"getLocation" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"定位获取成功" result:@{@"latitude":latitude, @"longitude":longitude}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"getLocation" result:dic];
        }];
    }];
    
    // app进入前台
    [self registerHandlerName:@"becomeActive" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"becomeActive"];
        [BWTNativeRuntime becomeActive:^() {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"app进入前台" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"becomeActive" result:dic];
        }];
    }];
    
    // app进入后台
    [self registerHandlerName:@"becomeBackground" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"becomeBackground"];
        [BWTNativeRuntime becomeBackground:^() {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"app进入后台" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"becomeBackground" result:dic];
        }];
    }];
    
    // 清理容器缓存
    [self registerHandlerName:@"clearCache" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"clearCache"];
        [BWTNativeRuntime clearCache:^{
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"清理容器缓存成功" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"clearCache" result:dic];
        }];
    }];
    
    // 获取剪贴板内容
    [self registerHandlerName:@"getClipboard" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getClipboard"];
        NSString *value = [BWTNativeRuntime getClipboard];
        if (!value) {
            value = @"";
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"获取剪贴板内容成功" result:@{@"value":value}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getClipboard" result:dic];
    }];
    
    // 设置剪贴板内容
    [self registerHandlerName:@"setClipboard" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setClipboard"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setClipboard" result:dic];
            return ;
        };
        
        NSString *value = [data objectForKey:@"value"];
        [BWTNativeRuntime setClipboard:value];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置剪贴板内容成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setClipboard" result:dic];
    }];
    
    // 获取app信息
    [self registerHandlerName:@"getAppInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getAppInfo"];
        NSDictionary *infoDic = [BWTNativeRuntime getAppInfo];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"获取app信息成功" result:infoDic];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getAppInfo" result:dic];
    }];
    
    // 获取城市信息
    [self registerHandlerName:@"getCityInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getCityInfo"];
        NSDictionary *infoDic = [BWTNativeRuntime getCityInfo];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"获取城市信息成功" result:infoDic];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getCityInfo" result:dic];
    }];
    
    
    [self registerHandlerName:@"registNativeNotify" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"registNativeNotify"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"registNativeNotify" result:dic];
            return ;
        };
        NSString *type = [NSString stringWithFormat:@"%@", [data bwtObjectForKey:@"type"]];
        [self.typeDic setObject:responseCallback forKey:type]; // 如果是相同类型的业务，重复注册的话，直接覆盖掉，以最后一个为准
        [BWTNativeUtil logEnd:@"registNativeNotify" result:@{}];
    }];
    
    [self registerHandlerName:@"callNativeNotify" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"callNativeNotify"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"callNativeNotify" result:dic];
            return ;
        };
        NSString *type = [NSString stringWithFormat:@"%@", [data bwtObjectForKey:@"type"]];
        id params = [data bwtObjectForKey:@"params"];
        if (!params) {
            params = @"";
        }
        NSDictionary *object = @{
            @"type":ISNIL(type),
            @"result":params
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BWTWebviewNativeNotify" object:object];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"调用注册方法成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"callNativeNotify" result:object];
    }];
}

- (void)p_addObserve {
    __weak typeof(self) weakSelf = self;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BWTWebviewNativeNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        for (NSString *type in [self.typeDic allKeys]) {
            if ([type isEqualToString:[x.object bwtObjectForKey:@"type"]]) {
                WVJBResponseCallback responseCallback = [self.typeDic objectForKey:type];
                id result = [x.object bwtObjectForKey:@"result"];
                NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"注册方法回调成功" result:result];
                responseCallback(dic);
                [self.typeDic removeObjectForKey:type];
            }
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"<BWTJSRuntimeApi>dealloc");
}

@end
