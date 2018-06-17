//
//  FLInsterLinkAlertViewController.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/21.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLInsterLinkAlertViewController.h"


@interface FLInsterLinkAlertViewController ()
@property (nonatomic,copy) FLLinkInsetBlock callBackAction;
@end

@implementation FLInsterLinkAlertViewController
+ (instancetype)LinkAlertWithAction:(FLLinkInsetBlock)action {
    FLInsterLinkAlertViewController *alert = [super alertControllerWithTitle:@"插入链接" message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.callBackAction = action;
   [alert setUps];
    return alert;
}


- (void)setUps {
    __weak typeof(self) weakSelf = self;
    [super addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [weakSelf setUpTextField:textField placeholder:@"在这输入链接"];
    }];
    
    [super addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [weakSelf setUpTextField:textField placeholder:@"在这输入文本"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [super addAction:cancelAction];
    
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.callBackAction) {
            
            NSString *url = self.textFields.firstObject.text;
            NSString *title  = self.textFields.lastObject.text;
            
            self.callBackAction(url, title);
        }
        
    }];
    [super addAction:comfirmAction];
}
- (void)setUpTextField:(UITextField *)textField placeholder:(NSString *)placeholder {
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    CGRect rect = textField.frame;
    rect.size.height = 44.0f;
    textField.frame = rect;
}


@end
