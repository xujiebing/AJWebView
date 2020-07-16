//
//  AJNaviSegmentView.h
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AJTitleClickAction)(NSInteger which);

@interface AJNaviSegmentView : UIView

/// 初始化方法
/// @param titles 标题数组
- (instancetype)initWithTitleItems:(NSArray *)titles;

/// 标题点击回调block
@property (nonatomic, copy) AJTitleClickAction titleClickAction;

@end

NS_ASSUME_NONNULL_END
