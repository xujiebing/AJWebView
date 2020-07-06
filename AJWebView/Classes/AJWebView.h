//
//  AJWebView.h
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/4.
//

#ifndef AJWebView_h
#define AJWebView_h

#import <AJKit/AJKit.h>

#import "AJBaseWebLoader.h"
#import "AJRegisterBaseClass.h"

static NSString * const AJWebviewModuleName = @"AJWebView";
static UIImage *AJWebViewImage(NSString *imageName) {
    return AJImage(imageName, AJWebviewModuleName);
}

#endif /* AJWebView_h */
