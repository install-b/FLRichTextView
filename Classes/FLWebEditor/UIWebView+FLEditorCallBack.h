//
//  UIWebView+FLEditorCallBack.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/19.
//  Copyright © 2018年 Flame. All rights reserved.
//

/*
 * 该分类为用于JS 反调 OC 的方法
 */


#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


typedef void(^FLContentUpdateCallback)(JSValue *jsValue);



/**
 请求拦截时间代理协议
 */
@protocol FLEditorJSCallObjcDelegate <NSObject>
// js debug msg
- (void)fl_editorCallDebug:(NSString *)debugString;

// scroll position call back
- (void)fl_editorDidScrollWithPosition:(NSInteger)position;

// custom message
- (void)fl_editorCallBackMessage:(NSString *)msg;
@end



@interface UIWebView (FLEditorCallBack)

/**
 
  set call back when text did change   //>  监听文本变化
 
   **** it must call before webview did finishLoad ***

 @param callBack call back block （use JSContext by KVC）
 */
- (void)fl_setContentUpdateCallback:(FLContentUpdateCallback)callBack;



/**
 set call back delegate when js send request
 
  *** 在 webview 请求拦截代理方法中调用  ***

 @param request 即将发送的请求
 @param navigationType navigationType
 @param jsDelegate 处理这些请求的对象
 @return 是否为正常的请求  NO非正常的请求  返回YES正常的请求
 */
- (BOOL)fl_shoudLoadRequest:(NSURLRequest *)request
             navigationType:(UIWebViewNavigationType)navigationType
           JsCallOCDelegate:(id <FLEditorJSCallObjcDelegate>)jsDelegate;

@end
