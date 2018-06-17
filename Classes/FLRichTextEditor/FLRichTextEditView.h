//
//  FLRichTextEditView.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/22.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLPlaceHolderTextView.h"

@class FLRichTextEditView;
@protocol FLRichTextEditViewDelegate <NSObject,UITextViewDelegate>
/**
 富文本环境发生变化
    -- 代理可以在这里更新键盘的工具栏的按钮状态比如加粗还是常规状态

 @param richTextEditView 富文本编辑器
 @param attribute 当前光标所处环境的attribute
 */
- (void)richTextEditView:(FLRichTextEditView *)richTextEditView attributeDidChanged:(NSDictionary<NSAttributedStringKey, id> *)attribute;
@end



@interface FLRichTextEditView : FLPlaceHolderTextView

// 'delegate' is unavailable using 'fl_delegate' instead
- (void)setDelegate:(id<UITextViewDelegate>)delegate NS_UNAVAILABLE;
@property (nonatomic,weak) id <FLRichTextEditViewDelegate> fl_delegate;

// 设置加粗
@property (nonatomic,assign,getter=isCurrentBold) BOOL currentBold;

// 设置字体放大
- (void)setHeading:(BOOL)isheading;

- (void)setHeading;
/**
 准备插入附件文本 （如图片、链接）调用一下该方法
    -- 插入图片或者链接可能导致 txetview 失去焦点，下次再获取焦点时候回到文本最后面，导致新插入的图片或链接都会跑到最后。
       调用该方法让textview记录当前光标位置，让新插入的图片或者链接向该位置插入
 */
- (void)prepareForInsertAttachmentString;


/**
 插入一个链接

 @param URL URL地址
 @param alt 展示的文本
 */
- (void)insertLink:(NSURL *)URL withAlt:(NSString *)alt;


/**
 插入一张图片

 @param image 要插入图片
 @param URL 图片地址
 */
- (void)insertImage:(UIImage *)image withURL:(NSURL *)URL;

@end



// 子类实现需调用父类方法 NS_REQUIRES_SUPER
@interface FLRichTextEditView (TextViewDelegate) <UITextViewDelegate>
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView NS_REQUIRES_SUPER;
- (BOOL)textViewShouldEndEditing:(UITextView *)textView NS_REQUIRES_SUPER;
- (void)textViewDidBeginEditing:(UITextView *)textView NS_REQUIRES_SUPER;
- (void)textViewDidEndEditing:(UITextView *)textView NS_REQUIRES_SUPER;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_REQUIRES_SUPER;
- (void)textViewDidChange:(UITextView *)textView NS_REQUIRES_SUPER;
- (void)textViewDidChangeSelection:(UITextView *)textView NS_REQUIRES_SUPER;
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) NS_REQUIRES_SUPER;
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) NS_REQUIRES_SUPER;

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2) NS_REQUIRES_SUPER;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) NS_REQUIRES_SUPER;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate NS_REQUIRES_SUPER;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2) NS_REQUIRES_SUPER;
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale NS_REQUIRES_SUPER;
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) NS_REQUIRES_SUPER;
@end
