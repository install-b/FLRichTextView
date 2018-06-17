//
//  FLPlaceHolderTextView.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/22.
//  Copyright © 2017年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLPlaceHolderTextView : UITextView
// 占位文字
@property (nonatomic, copy) NSString * placeHolder;

// 占位文字的颜色
@property UIColor * placeHolderColor;

// 最大的输入 默认值为1000
@property (nonatomic, assign) NSInteger maxInputs;


/**
 文本发生变化时候调用
    -- 子类监听到文本变化时候需要处理
 */
- (void)handleTextDidChange;

/**
 根据bounds返回占位文字位置
    -- 子类可以重写
 
 @param rect bounds
 @return 占位文字位置
 */
- (CGRect)rectForPlaceholderFormBounds:(CGRect)rect;
@end
