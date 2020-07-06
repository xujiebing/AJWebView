//
//  AJBaseWebLoader.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/4.
//

#import "AJBaseWebLoader.h"
#import <WebKit/WebKit.h>
#import <AJWebView/AJWebViewJSBridge.h>
#import <AJWebView/AJBaseWebCacheTools.h>

static NSString *KVOContext;
static UIColor *kProgressColor;

@interface AJBaseWebLoader () <WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate>
/** JSBridge */
@property (nonatomic, strong) AJWebViewJSBridge *bridge;
/** 页面加载进度条 */
@property (nonatomic, weak) UIProgressView *progressView;
/** 加载进度条的高度约束 */
@property (nonatomic, strong) NSLayoutConstraint *progressH;
/** 导航栏左上角页面返回按钮 */
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
/** 导航栏左上角按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;

@end

@implementation AJBaseWebLoader

#pragma mark --- 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建WKWebView
    [self createWKWebView];
    
    // 注册KVO
    [self.wv addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:&KVOContext];
    [self.wv addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:&KVOContext];
    
    // 注册框架API
    [self.bridge registerFrameAPI];
    
    // 加载H5页面
    [self loadHTML];
    
    // 重写返回按钮事件
    [self p_backButton];
    
    // 监听重定向
    /// TODO:待开发
//    kRACWeakSelf
//    [[RACObserve(self.wv, canGoBack) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
//        kRACStrongSelf
//        [self setCloseBarBtn];
//    }];
    
//    // 是否隐藏导航栏
//    NSNumber *hideNavigationBar = [self.params ajObjectForKey:@"hidenavigationbar"];
//    if ([hideNavigationBar boolValue]) {
//        [BWTNativeNavigator hide];
//    } else {
//        [BWTNativeNavigator show];
//    }
//
//    // 是否隐藏状态栏
//    NSNumber *hidestatusbar = [self.params ajObjectForKey:@"hidestatusbar"];
//    if ([hidestatusbar boolValue]) {
//        [BWTNativeNavigator hideStatusBar];
//    } else {
//        [BWTNativeNavigator showStatusBar];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.params ajObjectForKey:@"usecache"]) {
        [AJBaseWebCacheTools configWKWebViewCache:[self.params ajObjectForKey:@"url"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 是否禁用缓存
    if ([self.params ajObjectForKey:@"usecache"]) {
        [AJBaseWebCacheTools unConfigWKWebViewCache:[self.params ajObjectForKey:@"url"]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BWTWebViewAppear" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BWTWebViewDisappear" object:nil];
}

- (void)setParameter:(NSDictionary *)params {
    self.params = params;
    
    // 改变User-Agent。必须在 setParameter 这么早的时候就做这件事情，等到 viewDidLoad 就来不及了
    [self p_appendUserAgent];
}

/**
 创建WKWebView
 */
- (void)createWKWebView {
    // 创建进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    NSNumber *hideProgress = [self.params ajObjectForKey:@"hideprogress"];
    progressView.progressTintColor = [hideProgress boolValue] ? [UIColor clearColor] : AJUIColorFrom10RGB(8, 122, 250);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
                                ]];
    NSLayoutConstraint *progressH = [NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1.5];
    self.progressH = progressH;
    [progressView addConstraint:self.progressH];
    
    // 创建webView容器
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentVC = [[WKUserContentController alloc] init];
    webConfig.userContentController = userContentVC;
    WKWebView *wk = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
    NSNumber *scrollenable = [self.params ajObjectForKey:@"scrollenable"];
    if (!scrollenable) {
        scrollenable = @(1);
    }
    wk.scrollView.scrollEnabled = [scrollenable boolValue];
    [self.view addSubview:wk];
    self.wv = wk;
    self.wv.navigationDelegate = self;
    self.wv.UIDelegate = self;
    self.wv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设置约束
    [self.view addConstraints:@[// left
                                [NSLayoutConstraint constraintWithItem:self.wv attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                // bottom
                                [NSLayoutConstraint constraintWithItem:self.wv attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                // right
                                [NSLayoutConstraint constraintWithItem:self.wv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                // top
                                [NSLayoutConstraint constraintWithItem:self.wv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:progressView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                ]];
    
    //jsBridge
    self.bridge = [AJWebViewJSBridge bridgeForWebView:self.wv];
    [self.bridge setWebViewDelegate:self];
    
    [self.wv.configuration.userContentController addScriptMessageHandler:self.bridge name:@"WKWebViewJavascriptBridge"];
}

//改变User-Agent
- (void)p_appendUserAgent {
    //获取默认UA
    NSString *defaultUA = [[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    if ([defaultUA rangeOfString:@"BWTJSBridge/"].length > 0) {
        return; // 已有BWT标识，则不用再添加
    }
    
    //设置UA格式，和h5约定
    NSString *customerUA = @"AJJSBridge/1.0.0";
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customerUA}];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)p_backButton {
    kAJWeakSelf
    [self.navigationItem ajAddLeftButtonWithImage:AJWebViewImage(@"ajwebview_icon_back") callback:^{
        [ajSelf backBtnAction:nil];
    }];
}

- (void)loadHTML {
    NSString *url = [self.params ajObjectForKey:@"url"];
    if (url.ajHasChinese) {
        url = url.ajURLEncode;
    }
    if ([url hasPrefix:@"http"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        [self.wv loadRequest:request];
    } else {
        // 加载本地页面，iOS 9以下不支持
        NSURL *bundleUrl = [[NSBundle mainBundle] bundleURL];
        NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:url withExtension:@""];
        [self.wv loadFileURL:pathUrl allowingReadAccessToURL:bundleUrl];
    }
}

#pragma mark --- KVO

/**
 KVO监听的相应方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 判断是否是本类注册的KVO
    if (context == &KVOContext) {
        // 设置title
        if ([keyPath isEqualToString:@"title"]) {
            NSString *title = change[@"new"];
            NSString *titleStr = [self.params ajObjectForKey:@"title"];
            self.navigationItem.title = titleStr ? titleStr : title;
        }
        // 设置进度
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            NSNumber *progress = change[@"new"];
            self.progressView.progress = progress.floatValue;
            if (progress.floatValue == 1.0) {
                self.progressH.constant = 0;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark --- WKNavigationDelegate

//这个代理方法不实现也能正常跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        //支持 a 标签 target = ‘_blank’ ;
        if (navigationAction.targetFrame == nil) {
            [self openWindow:navigationAction];
        } else if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
            [self setCloseBarBtn];
        }
        
        NSURL *navigationURL = navigationAction.request.URL;
        //扫一扫支持iOS下载应用安装
        if ([navigationURL.absoluteString hasPrefix:@"itms-apps://"] || [navigationURL.absoluteString containsString:@"itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:navigationURL];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if ([navigationURL.absoluteString hasPrefix:@"tel:"]) {
            [[UIApplication sharedApplication] openURL:navigationURL];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if ([navigationURL.absoluteString hasPrefix:@"weixin:"]) {
            [[UIApplication sharedApplication] openURL:navigationURL];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if ([navigationURL.absoluteString isEqualToString:@"about:blank"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else if ([navigationURL.absoluteString hasPrefix:@"data:"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else if ([navigationURL.absoluteString hasPrefix:@"file:"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

/// 特殊跳转
- (void)openWindow:(WKNavigationAction *)navigationAction {
    self.progressView.progress = 0;
    self.progressH.constant = 1;
    [self.wv loadRequest:navigationAction.request];
}

- (void)setCloseBarBtn {
    if (!self.wv.canGoBack) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[];
        [self p_backButton];
        return;
    }
    
    if (!self.closeButtonItem) {
        self.closeButtonItem = [[UIBarButtonItem alloc] initWithImage:AJWebViewImage(@"ajwebview_icon_close") style:(UIBarButtonItemStylePlain) target:self action:@selector(closeBtnAction:)];
    }
    if (!self.leftBarButtonItem) {
        self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:AJWebViewImage(@"ajwebview_icon_back") style:(UIBarButtonItemStylePlain) target:self action:@selector(backBtnAction:)];;
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.leftBarButtonItems = @[self.leftBarButtonItem, self.closeButtonItem];
}

- (void)backBtnAction:(id)sender {
    if ([self.bridge containObjectForKeyInCacheDicWithModuleName:@"navigator" KeyName:@"hookBackBtn"]) {
        WVJBResponseCallback backCallback = (WVJBResponseCallback)[self.bridge objectForKeyInCacheDicWithModuleName:@"navigator" KeyName:@"hookBackBtn"];
        NSDictionary *dic = @{@"code":@1, @"msg":@"Native pop Action"};
        backCallback(dic);
    } else if (self.wv.canGoBack) {
        [self setCloseBarBtn];
        [self.wv goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

//重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self setCloseBarBtn];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // ErroeCode
    // -1001 请求超时   -1009 似乎已断开与互联网的连接
    if (error.code == -1009) {
        NSLog(@"似乎已断开与互联网的连接");
        return;
    }
    if (error.code == -1001) {
        NSLog(@"请求超时");
        return;
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //页面加载异常
    NSString *url = [self.params objectForKey:@"url"];
    //反馈页面加载错误
    [self.bridge handleErrorWithCode:0 errorUrl:url errorDescription:error.localizedDescription];
}

// https校验
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

#pragma mark --- WKUIDelegate

/// WebVeiw关闭
- (void)webViewDidClose:(WKWebView *)webView {
    
}

/// 显示一个JavaScript警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 显示一个JavaScript确认面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alertController addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 显示一个JavaScript文本输入面板
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- AJJSPageApi

/// 刷新方法
- (void)reloadWKWebview {
    [self.wv reload];
}

#pragma mark -- AJJSNavigatorApi

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.bridge containObjectForKeyInCacheDicWithModuleName:@"navigator" KeyName:@"hookSysBack"]) {
        WVJBResponseCallback sysBackCallback = (WVJBResponseCallback)[self.bridge objectForKeyInCacheDicWithModuleName:@"navigator" KeyName:@"hookSysBack"];
        NSDictionary *dic = @{@"code":@1, @"msg":@"Native pop Action"};
        sysBackCallback(dic);
    }
    [self backBtnAction:nil];
    return NO;
}

#pragma mark --- MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- AJJSAuthApi

/// 注册自定义API的方法
- (BOOL)registerHandlersWithClassName:(NSString *)className moduleName:(NSString *)moduleName {
    return [self.bridge registerHandlersWithClassName:className moduleName:moduleName];
}

- (void)dealloc {
    [self.wv.configuration.userContentController removeScriptMessageHandlerForName:@"WKWebViewJavascriptBridge"];
    [self.wv.configuration.userContentController removeAllUserScripts];
    [self.wv removeObserver:self forKeyPath:@"title" context:&KVOContext];
    [self.wv removeObserver:self forKeyPath:@"estimatedProgress" context:&KVOContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"<AJBaseWebLoader>dealloc");
}

@end
