//
//  AJWebViewViewController.m
//  AJWebView
//
//  Created by xujiebing on 07/01/2020.
//  Copyright (c) 2020 xujiebing. All rights reserved.
//

#import "AJWebViewViewController.h"
#import <AJWebView/AJWebView.h>

@interface AJWebViewViewController ()

@end

@implementation AJWebViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *apiName = @"test";
    NSDictionary *dic = @{@"111": @"222"};
    
    AJWebViewLogStart(apiName)
    AJWebViewLogEnd(apiName, dic)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
