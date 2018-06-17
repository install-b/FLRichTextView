//
//  FLRichEditAccessoryView.m
//  RichTextEditDemo
//
//  Created by aron on 2017/7/21.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "FLRichEditAccessoryView.h"

#define LeftSpace 25
#define MaxMargin 35
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface _FLAccessoryItemBtn : UIButton
/* 唯一表示 */
@property (nonatomic,copy) NSString *identifier;
@end
@implementation _FLAccessoryItemBtn
@end

@interface FLRichEditAccessoryView ()
@property (nonatomic,strong) NSArray <_FLAccessoryItemBtn *> * itemBtns;
@end


@implementation FLRichEditAccessoryView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 绘制顶部分割线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0.5f)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0.5f)];
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(rect) - 0.5f)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - 0.5f)];
    path.lineWidth = 1.f;
    [[UIColor colorWithWhite:0.9 alpha:1.f] setStroke];
    [path stroke];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局
    int count = (int)self.itemBtns.count;
    CGFloat btnW = self.itemBtns.firstObject.bounds.size.width;
    CGFloat screenWidth = ScreenWidth;
    CGFloat autoMargin =  (screenWidth - 2 * LeftSpace - count * btnW ) / (count - 1);
    
    CGFloat margin = ((autoMargin > MaxMargin) ? MaxMargin : autoMargin) + btnW;
    
    CGFloat xOffset = LeftSpace + btnW * 0.5;
    CGFloat y = self.bounds.size.height * 0.5;
    
    [self.itemBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger btnIndex, BOOL * _Nonnull stop) {
        obj.center = CGPointMake(xOffset + btnIndex * margin, y);
    }];
    
}


- (instancetype)initWithDataSource:(NSArray<NSDictionary<FLEditAccessoryItemKey,id> *> *)dataSoruce {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUIWithDataSource:dataSoruce];
    }
    return self;
}

- (void)setupUIWithDataSource:(NSArray<NSDictionary<FLEditAccessoryItemKey,id> *> *)dataSoruce {

    NSMutableArray <UIButton *>* btnS = [NSMutableArray array];
    
    [dataSoruce enumerateObjectsUsingBlock:^(NSDictionary<FLEditAccessoryItemKey,id> * _Nonnull item, NSUInteger tagIndex, BOOL * _Nonnull stop) {
        _FLAccessoryItemBtn *btn = [[_FLAccessoryItemBtn alloc] init];
        [btn setImage:[UIImage imageNamed:item[FLEditAccessoryItemNoarmalImage]] forState:UIControlStateNormal];
        
        UIImage *highligntImage = [UIImage imageNamed:item[FLEditAccessoryItemHighlightImage]];
        if (highligntImage) {
            [btn setImage:highligntImage forState:UIControlStateHighlighted];
        }
        UIImage *selectedImage = [UIImage imageNamed:item[FLEditAccessoryItemSelectedImage]];
        if (selectedImage) {
            [btn setImage:selectedImage forState:UIControlStateSelected];
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_blue"] forState:UIControlStateSelected];
        
        btn.identifier = item[FLEditAccessoryItemIdentfier];
        // 设置索引
        btn.tag = tagIndex;
        
        
        [btn addTarget:self action:@selector(editAccessoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn sizeToFit];
        
        [btnS addObject:btn];
        [self addSubview:btn];
    }];
    
    //
    self.itemBtns = [NSArray arrayWithArray:btnS];
}

- (void)updateSelected:(BOOL)selected withIdentifier:(NSString *)identifier {
    if (identifier.length < 1 ) {
        return;
    }
    
    [self.itemBtns enumerateObjectsUsingBlock:^(_FLAccessoryItemBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            obj.selected = selected;
            *stop = YES;
        }
    }];
}
#pragma mark - 点击事件
- (void)editAccessoryBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(editAccessoryView:didClickItemBtn:)]) {
        [self.delegate editAccessoryView:self didClickItemBtn:sender];
    }
}
@end
