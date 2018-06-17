//
//  FLEditorTableViewController.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/20.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLRichEditAccessoryView.h"


#define ToolBarHeight 40


@interface FLKeyBoardAccessoryViewController : UIViewController <FLRichEditAccessoryViewDelegate>

@property (nonatomic,strong) FLRichEditAccessoryView * toolbarHolder;

// 键盘高度发生变化
- (void)keyBoardHeightWillChange:(NSString *)notificationName
                        duration:(NSTimeInterval)duration
                animationOptions:(UIViewAnimationOptions)animationOptions
                  keyboardHeight:(CGFloat)keyboardHeight NS_REQUIRES_SUPER;

// 子类实现
- (NSArray<NSDictionary<FLEditAccessoryItemKey,id> *> *)items;

@end
