//
//  FLStatusTextViewController.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/21.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLRichTextViewController.h"
#import "FLPreViewController.h"
#import "FLInsterLinkAlertViewController.h"

#import "FLRichTextEditView.h"
#import "UIFont+FLAttribute.h"

#import "NSAttributedString+html.h"

@interface FLRichTextViewController () <FLRichTextEditViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) FLRichTextEditView * statusTextView;
@end

@implementation FLRichTextViewController
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
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLlink",
                 FLEditAccessoryItemSelectedImage  : @"FLlink",
                 FLEditAccessoryItemHighlightImage : @"FLlink",
                 FLEditAccessoryItemIdentfier      : @"revoke",
                 },
             @{
                 FLEditAccessoryItemNoarmalImage   : @"FLimage",
                 FLEditAccessoryItemSelectedImage  : @"FLimage",
                 FLEditAccessoryItemHighlightImage : @"FLimage",
                 FLEditAccessoryItemIdentfier      : @"goforward",
                 },
             ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.statusTextView becomeFirstResponder];


}

- (NSString *)attributedHTMLText {
    return [self.statusTextView.attributedText toHtmlString];
}

// 点击富文本编辑按钮
- (void)setBoldWithButton:(UIButton *)btn {
    [self.statusTextView setCurrentBold:btn.selected];
}
- (void)setHeadingWithButton:(UIButton *)btn {
    //[self.statusTextView setHeading];
    [self.statusTextView setHeading:btn.selected];
}
- (void)insertLinkWithButton:(UIButton *)btn {
    [self.statusTextView prepareForInsertAttachmentString];
    FLInsterLinkAlertViewController *linkerVc = [FLInsterLinkAlertViewController LinkAlertWithAction:^(NSString *URL, NSString *title) {
        NSURL *url = [NSURL URLWithString:URL];
        if (url) {
            [self.statusTextView insertLink:url withAlt:title];
        }
        
    }];
    
    [self presentViewController:linkerVc animated:YES completion:nil];
}
- (void)insertImageWithButton:(UIButton *)btn {
    [self.statusTextView prepareForInsertAttachmentString];
    UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
    pickVc.delegate = self;
    [self presentViewController:pickVc animated:YES completion:nil];
}

- (void)revoke:(UIButton *)btn {
    [self.statusTextView revoke];
}
- (void)goforward:(UIButton *)btn {
    [self.statusTextView goForward];
}
#pragma mark - FLStatusEditAssetsPickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.statusTextView becomeFirstResponder];
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self.statusTextView insertImage:image withURL:nil];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.statusTextView becomeFirstResponder];
    }];
}

#pragma mark - FLRichTextEditViewDelegate
- (void)richTextEditView:(FLRichTextEditView *)richTextEditView attributeDidChanged:(NSDictionary<NSAttributedStringKey,id> *)attribute {
    // 解析attribute
    UIFont *font = attribute[NSFontAttributeName];
    // 更新输入框的放大按钮状态
    [self.toolbarHolder updateSelected:(font.pointSize >= 20) withIdentifier:@"HeadingBtn"];
    // 更新输入框的加粗
    [self.toolbarHolder updateSelected:font.fl_isBold withIdentifier:@"BoldBtn"];
    
}

- (void)keyBoardHeightWillChange:(NSString *)notificationName duration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)animationOptions keyboardHeight:(CGFloat)keyboardHeight {
    [super keyBoardHeightWillChange:notificationName duration:duration animationOptions:animationOptions keyboardHeight:keyboardHeight];
    CGRect frame = _statusTextView.frame;
    frame.size.height = self.view.bounds.size.height - 64 - ToolBarHeight;
    
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification]) {
        frame.size.height -= keyboardHeight;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self->_statusTextView.frame = frame;
    }];
}
#pragma mark - lazy load
- (FLRichTextEditView *)statusTextView {
    if (_statusTextView == nil) {

        CGRect textFrame = CGRectMake(0, 64, self.view.bounds.size.width,self.view.bounds.size.height - 64 - ToolBarHeight);
        FLRichTextEditView *textView = [[FLRichTextEditView alloc] initWithFrame:textFrame];
        textView.placeHolder = @"这里是占位文字。。。。";
        textView.fl_delegate = self;
        [self.view addSubview:textView];
        
        _statusTextView = textView;
    }
    return _statusTextView;
}
@end
