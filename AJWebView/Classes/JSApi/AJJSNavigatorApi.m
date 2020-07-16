//
//  AJJSNavigatorApi.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJJSNavigatorApi.h"

@implementation AJJSNavigatorApi

- (void)registerHandlers {
//    __weak typeof(self) weakSelf = self;
//    
//    // TODO:待开发
//    [BWTNativeNavigator clear];
//    
//    // 设置导航栏标题
//    [self registerHandlerName:@"setNavTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"setNavTitle"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setNavTitle" result:dic];
//            return ;
//        };
//        
//        NSString *title = [data objectForKey:@"title"];
//        NSString *subTitle = [data objectForKey:@"subTitle"];
//        BOOL clickable = [[data objectForKey:@"clickable"] boolValue];
//        NSString *direction = [data objectForKey:@"direction"];
//        [BWTNativeNavigator setNavTitle:title subTitle:subTitle clickable:clickable direction:direction handler:^{
//            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"导航栏标题被点击" result:@{}];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setNavTitle" result:dic];
//        }];
//    }];
//    
//    // 设置多个导航栏标题
//    [self registerHandlerName:@"setMultiTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"setMultiTitle"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setMultiTitle" result:dic];
//            return ;
//        };
//        
//        NSArray *titles = [data objectForKey:@"titles"];
//        [BWTNativeNavigator setMultiTitle:titles handler:^(NSNumber * _Nonnull index) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"导航栏标题被点击" result:@{@"index":index}];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setMultiTitle" result:dic];
//        }];
//    }];
//    
//    // 显示导航栏
//    [self registerHandlerName:@"show" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"show"];
//        [BWTNativeNavigator show];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"导航栏显示设置成功" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"show" result:dic];
//    }];
//    
//    // 隐藏导航栏
//    [self registerHandlerName:@"hide" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hide"];
//        [BWTNativeNavigator hide];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"导航栏隐藏设置成功" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hide" result:dic];
//    }];
//    
//    // 显示状态栏
//    [self registerHandlerName:@"showStatusBar" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"showStatusBar"];
//        [BWTNativeNavigator showStatusBar];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"状态栏显示设置成功" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"showStatusBar" result:dic];
//    }];
//    
//    // 隐藏状态栏
//    [self registerHandlerName:@"hideStatusBar" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hideStatusBar"];
//        [BWTNativeNavigator hideStatusBar];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"状态栏隐藏设置成功" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hideStatusBar" result:dic];
//    }];
//    
//    //拦截系统侧滑返回
//    [self registerHandlerName:@"hookSysBack" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hookSysBack"];
//        //保存回调
//        [weakSelf saveObjectInCacheDic:responseCallback forKey:@"hookSysBack"];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hookSysBack" result:dic];
//    }];
//    
//    //拦截导航栏返回按钮
//    [self registerHandlerName:@"hookBackBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hookBackBtn"];
//        //保存回调
//        [weakSelf saveObjectInCacheDic:responseCallback forKey:@"hookBackBtn"];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hookBackBtn" result:dic];
//    }];
//    
//    //设置导航栏右上角按钮
//    [self registerHandlerName:@"setRightBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"setRightBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setRightBtn" result:dic];
//            return ;
//        };
//        NSInteger isShow = [[data objectForKey:@"isShow"] integerValue];
//        NSString *title = [data objectForKey:@"text"];
//        NSString *imageUrl = [data objectForKey:@"imageUrl"];
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator setRightBtn:title imageUrl:imageUrl index:index isShow:isShow handler:^(NSNumber * _Nonnull index) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setRightBtn" result:dic];
//        }];
//    }];
//    
//    //设置导航栏左上角按钮
//    [self registerHandlerName:@"setLeftBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"setLeftBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setLeftBtn" result:dic];
//            return ;
//        };
//        NSInteger isShow = [[data objectForKey:@"isShow"] integerValue];
//        NSString *title = [data objectForKey:@"text"];
//        NSString *imageUrl = [data objectForKey:@"imageUrl"];
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator setLeftBtn:title imageUrl:imageUrl index:index isShow:isShow handler:^(NSNumber * _Nonnull index) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"setLeftBtn" result:dic];
//        }];
//    }];
//    
//    //隐藏右侧按钮
//    [self registerHandlerName:@"hideRightBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hideRightBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"hideRightBtn" result:dic];
//            return ;
//        };
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator hideRightBtn:index];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hideRightBtn" result:dic];
//    }];
//    
//    //显示右侧按钮
//    [self registerHandlerName:@"showRightBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"showRightBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"showRightBtn" result:dic];
//            return ;
//        };
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator showRightBtn:index];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"showRightBtn" result:dic];
//    }];
//    
//    //隐藏左侧按钮
//    [self registerHandlerName:@"hideLeftBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"hideLeftBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"hideLeftBtn" result:dic];
//            return ;
//        };
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator hideLeftBtn:index];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"hideLeftBtn" result:dic];
//    }];
//    
//    //显示左侧按钮
//    [self registerHandlerName:@"showLeftBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [BWTNativeUtil logStart:@"showLeftBtn"];
//        if (![data isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
//            responseCallback(dic);
//            [BWTNativeUtil logEnd:@"showLeftBtn" result:dic];
//            return ;
//        };
//        NSNumber *index = [data objectForKey:@"index"];
//        [BWTNativeNavigator showLeftBtn:index];
//        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
//        responseCallback(dic);
//        [BWTNativeUtil logEnd:@"showLeftBtn" result:dic];
//    }];
    
}

- (void)dealloc {
    NSLog(@"<BWTJSNavigatorApi>dealloc");
}

@end
