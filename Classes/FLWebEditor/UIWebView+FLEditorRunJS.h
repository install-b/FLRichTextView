//
//  UIWebView+FLEditorRunJS.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

/*
 * 该分类为用于OC 桥接 JS 函数
 *  OC 操作 JS 代码
 */

#import <UIKit/UIKit.h>
#import "NSString+FLEditorHTML.h"

typedef NS_ENUM(int16_t, FLFontFamily) {
    FLFontFamilyDefault = 0,
    FLFontFamilyTrebuchet = 1,
    FLFontFamilyVerdana = 2,
    FLFontFamilyGeorgia = 3,
    FLFontFamilyPalatino = 4,
    FLFontFamilyTimesNew = 5,
    FLFontFamilyCourierNew = 6,
};

typedef NS_ENUM(int16_t, FLSetColorOptions) {
    FLSetColorTextOption        = 1,
    FLSetColorBackgroundOption  = 2,
};





@interface UIWebView (FLEditorRunJS)

#pragma mark - HTML element operation  //> 操作标签
- (NSString *)getText;
- (NSString *)fl_getHTML;
- (void)fl_updateHTML:(NSString *)html;

- (void)insertHTML:(NSString *)html;
- (NSString *)tidyHTML:(NSString *)html shouldFormat:(BOOL)isformatHTML;

// 设置占位文字
- (void)fl_setPlaceholderText:(NSString *)plcaeholder;

#pragma mark - undo redo //> 撤销、重做
- (void)fl_undo; // 撤销
- (void)fl_redo; // 取消撤销

#pragma mark - prepar to inser //> 插入操作

/**
 *  当需要弹出其他视图（如：插入链接、导入图片） 而导致webview失去当前焦点或者选择的文字时候
 *  在调用这些视图之前，先调用该方法以便将当前的焦点存储
 *  当这些视图回调插入链接或图片时， 就会将要插入的source在之前保存的焦点
 *  否则的话就会永远插入在最后面
 */
- (void)fl_prepareForInser;

#pragma mark  insert link  //> 插入链接
/**
 插入/ 修改 链接

 @param url URL
 @param title 链接展示的文字
 */
- (void)fl_insertLink:(NSString *)url title:(NSString *)title;
- (void)fl_updateLink:(NSString *)url title:(NSString *)title;

// 移除链接
- (void)fl_removeLink;
- (void)fl_quickLink;
#pragma mark insert image //> 插入图片

/**
 插入/更新  图片

 @param url 插入图片的URL
 @param alt 标识、插入时候记录该标识   更新特定的图片根据这个标识进行更新
 */
- (void)fl_insertImage:(NSString *)url alt:(NSString *)alt;
- (void)fl_updateImage:(NSString *)url alt:(NSString *)alt;

/**
 插入/更新  图片
 
 @param imageBase64String 插入图片的Base64 String
 @param alt 标识、插入时候记录该标识   更新特定的图片根据这个标识进行更新
 */
- (void)fl_insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt;
- (void)fl_updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt;



#pragma mark - set html styles //> 修改样式
// 更新 css 样式
- (void)fl_updateCSS:(NSString *)css;
- (void)fl_removeFormat;


// 设置选中文字的颜色、字体
- (void)fl_setSelectedColor:(UIColor*)color option:(FLSetColorOptions)option;
- (void)fl_setSelectedFontFamily:(FLFontFamily)fontFamily;

// 设置底部高度、内容高度
- (void)fl_setFooterHeight:(float)footerHeight;
- (void)fl_setContentHeight:(float)contentHeight;

// 设置对齐方式
- (void)fl_alignLeft ;  // 左对齐
- (void)fl_alignCenter; // 居中
- (void)fl_alignRight;  // 右对齐
- (void)fl_alignFull;   // 整行展示

// 设置字体
- (void)fl_setBold ;      // 粗体
- (void)fl_setItalic;     //斜体
- (void)fl_setSubscript ; // 下标
- (void)fl_setSuperscript; // 上标
- (void)fl_setUnderline ; // 下划线 ____
- (void)fl_setStrikethrough; // 删除线  ---
- (void)fl_setOrderedList;  // 使用编号排序  第二次调用即为取消
- (void)fl_setUnorderedList; // 不使用编号（点代替）排序 第二次调用即为取消
- (void)fl_setHR; // 添加分割线
- (void)fl_setIndent;  // 向右缩进  再次调用会再次缩进
- (void)fl_setOutdent; // 向左伸出

// 设置标签大小
- (void)fl_heading1;
- (void)fl_heading2;
- (void)fl_heading3;
- (void)fl_heading4;
- (void)fl_heading5;
- (void)fl_heading6;
- (void)fl_paragraph; // 使用p 标签

#pragma mark - focusText  //> 设置键盘焦点
// 获取焦点、退出焦点
- (void)fl_focusTextEditor;
- (void)fl_blurTextEditor;
@end
