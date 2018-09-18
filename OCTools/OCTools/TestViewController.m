//
//  TestViewController.m
//  OCTools
//
//  Created by 张书孟 on 2018/6/4.
//  Copyright © 2018年 ZSM. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addMainScrollView];
    [self addSubViews];
}

- (void)addSubViews {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    headerView.backgroundColor = [UIColor redColor];
//    [self.mainScrollView addSubview:headerView];
    

}

- (void)addMainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height + 200);
        _mainScrollView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_mainScrollView];
    }
}

@end
