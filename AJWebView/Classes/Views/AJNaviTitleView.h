//
//  AJNaviTitleView.h
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AJClickAction)(BOOL click);

@interface AJNaviTitleView : UIView

@property (nonatomic, copy) AJClickAction clickAction;

/// 初始化方法
/// @param mainTitle 主标题
/// @param subTitle 副标题
/// @param clickable 是否可点击
/// @param direction 箭头方向 (bottom/top)
- (instancetype)initWithMainTitle:(NSString *)mainTitle
                         subTitle:(NSString *)subTitle
                        clickable:(NSInteger)clickable
                        direction:(NSString *)direction;


@end

NS_ASSUME_NONNULL_END
