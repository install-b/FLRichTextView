//
//  UIWebView+FLEditorCallBack.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/19.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "UIWebView+FLEditorCallBack.h"


@implementation UIWebView (FLEditorCallBack)
- (void)fl_setContentUpdateCallback:(FLContentUpdateCallback)callBack {
    // 通过 kvc 获取 JSContext
    JSContext *ctx = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 设置回调
    ctx[@"contentUpdateCallback"] = callBack;
    
    // 时间绑定 事件
    [ctx evaluateScript:@"document.getElementById('fl_editor_content').addEventListener('input', contentUpdateCallback, false);"];
}


- (BOOL)fl_shoudLoadRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType JsCallOCDelegate:(id <FLEditorJSCallObjcDelegate>)jsDelegate {
    NSString *urlString = [[request URL] absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    
    else if ([urlString rangeOfString:@"callback://0/"].location != NSNotFound) {
        
        // We recieved the callback
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"callback://0/" withString:@""];
        
        [jsDelegate fl_editorCallBackMessage:className];
        
    }
    
    else if ([urlString rangeOfString:@"debug://"].location != NSNotFound) {
        
        // We recieved the callback
        NSString *debug = [urlString stringByReplacingOccurrencesOfString:@"debug://" withString:@""];
        
        debug = [debug stringByRemovingPercentEncoding];
        
        // 发现debug
        [jsDelegate fl_editorCallDebug:debug];
        
    }
    
    else if ([urlString rangeOfString:@"scroll://"].location != NSNotFound) {
        
        NSInteger position = [[urlString stringByReplacingOccurrencesOfString:@"scroll://" withString:@""] integerValue];
        [jsDelegate fl_editorDidScrollWithPosition:position];
    }
    
    return YES;
}
@end
