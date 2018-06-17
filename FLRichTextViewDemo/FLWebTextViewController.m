//
//  FLWebTextViewController.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/14.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLWebTextViewController.h"
#import "NSString+FLEditorHTML.h"
#import "UIWebView+FLEditorRunJS.h"
#import "UIWebView+FLEditorCallBack.h"

@interface FLWebTextViewController () <UIWebViewDelegate,FLEditorJSCallObjcDelegate>
/* <#des#> */
@property (nonatomic,weak) UIWebView * editorView;
/* <#des#> */
@property (nonatomic,assign) BOOL didLoadWebEditor;
@end

@implementation FLWebTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSString *htmlStr = [NSString fl_loadEditorHTMLString];
    [self.editorView loadHTMLString:htmlStr baseURL:nil];
}
- (void)setBoldWithButton:(UIButton *)btn {
    if (_didLoadWebEditor == NO) return;
    [self.editorView fl_setBold];
}
- (void)setHeadingWithButton:(UIButton *)btn {
    if (_didLoadWebEditor == NO) return;
    [self.editorView fl_heading2];
}
- (void)insertLinkWithButton:(UIButton *)btn {
    if (_didLoadWebEditor == NO) return;
    
}
- (void)insertImageWithButton:(UIButton *)btn {
    if (_didLoadWebEditor == NO) return;
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [webView fl_shoudLoadRequest:request navigationType:navigationType JsCallOCDelegate:self];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _didLoadWebEditor = YES;
    [webView fl_setPlaceholderText:@"输入正文"];
    [webView fl_setContentUpdateCallback:^(JSValue *jsValue) {
        NSLog(@"jsValue === %@",jsValue);
    }];
    [webView fl_focusTextEditor];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
#pragma mark - call back
// js debug msg
- (void)fl_editorCallDebug:(NSString *)debugString {
    
}

// scroll position call back
- (void)fl_editorDidScrollWithPosition:(NSInteger)position {
    
}

// custom message
- (void)fl_editorCallBackMessage:(NSString *)msg {
    
}
- (NSString *)attributedHTMLText {
    return [self.editorView fl_getHTML];
}
#pragma mark -
- (UIWebView *)editorView {
    if (!_editorView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
        [self.view addSubview:webView];
        webView.keyboardDisplayRequiresUserAction = NO;
        webView.scalesPageToFit = YES;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        webView.scrollView.bounces = NO;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        _editorView = webView;
    }
    return _editorView;
}

@end
