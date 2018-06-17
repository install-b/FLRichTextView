//
//  UIFont+FLAttribute.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/14.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "UIFont+FLAttribute.h"
#import <objc/runtime.h>

@implementation UIFont (FLAttribute)
- (BOOL)fl_isBold {
  
    NSString *des = self.description;
    NSRange range = [des rangeOfString:@" font-weight: "];
    
    des = [des substringFromIndex:range.location + range.length];
    return [des hasPrefix:@"bold"];
}
@end
