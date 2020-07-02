//
//  BWTJSUIApi.m
//  BWTHybridWebview
//
//  Created by ccc's MacBook Pro on 2019/5/31.
//  Copyright © 2019 com.quickhybrid. All rights reserved.
//

#import "BWTJSUIApi.h"

@implementation BWTJSUIApi

- (instancetype)init {
    return [super init];
}

- (void)registerHandlers {
    __weak typeof(self) weakSelf = self;
    
    // toast
    [self registerHandlerName:@"toast" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"toast"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"toast" result:dic];
            return ;
        };
        
        NSString *message = [data objectForKey:@"message"];
        [BWTNativeUI toast:message];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"toast" result:dic];
    }];
    
    // alert
    [self registerHandlerName:@"alert" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"alert"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"alert" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *message = [data objectForKey:@"message"];
        NSString *buttonName = [data objectForKey:@"buttonName"];
        BOOL cancelable = [[data objectForKey:@"cancelable"] boolValue];
        
        [BWTNativeUI alert:title message:message buttonName:buttonName cancelable:cancelable handler:^{
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"alert" result:dic];
        }];
    }];
    
    // confirm
    [self registerHandlerName:@"confirm" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"confirm"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"confirm" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *message = [data objectForKey:@"message"];
        NSArray *buttonLabels = [data objectForKey:@"buttonLabels"];
        BOOL cancelable = [[data objectForKey:@"cancelable"] boolValue];
        
        [BWTNativeUI confirm:title message:message buttonLabels:buttonLabels cancelable:cancelable handler:^(NSNumber *index){
            if (!index) {
                index = @(0);
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"confirm" result:dic];
        }];
    }];
    
    // prompt
    [self registerHandlerName:@"prompt" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"prompt"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"prompt" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *hint = [data objectForKey:@"hint"];
        NSString *text = [data objectForKey:@"text"];
        NSNumber *line = [data objectForKey:@"line"];
        NSNumber *maxLength = [data objectForKey:@"maxLength"];
        NSArray *buttonLabels = [data objectForKey:@"buttonLabels"];
        BOOL cancelable = [[data objectForKey:@"cancelable"] boolValue];
        
        [BWTNativeUI prompt:title hint:hint text:text lines:line maxLength:maxLength buttonLabels:buttonLabels cancelable:cancelable handler:^(NSNumber * _Nonnull index, NSString * _Nonnull text) {
            if (!index) {
                index = @(0);
            }
            if (!text) {
                text = @"";
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index, @"text":text}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"prompt" result:dic];
        }];
    }];
    
    
    // showWaiting
    [self registerHandlerName:@"showWaiting" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"showWaiting"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"showWaiting" result:dic];
            return ;
        };
        
        NSString *message = [data objectForKey:@"message"];
        [BWTNativeUI showWaiting:message];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"showWaiting" result:dic];
    }];
    
    
    // closeWaiting
    [self registerHandlerName:@"closeWaiting" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"closeWaiting"];
        [BWTNativeUI closeWaiting];
        NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:nil];
        responseCallback(dic);
        [BWTNativeUtil logEnd:@"closeWaiting" result:dic];
    }];
    
    
    // actionSheet
    [self registerHandlerName:@"actionSheet" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"actionSheet"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"actionSheet" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSArray *items = [data objectForKey:@"items"];
        NSString *cancelTitle = [data objectForKey:@"cancelTitle"];
        BOOL cancelable = [[data objectForKey:@"cancelable"] boolValue];
        [BWTNativeUI actionSheet:title items:items cancelTitle:cancelTitle cancelable:cancelable handler:^(NSNumber * _Nonnull index) {
            if (!index) {
                index = @(0);
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"index":index}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"actionSheet" result:dic];
        }];
    }];
    
    
    // pickDate
    [self registerHandlerName:@"pickDate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"pickDate"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickDate" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *datetime = [data objectForKey:@"datetime"];
        [BWTNativeUI pickDate:title datetime:datetime handler:^(NSString * _Nonnull selectDate) {
            if (!selectDate) {
                selectDate = @"";
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"date":selectDate}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickDate" result:dic];
        }];
    }];
    
    
    // pickTime
    [self registerHandlerName:@"pickTime" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"pickTime"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickTime" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *datetime = [data objectForKey:@"datetime"];
        [BWTNativeUI pickTime:title datetime:datetime handler:^(NSString * _Nonnull selectTime) {
            if (!selectTime) {
                selectTime = @"";
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"time":selectTime}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickTime" result:dic];
        }];
    }];
    
    
    // pickDateTime
    [self registerHandlerName:@"pickDateTime" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"pickDateTime"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickDateTime" result:dic];
            return ;
        };
        
        NSString *title = [data objectForKey:@"title"];
        NSString *datetime = [data objectForKey:@"datetime"];
        [BWTNativeUI pickDateTime:title datetime:datetime handler:^(NSString * _Nonnull selectDateTime) {
            if (!selectDateTime) {
                selectDateTime = @"";
            }
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"datetime":selectDateTime}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"pickDateTime" result:dic];
        }];
    }];
    
    
    // popPicker
    [self registerHandlerName:@"popPicker" handler:^(id data, WVJBResponseCallback responseCallback) {
        [BWTNativeUtil logStart:@"popPicker"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [weakSelf responseDicWithCode:NO Msg:@"数据格式异常" result:nil];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"popPicker" result:dic];
            return ;
        };
        
        NSNumber *layer = [data objectForKey:@"layer"];
        NSArray *datas = [data objectForKey:@"data"];
        [BWTNativeUI popPicker:layer data:datas handler:^(NSArray * _Nonnull indexs, NSArray * _Nonnull items) {
            NSDictionary *dic = [weakSelf responseDicWithCode:YES Msg:@"" result:@{@"indexs":indexs, @"items":items}];
            responseCallback(dic);
            [BWTNativeUtil logEnd:@"popPicker" result:dic];
        }];
    }];
    
}

- (void)dealloc {
    NSLog(@"<BWTJSUIApi>dealloc");
}

@end
