//
//  NSString+FLEditorHTML.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FLEditorHTML)

/**
 加载 编辑器 HTML 及 JS 库
 
 @return HTML source
 */
+ (NSString *)fl_loadEditorHTMLString;

// 移除引用格式
- (NSString *)fl_htmlStringRemoveQuotes;

// 获取URL 格式
- (NSString *)fl_stringByDecodingURLFormat;

@end
