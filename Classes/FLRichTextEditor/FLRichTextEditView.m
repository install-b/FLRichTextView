//
//  FLRichTextEditView.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/22.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLRichTextEditView.h"
#import <CoreText/CoreText.h>

@interface FLRichTextEditView ()

@property (nonatomic,assign) CGFloat curFontSize;
@property (nonatomic,strong) UIFont *curFont;
/* 记录最后一次的文本 */
@property (nonatomic,strong) NSAttributedString * lastAttributedSting;
/* 记录需要修改富文本属性的位置 length = 1的时候表示需要修改 length = 0表示按照默认的方式  */
@property (nonatomic,assign) NSRange  resetRange;

/* 插入附件文本的位置 */
@property (nonatomic,assign) NSRange insertAttachmentRange;

// 撤销记录
@property (nonatomic,strong) NSMutableArray <NSAttributedString *>*reAttrStrs;
// 前进记录
@property (nonatomic,strong) NSMutableArray <NSAttributedString *>*goAttrStrs;

@end

@implementation FLRichTextEditView
#pragma mark - init setups
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __setUps];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self __setUps];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self __setUps];
}

- (void)__setUps {
    super.delegate = self;
    super.font = [UIFont systemFontOfSize:15];
//    if (self.text.length == 0) {
//
//        //[self.textStorage addAttributes:[self p_attributes] range:NSMakeRange(0, 0)];
//    }
    _resetRange = NSMakeRange(self.attributedText.length, 1);
    _curFontSize = 15;
}

#pragma mark - setter attribute
- (void)setHeading:(BOOL)isheading {
    _curFontSize = isheading ? 20 : 15;
    [self p_resetFont];
}

- (void)setHeading {
    NSRange range =  self.selectedRange;
    
    if (range.length == 0) {
        NSRange rangeFirst = [self.text rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0, range.location)];
        NSRange rangEnd = [self.text rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location, self.text.length - range.location)];
        
        NSInteger start = rangeFirst.location;
        if (start == NSIntegerMax) {
            start = 0;
        }else {
            start +=1;
        }
        NSInteger length = 0;
        if (rangEnd.location == NSIntegerMax) {
            length = self.text.length - start;
        }else {
            length = rangEnd.location - start;
        }

        if (length <= 0) {
            return;
        }
        range = NSMakeRange(start, length);
    }
   

    NSAttributedString *attrStr = [self.textStorage attributedSubstringFromRange:range];
    UIFont *font = [attrStr attribute:NSFontAttributeName atIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, attrStr.length)];
    //
    if (font.pointSize >= 20) {
        [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
        [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    }else {
        [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:range];
        [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:range];
    }
    
    
}

- (void)setCurrentBold:(BOOL)currentBold {
    if (_currentBold == currentBold) {
        return;
    }
    _currentBold = currentBold;
    [self p_resetFont];
}
#pragma mark - add attachment
- (void)prepareForInsertAttachmentString {
    _insertAttachmentRange = self.selectedRange;
}

// 添加链接
- (void)insertLink:(NSURL *)URL withAlt:(NSString *)alt {
     // 1. 创建图片附件
    NSString *linkStr = alt.length ? alt : URL.absoluteString;
    NSMutableDictionary *dictM = [self p_attributes].mutableCopy;
    [dictM setObject:URL forKey:NSLinkAttributeName];
    NSAttributedString *linkAttributeStr = [[NSAttributedString alloc] initWithString:linkStr attributes:dictM];

    
    // 2. 插入图片附件
    NSMutableAttributedString *orinArrtStrM = [self.attributedText mutableCopy];// 深度拷贝原文本
    [orinArrtStrM insertAttributedString:linkAttributeStr atIndex:_insertAttachmentRange.location];// 插入图片附件
    self.attributedText = orinArrtStrM; // 替换原文本
    
    
    [super handleTextDidChange];
    
    NSRange currentSelectRange =  NSMakeRange(_insertAttachmentRange.location + linkAttributeStr.length, 0);// 重置焦点
    self.lastAttributedSting = orinArrtStrM;
    self.selectedRange = currentSelectRange;
    
    currentSelectRange.length += 1; // 下次输入的文本需要重置属性
    _resetRange = currentSelectRange;
   
}

- (void)insertImage:(UIImage *)img withURL:(NSURL *)URL {
    // 1. 创建图片附件
    NSTextAttachment* imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = img;
    CGSize imageSize = [self p_getImageSizeWithImage:img];
    imageAttachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    NSAttributedString* imageAttrStr = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    
    // 2. 插入图片附件
    NSMutableAttributedString *orinArrtStrM = [self.attributedText mutableCopy];// 深度拷贝原文本
    [orinArrtStrM insertAttributedString:imageAttrStr atIndex:_insertAttachmentRange.location];// 插入图片附件
    self.attributedText = orinArrtStrM; // 替换原文本
    
    // 3. 重置属性
    [super handleTextDidChange];
    self.lastAttributedSting = orinArrtStrM;
    
    NSRange currentSelectRange =  NSMakeRange(_insertAttachmentRange.location + imageAttrStr.length, 0);// 重置焦点
    self.selectedRange = currentSelectRange;
    
    
    
    currentSelectRange.length += 1; // 下次输入的文本需要重置属性
    _resetRange = currentSelectRange;
}
// 后退,撤销
- (void)revoke {
    
}
// 是否可以撤销
- (BOOL)canRevoke {
    
    return NO;
}
// 前进，取消撤销
- (void)goForward {
    
}
// 是否可以取消撤销
- (BOOL)canForward {
    
    return NO;
}
#pragma mark - private method
- (void)p_resetFont {
    if (self.isCurrentBold) {
        _curFont = [UIFont boldSystemFontOfSize:_curFontSize];
    }else{
        _curFont = [UIFont systemFontOfSize:_curFontSize];
    }
    if (self.selectedRange.length != 0) {
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:[self.attributedText attributedSubstringFromRange:self.selectedRange].string attributes:[self p_attributes]];
        NSMutableAttributedString *attMu = self.attributedText.mutableCopy;
        [attMu replaceCharactersInRange:self.selectedRange withAttributedString:att];
        self.attributedText = attMu;
    }
    else {
        _resetRange = self.selectedRange;
        _resetRange.length = 1;
    }
}

- (NSMutableDictionary *)p_attributes{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)_curFont.fontName, _curFontSize, NULL);
    dic[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    paragraphStyle.paragraphSpacing = 14;
    dic[NSParagraphStyleAttributeName] = paragraphStyle;

    
    return dic;
}

- (CGSize)p_getImageSizeWithImage:(UIImage *)image {
    CGFloat width  = self.frame.size.width - 28;
    CGFloat height = (width / image.size.width) * image.size.height;
    return CGSizeMake(width, height);
}
@end


// 实现自己的代理处理一些逻辑 同时将代理回调给自己的 fl_delegate
@implementation FLRichTextEditView (TextViewDelegate)
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.fl_delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.fl_delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.fl_delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.fl_delegate textViewShouldEndEditing:textView];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.fl_delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        return [self.fl_delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.fl_delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        return [self.fl_delegate textViewDidEndEditing:textView];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [super handleTextDidChange];
    if ([self.fl_delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.fl_delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    // 设置text
    [super handleTextDidChange];
    
    UITextRange *textRange = self.markedTextRange;
    UITextPosition *position = [self positionFromPosition:textRange.start offset:0];
   
    if (!position && _resetRange.length) {
        
        NSMutableAttributedString *muAttributedStr = textView.attributedText.mutableCopy;
        NSInteger lastStart = self.lastAttributedSting.length;
        
        if (lastStart < muAttributedStr.length) {
            NSInteger curLoc = self.selectedRange.location;
            NSAttributedString *tempText = [muAttributedStr attributedSubstringFromRange:NSMakeRange(lastStart, muAttributedStr.length - lastStart)];
            
            NSString *tempStr = tempText.string;
        
            NSAttributedString *newAttributedStr = [[NSAttributedString alloc] initWithString:tempStr attributes:[self p_attributes]];
            [muAttributedStr replaceCharactersInRange:NSMakeRange(curLoc - newAttributedStr.length, newAttributedStr.length) withAttributedString:newAttributedStr];
            self.attributedText = muAttributedStr.copy;
            self.selectedRange = NSMakeRange(curLoc, 0);
            
            if (_resetRange.length) {
                if ([tempStr isEqualToString:@"\n"] || [tempStr isEqualToString:@"\t"]) {
                    _resetRange.location+=1;
                }else {
                    //_resetRange = NSMakeRange(0, 0);
                }
            }
            
            
        }
    }
    
    if (!textRange) {
         self.lastAttributedSting = textView.attributedText.copy;
    }
    
    if ([self.fl_delegate respondsToSelector:@selector(textViewDidChange:)]) {
        return [self.fl_delegate textViewDidChange:textView];
    }
}


- (void)textViewDidChangeSelection:(UITextView *)textView {

    // 切换光标 （文本没有发生变化） 或者删除文本
    if ((self.lastAttributedSting.length >= textView.attributedText.length) &&
        (textView.attributedText.length != 0)) {

        // 清除要修改文字属性的位置
        _resetRange = NSMakeRange(0, 0);
        
        // 获取当前的前一个文字的富文本信息
        NSRange selectedRange = textView.selectedRange;
        if (selectedRange.location > 0) {
            selectedRange.location -= 1;
        }
        selectedRange.length = 1;
        id attr = [textView.attributedText attributesAtIndex:selectedRange.location effectiveRange:&selectedRange];
        // 通知代理
        if ([self.fl_delegate respondsToSelector:@selector(richTextEditView:attributeDidChanged:)]) {
            [self.fl_delegate richTextEditView:self attributeDidChanged:attr];
        }
    }
    
    // textView delegate 转发
    if ([self.fl_delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        return [self.fl_delegate textViewDidChangeSelection:textView];
    }
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    if ([self.fl_delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.fl_delegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    if ([self.fl_delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
       return [self.fl_delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.fl_delegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.fl_delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.fl_delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.fl_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.fl_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.fl_delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.fl_delegate scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.fl_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([self.fl_delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
       return [self.fl_delegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.fl_delegate scrollViewWillBeginZooming:scrollView withView:view ];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.fl_delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.fl_delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.fl_delegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
    if ([self.fl_delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        [self.fl_delegate scrollViewDidChangeAdjustedContentInset:scrollView];
    }
}
@end
