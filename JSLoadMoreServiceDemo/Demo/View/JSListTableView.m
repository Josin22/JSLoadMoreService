//
//  JSListTableView.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "JSListTableView.h"
#import "NSObject+LoadMoreService.h"
#import "UITableView+Preload.h"
#import "JSLoadMoreHeader.h"
#import "JSGoodListModel.h"

@interface JSListTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JSListTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate   = self;
        self.rowHeight = 100;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.dataArray:%@",self.dataArray);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodListModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    /**
     *  根据当期index计算是否回调preloadblock
     */
    [self preloadDataWithCurrentIndex:indexPath.row];
}

@end
