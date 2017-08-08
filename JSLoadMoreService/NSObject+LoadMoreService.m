//
//  NSObject+LoadMoreService.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+LoadMoreService.h"
#import "JSLoadMoreHeader.h"

static char const *key_isNoMoreData = "key_isNoMoreData";

static char const *key_isRequesting = "key_isRequesting";

static char const *key_currentPage = "key_currentPage";

static char const *key_dataArray = "key_dataArray";

static char const *key_appendingIndexpaths = "key_appendingIndexpaths";

static char const *key_orginResponseObject = "key_orginResponseObject";

@implementation NSObject (LoadMoreService)

#pragma mark - associated

- (BOOL)isNoMoreData{
    return [objc_getAssociatedObject(self, &key_isNoMoreData) boolValue];
}

- (void)setIsNoMoreData:(BOOL)isNoMoreData{
    objc_setAssociatedObject(self, &key_isNoMoreData, @(isNoMoreData), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isRequesting{
    return [objc_getAssociatedObject(self, &key_isRequesting) boolValue];
}

- (void)setIsRequesting:(BOOL)isRequesting{
    objc_setAssociatedObject(self, &key_isRequesting, @(isRequesting), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentPage{
    return [objc_getAssociatedObject(self, &key_currentPage) integerValue];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    objc_setAssociatedObject(self, &key_currentPage, @(currentPage), OBJC_ASSOCIATION_ASSIGN);
}

- (NSMutableArray *)dataArray{
    return objc_getAssociatedObject(self, &key_dataArray);
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    objc_setAssociatedObject(self, &key_dataArray, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)appendingIndexpaths{
    return objc_getAssociatedObject(self, &key_appendingIndexpaths);
}

- (void)setAppendingIndexpaths:(NSMutableArray *)appendingIndexpaths{
    objc_setAssociatedObject(self, &key_appendingIndexpaths, appendingIndexpaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)orginResponseObject{
    return objc_getAssociatedObject(self, &key_orginResponseObject);
}

- (void)setOrginResponseObject:(id)orginResponseObject{
    objc_setAssociatedObject(self, &key_orginResponseObject, orginResponseObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - method

- (RACSignal *)js_singalForSingleRequestWithURL:(NSString *)baseURL
                                           para:(NSMutableDictionary *)para
                                     keyOfArray:(NSString *)keyOfArray
                          classNameOfModelArray:(NSString *)classNameOfModelArray
                                       isReload:(BOOL)isReload{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self js_baseSingleRequestWithURL:baseURL
                                 para:para
                             isReload:isReload] subscribeNext:^(id  _Nullable x) {
        
        NSAssert(classNameOfModelArray, @"请建个对应的model,为了能创建数组模型!");
        
        self.orginResponseObject = x;
        
        if (!self.dataArray) {
            self.dataArray = @[].mutableCopy;
        }
        
        if (isReload) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *separateKeyArray = [keyOfArray componentsSeparatedByString:@"/"];
        for (NSString *sepret_key in separateKeyArray) {
            x = x[sepret_key];
        }
        
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(classNameOfModelArray) json:x];
        NSInteger from_index = self.dataArray.count;
        NSInteger data_count = dataArray.count;
        self.appendingIndexpaths = [self getAppendingIndexpathsFromIndex:from_index
                                                          appendingCount:data_count
                                                               inSection:0
                                                                isForRow:YES];
        [subject sendNext:dataArray];
        
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.dataArray addObjectsFromArray:dataArray];
        }
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)js_baseSingleRequestWithURL:(NSString *)baseURL
                               para:(NSMutableDictionary *)para
                           isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    if (![self isSatisfyLoadMoreRequest]&&!isReload) {
        return subject;
    }
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    if (isReload) {
        self.currentPage = 0;
#warning 此处可以添加统一的HUD
        //...
    }
    self.currentPage++;
#warning 分页的key按需修改
    para[@"page"] = @(self.currentPage);
    para[@"per_page"] = @(PerPageMaxCount);
    
    self.isRequesting = YES;
    
    [[JSRequestTools js_getURL:baseURL para:para] subscribeNext:^(id  _Nullable x) {
        self.isRequesting = NO;
        if (isReload) {
#warning 消失HUD
            //...
        }
        [subject sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        self.isRequesting = NO;
        if (self.currentPage>0) {
            self.currentPage--;
        }
        [subject sendError:error];
    }];
    
    return subject;
}

- (BOOL)isSatisfyLoadMoreRequest{
    return (!self.isNoMoreData&&!self.isRequesting);
}

- (NSMutableArray *)getAppendingIndexpathsFromIndex:(NSInteger)from_index
                                     appendingCount:(NSInteger)appendingCount
                                          inSection:(NSInteger)inSection
                                           isForRow:(BOOL)isForRow{
    NSMutableArray *indexps = [NSMutableArray array];
    for (NSInteger i = 0; i < appendingCount; i++) {
        if (isForRow) {
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:from_index+i inSection:inSection];
            [indexps addObject:indexp];
        } else {
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:0 inSection:from_index+i];
            [indexps addObject:indexp];
        }
    }
    return indexps;
}

@end
