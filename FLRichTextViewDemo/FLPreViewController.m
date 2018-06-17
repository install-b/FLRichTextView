//
//  FLPreViewController.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/15.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLPreViewController.h"

@interface FLPreViewController ()<UIWebViewDelegate>
/* <#des#> */
@property (nonatomic,weak) UIWebView * contentView;
@end

@implementation FLPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)loadHTLMString:(NSString *)html {
    [self.contentView loadHTMLString:html baseURL:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        return NO;
    }
    return YES;
}

- (UIWebView *)contentView {
    if (!_contentView) {
        CGRect frame = self.view.bounds;

        UIWebView *label = [[UIWebView alloc] initWithFrame:frame];
        label.delegate = self;
        _contentView = label;
        
        [self.view addSubview:label];
    }
    return _contentView;
}
@end
