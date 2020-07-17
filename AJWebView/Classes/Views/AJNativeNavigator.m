//
//  AJNativeNavigator.m
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import "AJNativeNavigator.h"
#import "AJNaviTitleView.h"
#import "AJNaviSegmentView.h"

/** 导航栏左上角按钮，1在左，2在右 */
static UIBarButtonItem *leftBarButtonItem1;
/** 导航栏左上角按钮，1在左，2在右 */
static UIBarButtonItem *leftBarButtonItem2;
/** 导航栏右上角按钮，1在右，2在左 */
static UIBarButtonItem *rightBarButtonItem1;
/** 导航栏右上角按钮，1在右，2在左 */
static UIBarButtonItem *rightBarButtonItem2;

static NSArray *defaultLeftItems;

@implementation AJNativeNavigator

+ (void)clear {
    leftBarButtonItem1 = nil;
    leftBarButtonItem2 = nil;
    rightBarButtonItem1 = nil;
    rightBarButtonItem2 = nil;
    defaultLeftItems = nil;
}

+ (void)setNavTitle:(NSString *)title
           subTitle:(NSString *)subTitle
          clickable:(BOOL)clickable
          direction:(NSString *)direction
                 vc:(UIViewController *)vc
            handler:(void (^)(void))handler {
    AJNaviTitleView *titleView = [[AJNaviTitleView alloc] initWithMainTitle:title subTitle:subTitle clickable:clickable direction:direction];
    titleView.clickAction = ^(BOOL click) {
        if (handler) {
            handler();
        }
    };
    vc.navigationItem.titleView = titleView;
}

+ (void)setMultiTitle:(NSArray *)titles
                   vc:(UIViewController *)vc
              handler:(void (^)(NSNumber * _Nonnull))handler {
    AJNaviSegmentView *segView = [[AJNaviSegmentView alloc] initWithTitleItems:titles];
    segView.titleClickAction = ^(NSInteger index) {
        if (handler) {
            handler(@(index));
        }
    };
    vc.navigationItem.titleView = segView;
}

+ (void)showWithVC:(UIViewController *)vc {
    [vc.navigationController setNavigationBarHidden:NO];
}

+ (void)hideWithVC:(UIViewController *)vc {
    [vc.navigationController setNavigationBarHidden:YES];
}

+ (void)setLeftBtn:(NSString *)text
          imageUrl:(NSString *)imageUrl
             index:(NSNumber *)index
            isShow:(BOOL)isShow
                vc:(UIViewController *)vc
           handler:(void (^)(NSNumber * _Nonnull))handler {
    if ([index integerValue] == 1) {
        if (text && !imageUrl) {
            leftBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStylePlain) target:self action:nil];
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [[UIImage imageWithData:imageData] ajRealCompressToSize:CGSizeMake(22, 22)];
            if (imageData) {
                leftBarButtonItem1 = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:nil];
            } else {
                leftBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:(UIBarButtonItemStylePlain) target:self action:nil];
            }
        }
        leftBarButtonItem1.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            if (handler) {
                handler(@(1));
            }
            return [RACSignal empty];
        }];
    } else {
        if (text && !imageUrl) {
            leftBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStylePlain) target:self action:nil];
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [[UIImage imageWithData:imageData] ajRealCompressToSize:CGSizeMake(22, 22)];
            if (imageData) {
                leftBarButtonItem2 = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:nil];
            } else {
                leftBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:(UIBarButtonItemStylePlain) target:self action:nil];
            }
        }
        leftBarButtonItem2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            if (handler) {
                handler(@(0));
            }
            return [RACSignal empty];
        }];
    }
    vc.navigationItem.leftBarButtonItem = nil;
    vc.navigationItem.leftBarButtonItems = @[];
    
    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:1];
    if (leftBarButtonItem2) {
        [itemArr addObject:leftBarButtonItem2];
    }
    if (leftBarButtonItem1) {
        [itemArr addObject:leftBarButtonItem1];
    }
    if (itemArr.count == 2) {
        vc.navigationItem.leftBarButtonItems = itemArr;
    } else if (itemArr.count == 1) {
        vc.navigationItem.leftBarButtonItem = [itemArr firstObject];
    }
}

+ (void)setRightBtn:(NSString *)text
           imageUrl:(NSString *)imageUrl
              index:(NSNumber *)index
             isShow:(BOOL)isShow
                 vc:(UIViewController *)vc
            handler:(void (^)(NSNumber * _Nonnull))handler {
    if ([index integerValue] == 1) {
        if (text && !imageUrl) {
            rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStylePlain) target:self action:nil];
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [[UIImage imageWithData:imageData] ajRealCompressToSize:CGSizeMake(22, 22)];
            if (imageData) {
                rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:nil];
            } else {
                rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:(UIBarButtonItemStylePlain) target:self action:nil];
            }
        }
        rightBarButtonItem1.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            if (handler) {
                handler(@(1));
            }
            return [RACSignal empty];
        }];
    } else {
        if (text && !imageUrl) {
            rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStylePlain) target:self action:nil];
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [[UIImage imageWithData:imageData] ajRealCompressToSize:CGSizeMake(22, 22)];
            if (imageData) {
                rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:nil];
            } else {
                rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:(UIBarButtonItemStylePlain) target:self action:nil];
            }
        }
        rightBarButtonItem2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            if (handler) {
                handler(@(0));
            }
            return [RACSignal empty];
        }];
    }
    vc.navigationItem.rightBarButtonItem = nil;
    vc.navigationItem.rightBarButtonItems = @[];
    
    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:1];
    if (rightBarButtonItem2) {
        [itemArr addObject:rightBarButtonItem2];
    }
    if (rightBarButtonItem1) {
        [itemArr addObject:rightBarButtonItem1];
    }
    if (itemArr.count == 2) {
        vc.navigationItem.rightBarButtonItems = itemArr;
    } else if (itemArr.count == 1) {
        vc.navigationItem.rightBarButtonItem = [itemArr firstObject];
    }
}

+ (void)hideRightBtn:(NSNumber *)index
                  vc:(UIViewController *)vc {
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:vc.navigationItem.rightBarButtonItems];
    BOOL changed = NO;
    if ([index integerValue] == 0 && [itemArr containsObject:rightBarButtonItem2] && rightBarButtonItem2) {
        [itemArr removeObject:rightBarButtonItem2];
        changed = YES;
    }
    if ([index integerValue] == 1 && [itemArr containsObject:rightBarButtonItem1] && rightBarButtonItem1) {
        [itemArr removeObject:rightBarButtonItem1];
        changed = YES;
    }
    if (changed) {
        vc.navigationItem.rightBarButtonItem = nil;
        vc.navigationItem.rightBarButtonItems = @[];
        if (itemArr.count == 2) {
            vc.navigationItem.rightBarButtonItems = itemArr;
        } else if (itemArr.count == 1) {
            vc.navigationItem.rightBarButtonItem = [itemArr firstObject];
        }
    }
}

+ (void)showRightBtn:(NSNumber *)index
                  vc:(UIViewController *)vc {
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:vc.navigationItem.rightBarButtonItems];
    BOOL changed = NO;
    if ([index integerValue] == 0 && ![itemArr containsObject:rightBarButtonItem2] && rightBarButtonItem2) {
        [itemArr insertObject:rightBarButtonItem2 atIndex:0];
        changed = YES;
    }
    if ([index integerValue] == 1 && ![itemArr containsObject:rightBarButtonItem1] && rightBarButtonItem1) {
        [itemArr addObject:rightBarButtonItem1];
        changed = YES;
    }
    if (changed) {
        vc.navigationItem.rightBarButtonItem = nil;
        vc.navigationItem.rightBarButtonItems = @[];
        if (itemArr.count == 2) {
            vc.navigationItem.rightBarButtonItems = itemArr;
        } else if (itemArr.count == 1) {
            vc.navigationItem.rightBarButtonItem = [itemArr firstObject];
        }
    }
}

+ (void)hideLeftBtn:(NSNumber *)index
                 vc:(UIViewController *)vc {
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:vc.navigationItem.leftBarButtonItems];
    BOOL changed = NO;
    if ([index integerValue] == 0 && [itemArr containsObject:leftBarButtonItem2] && leftBarButtonItem2) {
        [itemArr removeObject:leftBarButtonItem2];
        changed = YES;
    }
    if ([index integerValue] == 1 && [itemArr containsObject:leftBarButtonItem1] && leftBarButtonItem1) {
        [itemArr removeObject:leftBarButtonItem1];
        changed = YES;
    }
    if ([index integerValue] == 0 && !leftBarButtonItem1 && !leftBarButtonItem2) {
        defaultLeftItems = [itemArr copy];
        [itemArr removeAllObjects];
        changed = YES;
    }
    if (changed) {
        vc.navigationItem.leftBarButtonItem = nil;
        vc.navigationItem.leftBarButtonItems = @[];
        if (itemArr.count == 2) {
            vc.navigationItem.leftBarButtonItems = itemArr;
        } else if (itemArr.count == 1) {
            vc.navigationItem.leftBarButtonItem = [itemArr firstObject];
        }
    }
}

+ (void)showLeftBtn:(NSNumber *)index
                 vc:(UIViewController *)vc {
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:vc.navigationItem.leftBarButtonItems];
    BOOL changed = NO;
    if ([index integerValue] == 0 && ![itemArr containsObject:leftBarButtonItem2] && leftBarButtonItem2) {
        [itemArr insertObject:leftBarButtonItem2 atIndex:0];
        changed = YES;
    }
    if ([index integerValue] == 1 && ![itemArr containsObject:leftBarButtonItem1] && leftBarButtonItem1) {
        [itemArr addObject:leftBarButtonItem1];
        changed = YES;
    }
    if ([index integerValue] == 0 && !leftBarButtonItem1 && !leftBarButtonItem2 && defaultLeftItems) {
        itemArr = [NSMutableArray arrayWithArray:defaultLeftItems];
        changed = YES;
    }
    if (changed) {
        vc.navigationItem.leftBarButtonItem = nil;
        vc.navigationItem.leftBarButtonItems = @[];
        if (itemArr.count == 2) {
            vc.navigationItem.leftBarButtonItems = itemArr;
        } else if (itemArr.count == 1) {
            vc.navigationItem.leftBarButtonItem = [itemArr firstObject];
        }
    }
}

@end
