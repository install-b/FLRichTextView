//
//  FLEditorTableViewController.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/20.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLKeyBoardAccessoryViewController.h"

@interface FLKeyBoardAccessoryViewController ()

@end

@implementation FLKeyBoardAccessoryViewController
- (NSArray<NSDictionary<FLEditAccessoryItemKey,id> *> *)items {
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect toolBarDefualtFrame  = CGRectMake(0, self.view.frame.size.height - ToolBarHeight, self.view.frame.size.width, ToolBarHeight);
    self.toolbarHolder.frame = toolBarDefualtFrame;
}

#pragma mark - View Will Appear Section
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
 
    //Add observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - View Will Disappear Section
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
  
    //Remove observers for keyboard showing or hiding notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    [self keyBoardHeightWillChange:notification.name duration:duration animationOptions:animationOptions keyboardHeight:keyboardHeight];
}

- (void)keyBoardHeightWillChange:(NSString *)notificationName
                        duration:(NSTimeInterval)duration
                animationOptions:(UIViewAnimationOptions)animationOptions
                  keyboardHeight:(CGFloat)keyboardHeight {
    // Toolbar Sizes
    CGFloat sizeOfToolbar = self.toolbarHolder.frame.size.height;
    
    //const int extraHeight = 10;
    
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification]) {
        [self.view bringSubviewToFront:self.toolbarHolder];
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            // Toolbar
            CGRect frame = self.toolbarHolder.frame;
            frame.origin.y = self.view.frame.size.height - (keyboardHeight + sizeOfToolbar);
            self.toolbarHolder.frame = frame;
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            CGRect frame = self.toolbarHolder.frame;
            frame.origin.y = self.view.frame.size.height - sizeOfToolbar;
            //frame.origin.y = self.view.frame.size.height + keyboardHeight;
            self.toolbarHolder.frame = frame;
            
        } completion:nil];
    }
}

- (FLRichEditAccessoryView *)toolbarHolder {
    if (!_toolbarHolder) {
        _toolbarHolder = [[FLRichEditAccessoryView alloc] initWithDataSource:[self items]];
        _toolbarHolder.backgroundColor = [UIColor whiteColor];
        _toolbarHolder.delegate = self;
        [self.view addSubview:_toolbarHolder];
    }
    return _toolbarHolder;
}

#pragma mark - richEditAccessory view delegate
// 点击富文本编辑按钮
- (void)editAccessoryView:(FLRichEditAccessoryView *)accessoryView didClickItemBtn:(UIButton *)btn {
    // 子类实现
}
@end
