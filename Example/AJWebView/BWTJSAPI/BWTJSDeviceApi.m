//
//  BWTJSDeviceApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSDeviceApi.h"

@implementation BWTJSDeviceApi

- (instancetype)init {
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
//    [BWTBluetoothTools sharedBWTBluetoothTools];
    
    // 获取设备唯一ID
    [self registerHandlerName:@"getDeviceId" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getDeviceId"];
        NSString *deviceId = [BWTNativeDevice getDeviceId];
        if (!deviceId) {
            deviceId = @"";
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设备唯一ID获取成功" result:@{@"deviceId":deviceId}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getDeviceId" result:dic];
    }];
    
    // 获取设备信息
    [self registerHandlerName:@"getDeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getDeviceInfo"];
        NSDictionary *deviceInfo = [BWTNativeDevice getDeviceInfo];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设备信息获取成功" result:deviceInfo];
        [BWTNativeUtil logEnd:@"getDeviceInfo" result:dic];
        responseCallback(dic);
    }];
    
    // 拨打电话
    [self registerHandlerName:@"phoneCall" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"phoneCall"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"phoneCall" result:dic];
            return ;
        };
        
        NSString *phone = [data objectForKey:@"phone"];
        [BWTNativeDevice phoneCall:phone success:^(BOOL success) {
            if (!success) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"拨打电话失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"phoneCall" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"拨打电话成功" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"phoneCall" result:dic];
        }];
    }];
    
    // 发送短信
    [self registerHandlerName:@"messageSend" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"messageSend"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"messageSend" result:dic];
            return ;
        };
        
        NSString *phone = [data objectForKey:@"phone"];
        NSString *text = [data objectForKey:@"text"];
        [BWTNativeDevice messageSend:phone text:text success:^(BOOL success) {
            if (!success) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"短信发送失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"messageSend" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"短信发送成功" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"messageSend" result:dic];
        }];
    }];
    
    // 关闭软键盘
    [self registerHandlerName:@"closeKeyboard" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"closeKeyboard"];
        [BWTNativeDevice closeKeyboard];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"关闭软键盘成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"closeKeyboard" result:dic];
    }];
    
    // 响铃
    [self registerHandlerName:@"makeRing" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"makeRing"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"makeRing" result:dic];
            return ;
        };
        
        NSNumber *soundId = [data objectForKey:@"soundId"];
        [BWTNativeDevice makeRing:soundId];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"响铃执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"makeRing" result:dic];
    }];
    
    // 短震动
    [self registerHandlerName:@"makeShortVibrate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"makeShortVibrate"];
        [BWTNativeDevice makeShortVibrate];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"短震动执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"makeShortVibrate" result:dic];
    }];
    
    // 长震动
    [self registerHandlerName:@"makeLongVibrate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"makeLongVibrate"];
        [BWTNativeDevice makeLongVibrate];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"长震动执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"makeLongVibrate" result:dic];
    }];
    
    // 获取蓝牙状态
    [self registerHandlerName:@"getBluetoothStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getBluetoothStatus"];
        BOOL valid = [BWTNativeDevice getBluetoothStatus];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"蓝牙状态获取成功" result:@{@"status":@(valid)}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getBluetoothStatus" result:dic];
    }];
    
    // 获取网络状态
    [self registerHandlerName:@"getNetworkStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getNetworkStatus"];
        NSNumber *type = [BWTNativeDevice getNetworkStatus];
        if (!type) {
            type = @(0);
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"网络状态获取成功" result:@{@"status":type}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getNetworkStatus" result:dic];
    }];
    
    // 监听蓝牙状态
    [self registerHandlerName:@"monitorBluetoothStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"monitorBluetoothStatus"];
        [BWTNativeDevice monitorBluetoothStatus:^(BOOL valid) {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"蓝牙状态变更" result:@{@"status":@(valid)}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"monitorBluetoothStatus" result:dic];
        }];
    }];
    
    // 监听网络状态
    [self registerHandlerName:@"monitorNetworkStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"monitorNetworkStatus"];
        [BWTNativeDevice monitorNetworkStatus:^(NSNumber *type) {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"网络状态变更" result:@{@"status":type}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"monitorNetworkStatus" result:dic];
        }];
    }];
    
    // 监听截屏操作
    [self registerHandlerName:@"monitorScreenShoot" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"monitorScreenShoot"];
        [BWTNativeDevice monitorScreenShoot:^() {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"截屏通知" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"monitorScreenShoot" result:dic];
        }];
    }];
    
    // 获取屏幕亮度
    [self registerHandlerName:@"getScreenBrightness" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getScreenBrightness"];
        NSNumber *brightness = [BWTNativeDevice getScreenBrightness];
        if (!brightness) {
            brightness = @(0);
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"获取屏幕亮度成功" result:@{@"brightness":brightness}];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"getScreenBrightness" result:dic];
    }];
    
    // 设置屏幕亮度
    [self registerHandlerName:@"setScreenBrightness" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setScreenBrightness"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setScreenBrightness" result:dic];
            return ;
        };
        
        NSNumber *brightness = [data objectForKey:@"brightness"];
        [BWTNativeDevice setScreenBrightness:brightness];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置屏幕亮度成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setScreenBrightness" result:dic];
    }];
    
    // 设置屏幕是否常亮
    [self registerHandlerName:@"setKeepScreenOn" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setKeepScreenOn"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setKeepScreenOn" result:dic];
            return ;
        };
        
        NSNumber *always = [data objectForKey:@"always"];
        [BWTNativeDevice setKeepScreenOn:[always boolValue]];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置屏幕是否常亮操作执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setKeepScreenOn" result:dic];
    }];
}

- (void)dealloc {
    NSLog(@"<BWTJSDeviceApi>dealloc");
}


@end
