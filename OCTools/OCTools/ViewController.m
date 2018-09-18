//
//  ViewController.m
//  OCTools
//
//  Created by 张书孟 on 2018/5/17.
//  Copyright © 2018年 ZSM. All rights reserved.
//

#import "ViewController.h"
#import "LiveListModel.h"
#import <MJRefresh/MJRefresh.h>
#import "NetworkRequest.h"
#import "TestViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <LiveListModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self addTableView];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TestViewController *testVc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVc animated:YES];
}

- (void)loadData {
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSDictionary *dic = @{
                          @"requestCode":@"80003",
                          @"user_id":@"110430",
                          @"type":@"2",
                          @"limit":@"10",
                          @"page":page,
                          @"q_t":@"2",
                          };
    [NetWorkRequest requestLiveListWithParameters:dic responseCaches:^(LiveListModel *model) {
        if ([self.tableView.mj_header isRefreshing]) {
            if ([model success]) {
                self.dataSource = [model.responseResultList mutableCopy];
            }
        } else {
            if ([model success]) {
                [self.dataSource addObjectsFromArray:[model.responseResultList mutableCopy]];
            }
        }
        [self.tableView reloadData];
    } success:^(LiveListModel *model) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if ([model success]) {
            
            [self.dataSource addObjectsFromArray:[model.responseResultList mutableCopy]];
        } else {
            NSLog(@"%@", model.responseMessage);
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    LiveListModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"test -- %@",model.subject];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell -- %ld", (long)indexPath.row);
}

- (void)addTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page++;
            [weakSelf loadData];
        }];
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
