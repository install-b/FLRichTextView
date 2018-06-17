//
//  FLInsterLinkAlertViewController.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/21.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FLLinkInsetBlock)(NSString *URL,NSString *title);

@interface FLInsterLinkAlertViewController : UIAlertController

+ (instancetype)LinkAlertWithAction:(FLLinkInsetBlock)action;

@end
