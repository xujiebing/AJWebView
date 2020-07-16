//
//  AJWebView.h
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/4.
//

#ifndef AJWebView_h
#define AJWebView_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

#import <AJKit/AJKit.h>

#import "AJBaseWebLoader.h"
#import "AJRegisterBaseClass.h"

// 进入webView的通知
static NSString * const AJWebviewDidAppear = @"AJWebviewDidAppear";
// 离开webView的通知
static NSString * const AJWebViewDisAppear = @"AJWebViewDisAppear";
static NSString * const AJWebviewModuleName = @"AJWebView";
static UIImage *AJWebViewImage(NSString *imageName) {
    return AJImage(imageName, AJWebviewModuleName);
}

#define AJWebViewLogStart(apiName) AJLog(@"=====调用开始=====%@=====", apiName)
#define AJWebViewLogEnd(apiName, dic) AJLog(@"=====调用结果=====%@=====%@", apiName, dic) \ fprintf(stderr,"\n=====调用结束=====%@=====", apiName)

#endif /* AJWebView_h */
