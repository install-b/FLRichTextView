//
//  FLRichEditAccessoryView.h
//  RichTextEditDemo
//
//  Created by aron on 2017/7/21.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NSString * FLEditAccessoryItemKey;

#define FLEditAccessoryItemNoarmalImage     @"FLEditAccessoryItemNoarmalImage"
#define FLEditAccessoryItemHighlightImage   @"FLEditAccessoryItemHighlightImage"
#define FLEditAccessoryItemSelectedImage    @"FLEditAccessoryItemSelectedImage"
#define FLEditAccessoryItemIdentfier        @"FLEditAccessoryItemIdentfier"


@class FLRichEditAccessoryView;
@protocol FLRichEditAccessoryViewDelegate <NSObject>

// 点击富文本编辑按钮
- (void)editAccessoryView:(FLRichEditAccessoryView *)accessoryView didClickItemBtn:(UIButton *)btn;

@end



@interface FLRichEditAccessoryView : UIControl

@property (nonatomic, weak) id<FLRichEditAccessoryViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


- (instancetype)initWithDataSource:(NSArray <NSDictionary <FLEditAccessoryItemKey,id> *>*)dataSoruce;

- (void)updateSelected:(BOOL)selected withIdentifier:(NSString *)identifier;

@end
