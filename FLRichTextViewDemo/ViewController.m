//
//  ViewController.m
//  FLRichTextViewDemo
//
//  Created by Shangen Zhang on 2018/6/13.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "ViewController.h"
#import "FLRichTextViewController.h"
@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray * dataSource;
@end

@implementation ViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
                        @{
                            @"title" : @"Attribute editor",
                            @"class" : @"FLRichTextViewController",
                            },
                        @{
                            @"title" : @"Web view editor",
                            @"class" : @"FLWebTextViewController",
                            },
                        @{
                            @"title" : @"Line text",
                            @"class" : @"FLLineTextViewController",
                            },
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.title = @"Demo list";
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *classStr = self.dataSource[indexPath.row][@"class"];
    Class vcClass = NSClassFromString(classStr);
    UIViewController *vc = (UIViewController *)[[vcClass alloc] init];
    if ([vc isKindOfClass:UIViewController.class]) {
        vc.title = self.dataSource[indexPath.row][@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
