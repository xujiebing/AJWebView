//
//  BWTJSUtilApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSUtilApi.h"

@interface BWTJSUtilApi () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) UILongPressGestureRecognizer *longpressGesture;  // webView长按手势

@end

@implementation BWTJSUtilApi

- (instancetype)init {
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
    // 默认开启长按识别二维码
    [self.webloader.view addGestureRecognizer:self.longpressGesture];
    
    // 检测API在当前版本是否可用
    [self registerHandlerName:@"canIUse" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"canIUse"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"canIUse" result:dic];
            return ;
        };
        
        NSString *apiName = [data objectForKey:@"api"];
        if (![self.handlesDic objectForKey:apiName]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"暂不支持此API" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"canIUse" result:dic];
            return ;
        }
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"API可用" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"canIUse" result:dic];
    }];
    
    
    // 扫一扫
    [self registerHandlerName:@"scan" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"scan"];
        [BWTNativeUtil scan:^(NSString * _Nonnull qrcode) {
            if (!qrcode || qrcode.length == 0) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"二维码扫描失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"scan" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"qrcode":qrcode}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"scan" result:dic];
        }];
        
    }];
    
    
    // 从相册选择图片
    [self registerHandlerName:@"albumImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"albumImage"];
        [BWTNativeUtil albumImage:^(NSString * _Nonnull path, NSString * _Nonnull base64String) {
            if (path.length == 0 || base64String.length == 0) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"从相册选择图片失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"albumImage" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"path":path, @"base64String": base64String}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"albumImage" result:dic];
        }];
    }];
    
    
    // 通过相机拍摄图片
    [self registerHandlerName:@"cameraImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"cameraImage"];
        [BWTNativeUtil cameraImage:^(NSString * _Nonnull path, NSString * _Nonnull base64String) {
            if (path.length == 0 || base64String.length == 0) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"通过相机拍摄图片失败" result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"cameraImage" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"path":path, @"base64String": base64String}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"cameraImage" result:dic];
        }];
    }];
    
    
    // 记录日志
    [self registerHandlerName:@"logFile" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"logFile"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"logFile" result:dic];
            return ;
        };
        NSString *level = [data objectForKey:@"level"];
        NSString *msg = [data objectForKey:@"msg"];
        [BWTNativeUtil logFile:level message:msg];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"日志记录成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"logFile" result:dic];
    }];
    
    
    // 设置debug模式
    [self registerHandlerName:@"setDebug" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setDebug"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setDebug" result:dic];
            return ;
        };
        BOOL debug = [[data objectForKey:@"debug"] boolValue];
        [BWTNativeUtil setDebug:debug];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setDebug" result:dic];
    }];

    
    // 将数据存入原生缓存
    [self registerHandlerName:@"setStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setStorage"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setStorage" result:dic];
            return ;
        };
        NSString *key = [data objectForKey:@"key"];
        id value = [data objectForKey:@"value"];
        [BWTNativeUtil setStorage:key value:value];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"存储成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setStorage" result:dic];
    }];
    
    
    // 从原生缓存取值
    [self registerHandlerName:@"getStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getStorage"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"getStorage" result:dic];
            return ;
        };
        NSString *key = [data objectForKey:@"key"];
        [BWTNativeUtil getStorage:key callback:^(id  _Nonnull value) {
            if (!value) {
                value = @"";
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"value":value}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"getStorage" result:dic];
        }];
    }];
    
    
    // 从本地缓存中删除指定 key 的内容
    [self registerHandlerName:@"removeStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"removeStorage"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"removeStorage" result:dic];
            return ;
        };
        NSString *key = [data objectForKey:@"key"];
        [BWTNativeUtil removeStorage:key];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"删除成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"removeStorage" result:dic];
    }];
    
    
    // 清空本地缓存
    [self registerHandlerName:@"clearStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"clearStorage"];
        [BWTNativeUtil clearStorage];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"清理成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"clearStorage" result:dic];
    }];
    
    // 打开设置页
    [self registerHandlerName:@"openSetting" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"openSetting"];
        [BWTNativeUtil openSetting];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"打开设置成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"openSetting" result:dic];
    }];
    
    // 分享
    [self registerHandlerName:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"share"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"share" result:dic];
            return ;
        };
        NSString *type = [data objectForKey:@"type"];
        NSString *title = [data objectForKey:@"title"];
        NSString *content = [data objectForKey:@"content"];
        id image = [data objectForKey:@"image"];
        NSString *url = [data objectForKey:@"url"];
        [BWTNativeUtil share:type title:title content:content image:image url:url callback:^(BOOL success, NSString * _Nonnull message) {
            if (!success) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:message result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"share" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:message result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"share" result:dic];
        }];
    }];
    
    
    // 禁用Apple Pay
    [self registerHandlerName:@"killApplePay" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"killApplePay"];
        [BWTNativeUtil killApplePay];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"禁用Apple Pay成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"killApplePay" result:dic];
    }];
    
    
    // 允许Apple Pay
    [self registerHandlerName:@"reviveApplePay" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"reviveApplePay"];
        [BWTNativeUtil reviveApplePay];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"允许Apple Pay成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"reviveApplePay" result:dic];
    }];
    
    
    // 设置本地推送
    [self registerHandlerName:@"setLocalNotification" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setLocalNotification"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setLocalNotification" result:dic];
            return ;
        };
        NSString *notifyId = [data objectForKey:@"notifyId"];
        NSString *notifyText = [data objectForKey:@"notifyText"];
        NSNumber *notifyTime = [data objectForKey:@"notifyTime"];
        [BWTNativeUtil setLocalNotification:notifyId notifyText:notifyText notifyTime:notifyTime];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置本地推送成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"setLocalNotification" result:dic];
    }];
    
    // 取消本地推送
    [self registerHandlerName:@"cancelLocalNotification" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"cancelLocalNotification"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"cancelLocalNotification" result:dic];
            return ;
        };
        NSString *notifyId = [data objectForKey:@"notifyId"];
        [BWTNativeUtil cancelLocalNotification:notifyId];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"取消本地推送成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"cancelLocalNotification" result:dic];
    }];
    
    
    // 设置待办事项
    [self registerHandlerName:@"setCalendar" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"setCalendar"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setCalendar" result:dic];
            return ;
        };
        NSString *calendarId = [data objectForKey:@"calendarId"];
        NSString *calendarText = [data objectForKey:@"calendarText"];
        NSString *calendarTime = [data objectForKey:@"calendarTime"];
        [BWTNativeUtil setCalendar:calendarId calendarText:calendarText calendarTime:calendarTime callback:^(BOOL success, NSString * _Nonnull message) {
            if (!success) {
                NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:message result:nil];
                responseCallback(dic);
                [BWTNativeUtil logEnd:@"setCalendar" result:dic];
                return ;
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"设置待办事项成功" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"setCalendar" result:dic];
        }];
    }];
    
    
    // 取消代办事件
    [self registerHandlerName:@"cancelCalendar" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"cancelCalendar"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"cancelCalendar" result:dic];
            return ;
        };
        NSString *calendarId = [data objectForKey:@"calendarId"];
        [BWTNativeUtil cancelCalendar:calendarId];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"取消待办事项成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"cancelCalendar" result:dic];
    }];
    
    // 增加长按识别二维码
    [self registerHandlerName:@"openLongPressQRCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"openLongPressQRCode"];
        [weakSelf.webloader.view removeGestureRecognizer:self.longpressGesture];
        [weakSelf.webloader.view addGestureRecognizer:self.longpressGesture];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"增加长按识别二维码成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"openLongPressQRCode" result:dic];
    }];
    
    // 取消长按识别二维码
    [self registerHandlerName:@"cancelLongPressQRCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"cancelLongPressQRCode"];
        [weakSelf.webloader.view removeGestureRecognizer:self.longpressGesture];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"取消长长按识别二维码成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"cancelLongPressQRCode" result:dic];
    }];
    
    // 埋点
    [self registerHandlerName:@"buryingPoint" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"buryingPoint"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"buryingPoint" result:dic];
            return ;
        };
        
        NSString *pointName = [NSString stringWithFormat:@"%@", [data objectForKey:@"name"]];
        [BWTNativeUtil buryingPoint:pointName];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"埋点执行成功" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"buryingPoint" result:dic];
    }];
    
    // 获取步数
    [self registerHandlerName:@"getTodayStepCounter" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"getTodayStepCounter"];
        [[PedometerManager.sharedPedometerManager queryPedometer:0] subscribeNext:^(NSArray *array) {
            NSDictionary *dic = [array firstObject];
            NSString *stepNumber = [dic ajObjectForKey:@"step_number"];
            NSDictionary *result = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"stepCount":ISNIL(stepNumber)}];
            responseCallback(result);
            [BWTNativeUtil logEnd:@"getTodayStepCounter" result:result];
        } error:^(NSError * _Nullable error) {
            NSDictionary *result = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"stepCount":ISNIL(@"0")}];
            responseCallback(result);
            [BWTNativeUtil logEnd:@"getTodayStepCounter" result:result];
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)longPressed:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIImage *screenShootImage = [self p_nomalSnapshotImage];
    NSString *qrStr = [BWTQRCodeTools decodingWithImage:screenShootImage.CGImage];
    if (!qrStr) {
        return;
    }
    [BWTPopupTool actionSheetWithCustomAction:@"取消" actionArray:@[@"识别屏幕中的二维码"] handler:^(NSInteger actionTag, NSString * _Nonnull actionTitle) {
        if (actionTag == 0) {
            BWTScanViewModel *vm = [[BWTScanViewModel alloc] init];
            [vm.queryQrcodeInfoCommand execute:qrStr];
        }
    }];
//    [self.nativeApp longPressRecognition:screenShootImage];
}

- (UILongPressGestureRecognizer *)longpressGesture {
    if (!_longpressGesture) {
        _longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        _longpressGesture.delegate = self;
    }
    return _longpressGesture;
}

- (UIImage *)p_nomalSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.webloader.view.frame.size, NO, 2);
    [self.webloader.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (void)dealloc {
    NSLog(@"<BWTJSUtilApi>dealloc");
}

@end
