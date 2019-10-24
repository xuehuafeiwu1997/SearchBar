//
//  ViewController.m
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "SearchViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *btnSearch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.btnSearch];
    
    //添加到视图上面之后才可以使用Masonry
    [self.btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@40);
        make.width.equalTo(@66);
    }];
    
}

#pragma mark - 懒加载搜索按钮
- (UIButton *)btnSearch {
    
    if (_btnSearch == nil) {
        _btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnSearch setTitle:@"Search" forState:UIControlStateNormal];
        _btnSearch.backgroundColor = [UIColor redColor];
        _btnSearch.frame = CGRectZero;
        [_btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}

//点击搜索按钮的事件处理
- (void)btnSearchClick {
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

@end
