//
//  FLPlaceHolderTextView.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/22.
//  Copyright © 2017年 Flame. All rights reserved.
//

#import "FLPlaceHolderTextView.h"

@interface FLPlaceHolderTextView ()
/* 占位文字 */
@property (nonatomic,weak) UILabel * placeHolderLabel;

@end

@implementation FLPlaceHolderTextView
#pragma mark - init set up
- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_defaultConfig];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_defaultConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self p_defaultConfig];
    }
    return self;
}

- (void)p_defaultConfig {
    _maxInputs = 1000;

    // 设置内容默认的内边距
    self.textContainerInset = UIEdgeInsetsMake(9, 7, 0, 7);
}
- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        UILabel* placeHolderLabel = [UILabel new];
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        placeHolderLabel.font = self.font;
        placeHolderLabel.text = @"";
        [self addSubview:placeHolderLabel];
        _placeHolderLabel = placeHolderLabel;
    }
    return _placeHolderLabel;
}

#pragma mark - ......::::::: override :::::::......
- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_updatePlaceholderFrame];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self p_updatePlaceholderFrame];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeHolderLabel.font = font;
    [self p_updatePlaceholderFrame];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self p_updatePlaceholderFrame];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    // 处理文字
    [self p_handlePlaceholder];
}
#pragma mark - ......::::::: private :::::::......
- (void)p_updatePlaceholderFrame {
    
    _placeHolderLabel.font = self.font;
    
    _placeHolderLabel.frame = [self rectForPlaceholderFormBounds:self.bounds];
}

- (void)p_handlePlaceholder {
    if (self.text != nil && self.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    } else {
        _placeHolderLabel.hidden = NO;
    }
}

#pragma mark - ......::::::: public :::::::......

- (void)handleTextDidChange {
    
    [self p_handlePlaceholder];
    
    // 字数限制
    NSString *toBeString = self.text;

    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxInputs) {
                self.text = [toBeString substringToIndex:_maxInputs];
            }
        } else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制 pandahomeapi.ifjing.com
        }
    } else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _maxInputs) {
            self.text = [toBeString substringToIndex:_maxInputs];
        }
    }
}

- (CGRect)rectForPlaceholderFormBounds:(CGRect)rect {
    UIEdgeInsets insets = self.textContainerInset;
    
    CGFloat exHeight = 2.0f;
    CGFloat leftOffset =  5;
    
    return  CGRectMake(rect.origin.x + insets.left + leftOffset,
                       rect.origin.y + insets.top - exHeight * 0.5,
                       rect.size.width - insets.left - insets.right - leftOffset,
                       self.font.lineHeight + exHeight);
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.placeHolderLabel.text = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    self.placeHolderLabel.textColor = placeHolderColor;
}

- (UIColor *)placeHolderColor {
    return _placeHolderLabel.textColor;
}
@end
