//
//  AJJSNavigatorApi.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJJSNavigatorApi.h"
#import <AJWebView/AJNativeNavigator.h>

@implementation AJJSNavigatorApi

- (void)registerHandlers {
    kAJWeakSelf
    [AJNativeNavigator clear];
    
    // 设置导航栏标题
    NSString *setNavTitle = @"setNavTitle";
    [self registerHandlerName:setNavTitle handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(setNavTitle)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(setNavTitle, dic)
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *subTitle = [data objectForKey:@"subTitle"];
        BOOL clickable = [[data objectForKey:@"clickable"] boolValue];
        NSString *direction = [data objectForKey:@"direction"];
        [AJNativeNavigator setNavTitle:title subTitle:subTitle clickable:clickable direction:direction vc:ajSelf.webloader handler:^{
            NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"导航栏标题被点击" result:@{}];
            responseCallback(dic);
            AJWebViewLogEnd(setNavTitle, dic)
        }];
    }];
    
    // 设置多个导航栏标题
    NSString *setMultiTitle = @"setMultiTitle";
    [self registerHandlerName:setMultiTitle handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(setMultiTitle)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(setMultiTitle, dic)
            return ;
        };
        
        NSArray *titles = [data objectForKey:@"titles"];
        [AJNativeNavigator setMultiTitle:titles vc:ajSelf.webloader handler:^(NSNumber * _Nonnull index) {
            NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"导航栏标题被点击" result:@{@"index":index}];
            responseCallback(dic);
            AJWebViewLogEnd(setMultiTitle, dic)
        }];
    }];
    
    // 显示导航栏
    NSString *show = @"show";
    [self registerHandlerName:show handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(show)
        [AJNativeNavigator showWithVC:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"导航栏显示设置成功" result:nil];
        responseCallback(dic);
        AJWebViewLogEnd(show, dic)
    }];
    
    // 隐藏导航栏
    NSString *hide = @"hide";
    [self registerHandlerName:hide handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(hide)
        [AJNativeNavigator hideWithVC:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"导航栏隐藏设置成功" result:nil];
        responseCallback(dic);
        AJWebViewLogEnd(hide, dic)
    }];
    
    //拦截系统侧滑返回
    NSString *hookSysBack = @"hookSysBack";
    [self registerHandlerName:hookSysBack handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(hookSysBack)
        //保存回调
        [ajSelf saveObjectInCacheDic:responseCallback forKey:hookSysBack];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:nil];
        responseCallback(dic);
        AJWebViewLogEnd(hookSysBack, dic)
    }];
    
    //拦截导航栏返回按钮
    NSString *hookBackBtn = @"hookBackBtn";
    [self registerHandlerName:hookBackBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(hookBackBtn)
        //保存回调
        [ajSelf saveObjectInCacheDic:responseCallback forKey:hookBackBtn];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:nil];
        responseCallback(dic);
        AJWebViewLogEnd(hookBackBtn, dic)
    }];
    
    //设置导航栏右上角按钮
    NSString *setRightBtn = @"setRightBtn";
    [self registerHandlerName:setRightBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(setRightBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(setRightBtn, dic)
            return ;
        };
        NSInteger isShow = [[data objectForKey:@"isShow"] integerValue];
        NSString *title = [data objectForKey:@"text"];
        NSString *imageUrl = [data objectForKey:@"imageUrl"];
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator setRightBtn:title imageUrl:imageUrl index:index isShow:isShow vc:ajSelf.webloader handler:^(NSNumber * _Nonnull index) {
            NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
            responseCallback(dic);
            AJWebViewLogEnd(setRightBtn, dic)
        }];
    }];
    
    //设置导航栏左上角按钮
    NSString *setLeftBtn = @"setLeftBtn";
    [self registerHandlerName:setLeftBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(setLeftBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(setLeftBtn, dic)
            return ;
        };
        NSInteger isShow = [[data objectForKey:@"isShow"] integerValue];
        NSString *title = [data objectForKey:@"text"];
        NSString *imageUrl = [data objectForKey:@"imageUrl"];
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator setLeftBtn:title imageUrl:imageUrl index:index isShow:isShow vc:ajSelf.webloader handler:^(NSNumber * _Nonnull index) {
            NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
            responseCallback(dic);
            AJWebViewLogEnd(setLeftBtn, dic)
        }];
    }];
    
    //隐藏右侧按钮
    NSString *hideRightBtn = @"hideRightBtn";
    [self registerHandlerName:hideRightBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(hideRightBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(hideRightBtn, dic)
            return ;
        };
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator hideRightBtn:index vc:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
        responseCallback(dic);
        AJWebViewLogEnd(hideRightBtn, dic)
    }];
    
    //显示右侧按钮
    NSString *showRightBtn = @"showRightBtn";
    [self registerHandlerName:showRightBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(showRightBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(showRightBtn, dic)
            return ;
        };
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator showRightBtn:index vc:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
        responseCallback(dic);
        AJWebViewLogEnd(showRightBtn, dic)
    }];
    
    //隐藏左侧按钮
    NSString *hideLeftBtn = @"hideLeftBtn";
    [self registerHandlerName:hideLeftBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(hideLeftBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(hideLeftBtn, dic)
            return ;
        };
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator hideLeftBtn:index vc:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
        responseCallback(dic);
        AJWebViewLogEnd(hideLeftBtn, dic)
    }];
    
    //显示左侧按钮
    NSString *showLeftBtn = @"showLeftBtn";
    [self registerHandlerName:showLeftBtn handler:^(id data, WVJBResponseCallback responseCallback) {
        AJWebViewLogStart(showLeftBtn)
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [ajSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            AJWebViewLogEnd(showLeftBtn, dic)
            return ;
        };
        NSNumber *index = [data objectForKey:@"index"];
        [AJNativeNavigator showLeftBtn:index vc:ajSelf.webloader];
        NSDictionary *dic = [ajSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
        responseCallback(dic);
        AJWebViewLogEnd(showLeftBtn, dic)
    }];
    
}

- (void)dealloc {
    NSLog(@"<AJJSNavigatorApi>dealloc");
}

@end
