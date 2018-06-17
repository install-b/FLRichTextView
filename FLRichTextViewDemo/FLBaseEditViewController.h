//
//  FLBaseEditViewController.h
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/14.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLKeyBoardAccessoryViewController.h"

@interface FLBaseEditViewController : FLKeyBoardAccessoryViewController
- (void)setBoldWithButton:(UIButton *)btn;
- (void)setHeadingWithButton:(UIButton *)btn;
- (void)insertLinkWithButton:(UIButton *)btn;
- (void)insertImageWithButton:(UIButton *)btn;

- (NSString  *)attributedHTMLText;
@end
