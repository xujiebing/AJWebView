//
//  BWTHybridWebview.h
//  BWTHybridWebview
//
//  Created by 徐结兵 on 2020/2/11.
//

#ifndef BWTHybridWebview_h
#define BWTHybridWebview_h

#import <BWTBaseAbility/BWTQRCodeTools.h>
#import <BWTBaseAbility/BWTShareTools.h>
#import <BWTBaseAbility/BWTInvalidApplePay.h>
#import <BWTBaseAbility/BWTLocationTools.h>
#import <BWTCommonAbility/BWTScan.h>
#import <BWTCommonAbility/BWTRouter.h>
#import <BWTBaseFramework/BWTKit.h>
#import <BWTBaseUI/BWTBaseUI.h>
#import <BWTBaseBusiness/BWTBaseBusiness.h>
#import <BWTPedometer/BWTPedometer.h>
#import <EventKit/EventKit.h>
#import "BWTNativeUtil.h"
#import "BWTNativeUser.h"
#import "BWTNativeUI.h"
#import "BWTNativeRuntime.h"
#import "BWTNativePage.h"
#import "BWTBaseWebLoader.h"
#import "BWTNativeNavigator.h"
#import "BWTNativeDevice.h"
#import "BWTBluetoothTools.h"
#import "BWTToast.h"
#import "BWTDatePickViewController.h"
#import "BWTNaviTitleView.h"
#import "BWTNaviSegmentView.h"
#import "WebViewJavascriptBridgeBase.h"
#import "BWTRegisterBaseClass.h"
#import "BWTBaseWebCacheProtocol.h"
#import "NSURLProtocol+BWTBaseWeb.h"
#import "WKWebViewJavascriptBridge.h"
#import "BWTBaseWebCacheTools.h"

static NSString * const BWTHybridWebviewModuleName = @"BWTHybridWebview";
static UIImage *BWTHybridWebviewImage(NSString *imageName) {
    return BWTImage(imageName, BWTHybridWebviewModuleName);
}

#endif /* BWTHybridWebview_h */
