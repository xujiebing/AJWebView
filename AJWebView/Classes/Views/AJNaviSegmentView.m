//
//  AJNaviSegmentView.m
//  AJWebView
//
//  Created by 徐结兵 on 2020/7/17.
//

#import "AJNaviSegmentView.h"

@interface AJNaviSegmentView ()

@property (nonatomic, strong) UISegmentedControl *segment;

@end

@implementation AJNaviSegmentView

- (instancetype)initWithTitleItems:(NSArray *)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.segment = [[UISegmentedControl alloc] initWithItems:titles];
        self.segment.selectedSegmentIndex = 0;
        [self.segment addTarget:self action:@selector(p_changeSegValue:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.segment];
        self.frame = self.segment.bounds;
    }
    return self;
}

- (void)p_changeSegValue:(UISegmentedControl *)sender {
    if (self.titleClickAction) {
        self.titleClickAction(sender.selectedSegmentIndex);
    }
}

@end
