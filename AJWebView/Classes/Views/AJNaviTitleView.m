//
//  AJNaviTitleView.m
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import "AJNaviTitleView.h"

@interface AJNaviTitleView ()

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) NSInteger clickable;

@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *arrorImageView;

@end

@implementation AJNaviTitleView

- (instancetype)initWithMainTitle:(NSString *)mainTitle
                         subTitle:(NSString *)subTitle
                        clickable:(NSInteger)clickable
                        direction:(NSString *)direction {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.mainTitle = mainTitle;
        self.subTitle = subTitle;
        self.clickable = clickable;
        
        if (self.clickable == 1) {
            self.arrorImageView.hidden = NO;
        } else {
            self.arrorImageView.hidden = YES;
        }
        // 创建子页面
        [self createSubViews];
        
        // 设置箭头图标方向
        if (self.clickable == 1) {
            if ([direction isEqualToString:@"top"]) {
                self.arrorImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapTitleView:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)createSubViews {
    //主标题
    self.mainTitleLabel = [[UILabel alloc] init];
    self.mainTitleLabel.font = [UIFont systemFontOfSize:18];
    self.mainTitleLabel.textColor = [UIColor blackColor];
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.mainTitleLabel.text = self.mainTitle;
    [self.mainTitleLabel sizeToFit];
    [self addSubview:self.mainTitleLabel];
    
    //副标题
    if (self.subTitle.length > 0) {
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.font = [UIFont systemFontOfSize:10];
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subTitleLabel.text = self.subTitle;
        [self.subTitleLabel sizeToFit];
        [self addSubview:self.subTitleLabel];
    }
    
    //箭头图标
    if (self.clickable == 1) {
        self.arrorImageView = [[UIImageView alloc] init];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BWTWebViewBundle" ofType:@"bundle"];
        NSString *imagePath = [bundlePath stringByAppendingPathComponent:@"webveiw_downarrow.png"];
        self.arrorImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        self.arrorImageView.bounds = CGRectMake(0, 0, 15, 15);
        [self addSubview:self.arrorImageView];
    }
    
    // 设置frame
    CGFloat backgroundWidth = CGRectGetWidth(self.mainTitleLabel.bounds);
    CGFloat backgroundHeight = CGRectGetHeight(self.mainTitleLabel.bounds);
    
    if (self.subTitle.length > 0) {
        backgroundHeight += CGRectGetHeight(self.subTitleLabel.bounds);
        
        if (CGRectGetWidth(self.mainTitleLabel.bounds) > CGRectGetWidth(self.subTitleLabel.bounds)) {
            self.mainTitleLabel.frame = CGRectMake(0, 0, self.mainTitleLabel.bounds.size.width, self.mainTitleLabel.bounds.size.height);
            CGFloat subTitle_X = (self.mainTitleLabel.bounds.size.width - self.subTitleLabel.bounds.size.width) / 2;
            self.subTitleLabel.frame = CGRectMake(subTitle_X, self.mainTitleLabel.frame.size.height, self.subTitleLabel.bounds.size.width, self.subTitleLabel.bounds.size.height);
        } else {
            backgroundWidth = self.subTitleLabel.bounds.size.width;
            
            self.subTitleLabel.frame = CGRectMake(0, self.mainTitleLabel.frame.size.height, self.subTitleLabel.bounds.size.width, self.subTitleLabel.bounds.size.height);
            CGFloat mainTitle_X = (self.subTitleLabel.bounds.size.width - self.mainTitleLabel.bounds.size.width) / 2;
            self.mainTitleLabel.frame = CGRectMake(mainTitle_X, 0, self.mainTitleLabel.bounds.size.width, self.mainTitleLabel.bounds.size.height);
        }
    } else {
        self.mainTitleLabel.frame = CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    }
    
    if (self.clickable == 1) {
        self.arrorImageView.frame = CGRectMake(backgroundWidth + 12, (backgroundHeight - 15) / 2, 15, 15);
        self.frame = CGRectMake(0, 0, backgroundWidth + 12 + 15, backgroundHeight);
    } else {
        self.frame = CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    }
}

- (void)p_tapTitleView:(id)sender {
    if (self.clickable == 1 && self.clickAction) {
        self.clickAction(YES);
    }
}

@end
