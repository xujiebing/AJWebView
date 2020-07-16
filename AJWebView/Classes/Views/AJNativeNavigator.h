//
//  AJNativeNavigator.h
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJNativeNavigator : NSObject

+ (void)clear;

/**
 设置导航栏标题

 @param title 导航栏标题
 @param subTitle 导航栏副标题
 @param clickable 是否可点击，如果为1，代表可点击，会在标题右侧出现一个下拉图标，并且能被点击监听，如果为0，永远不会走到回调函数，默认为0
 @param direction 箭头的朝向，默认为bottom朝下，使用top时朝上
 @param handler 点击回调
 */
+ (void)setNavTitle:(NSString *)title
           subTitle:(NSString *)subTitle
          clickable:(BOOL)clickable
          direction:(NSString *)direction
            handler:(void (^)(void))handler;

/**
 设置多个标题（会覆盖原有的标题）

 @param titles 需要被设置的标题数组
 @param handler 点击回调
 */
+ (void)setMultiTitle:(NSArray *)titles
              handler:(void (^)(NSNumber *index))handler;

/**
 显示导航栏
 */
+ (void)show;

/**
 隐藏导航栏
 */
+ (void)hide;

/**
 显示状态栏
 */
+ (void)showStatusBar;

/**
 隐藏状态栏
 */
+ (void)hideStatusBar;

/**
 设置左侧第index个按钮，并且监听

 @param text 按钮的文本
 @param imageUrl 按钮的图片，如果设置图片了，会优先显示(覆盖原有的文本)
 @param index 默认为0，代表需要操作的是左侧第几个按钮，从最左侧开始算，最多支持两个
 @param isShow 是否显示，1代表显示，0代表隐藏，默认为1
 @param handler 点击回调
 */
+ (void)setLeftBtn:(NSString *)text
          imageUrl:(NSString *)imageUrl
             index:(NSNumber *)index
            isShow:(BOOL)isShow
           handler:(void (^)(NSNumber *index))handler;


/**
 设置右侧第index个按钮，并且监听
 
 @param text 按钮的文本
 @param imageUrl 按钮的图片，如果设置图片了，会优先显示(覆盖原有的文本)
 @param index 默认为0，代表需要操作的是右侧第几个按钮，从最右侧开始算，最多支持两个
 @param isShow 是否显示，1代表显示，0代表隐藏，默认为1
 @param handler 点击回调
 */
+ (void)setRightBtn:(NSString *)text
           imageUrl:(NSString *)imageUrl
              index:(NSNumber *)index
             isShow:(BOOL)isShow
            handler:(void (^)(NSNumber *index))handler;

/**
 隐藏右侧第index个按钮
 
 @param index 默认为0，代表需要操作的是右侧第几个按钮，从最右侧开始算，最多支持两个
 */
+ (void)hideRightBtn:(NSNumber *)index;

/**
 显示右侧第index个按钮
 
 @param index 默认为0，代表需要操作的是右侧第几个按钮，从最右侧开始算，最多支持两个
 */
+ (void)showRightBtn:(NSNumber *)index;

/**
 隐藏左侧第index个按钮
 
 @param index 默认为0，代表需要操作的是右侧第几个按钮，从最右侧开始算，最多支持两个
 */
+ (void)hideLeftBtn:(NSNumber *)index;

/**
 显示左侧第index个按钮
 
 @param index 默认为0，代表需要操作的是右侧第几个按钮，从最右侧开始算，最多支持两个
 */
+ (void)showLeftBtn:(NSNumber *)index;

@end

NS_ASSUME_NONNULL_END
