//
//  FLLineTextViewController.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/14.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "FLLineTextViewController.h"
#import "FLLineTextView.h"
#import "NSString+FLEditorHTML.h"
@interface FLLineTextViewController () <UITextViewDelegate>
/* <#des#> */
@property (nonatomic,weak) FLLineTextView * lineTextView;
@end

@implementation FLLineTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
   
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FLEditor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lineTextView.text = htmlString;
}


- (FLLineTextView *)lineTextView {
    if (!_lineTextView) {
        FLLineTextView *textView = [[FLLineTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width,self.view.bounds.size.height -64)];
        [self.view addSubview:textView];
        textView.delegate = self;
        _lineTextView = textView;
    }
    return _lineTextView;
}


@end
