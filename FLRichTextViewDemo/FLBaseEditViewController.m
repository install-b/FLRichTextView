//
//  FLBaseEditViewController.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/14.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLBaseEditViewController.h"
#import "FLPreViewController.h"

@interface FLBaseEditViewController ()

@end

@implementation FLBaseEditViewController
- (NSArray<NSDictionary<FLEditAccessoryItemKey,id> *> *)items {
    return @[
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLbold",
                 FLEditAccessoryItemSelectedImage  : @"",
                 FLEditAccessoryItemHighlightImage : @"tabbar_profile_highlighted",
                 FLEditAccessoryItemIdentfier      : @"BoldBtn",
                 },
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLh1",
                 FLEditAccessoryItemSelectedImage  : @"",
                 FLEditAccessoryItemHighlightImage : @"tabbar_message_center_highlighted",
                 FLEditAccessoryItemIdentfier      : @"HeadingBtn",
                 },
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLlink",
                 FLEditAccessoryItemSelectedImage  : @"FLlink",
                 FLEditAccessoryItemHighlightImage : @"FLlink",
                 FLEditAccessoryItemIdentfier      : @"FLlink",
                 },
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLimage",
                 FLEditAccessoryItemSelectedImage  : @"FLimage",
                 FLEditAccessoryItemHighlightImage : @"FLimage",
                 FLEditAccessoryItemIdentfier      : @"FLlink",
                 },
             ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewAttriubute:)];
}
- (void)previewAttriubute:(id)sender {
    FLPreViewController *preViewController = [[FLPreViewController alloc] init];
    [self.navigationController pushViewController:preViewController animated:YES];
    [preViewController loadHTLMString:[self attributedHTMLText]];
}
- (NSString  *)attributedHTMLText {
 return nil;
}
// 点击富文本编辑按钮
- (void)editAccessoryView:(FLRichEditAccessoryView *)accessoryView didClickItemBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:return [self setBoldWithButton:btn];
        case 1:return [self setHeadingWithButton:btn];
        case 2:return [self insertLinkWithButton:btn];
        case 3:return [self insertImageWithButton:btn];
        case 4:return [self revoke:btn];
        case 5:return [self goforward:btn];
        default:
            break;
    }
    
    
}
- (void)setBoldWithButton:(UIButton *)btn {
    
}
- (void)setHeadingWithButton:(UIButton *)btn {
    
}
- (void)insertLinkWithButton:(UIButton *)btn {
    
}
- (void)insertImageWithButton:(UIButton *)btn {
    
}
- (void)revoke:(UIButton *)btn {
    
}
- (void)goforward:(UIButton *)btn {
    
}
@end
