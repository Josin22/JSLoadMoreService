//
//  ViewController.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "ViewController.h"
#import "JSListTableView.h"
#import "JSLoadMoreHeader.h"
#import "JSListViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) JSListTableView *listTableView;

@property (nonatomic, strong) JSListViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"JSLoadMoreServiceDemo";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.viewModel = [JSListViewModel new];
    
    [self requestGoodListIsReload:YES];
}

- (void)requestGoodListIsReload:(BOOL)isReload{
    
    kWeakSelf(self)
    [[self.viewModel siganlForJokeDataIsReload:isReload] subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        kStrongSelf(self)
        self.listTableView.dataArray = self.viewModel.dataArray;
        [self.listTableView reloadData];
        [self.listTableView endReload];
    }];
}

- (JSListTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView = [[JSListTableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStyleGrouped];
        [self.view addSubview:_listTableView];
        
        kWeakSelf(self)
        /**
         *  刷新
         */
        [_listTableView headerReloadBlock:^{
            kStrongSelf(self)
            [self requestGoodListIsReload:YES];
        }];
        /**
         *  预加载
         */
        _listTableView.js_preloadBlock = ^{
            kStrongSelf(self)
            [self requestGoodListIsReload:NO];
        };
    }
    return _listTableView;
}

@end
