//
//  JSListViewModel.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "JSListViewModel.h"
#import "JSGoodListModel.h"
#import "JSLoadMoreHeader.h"

static NSString *const Test_Page_URL = @"http://www.51xiaoniu.cn/api/v1/products";

@implementation JSListViewModel

- (RACSignal *)siganlForJokeDataIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [[self js_singalForSingleRequestWithURL:Test_Page_URL
                                      para:nil
                                keyOfArray:@"pdlist"
                     classNameOfModelArray:@"JSGoodListModel"
                                  isReload:isReload] subscribeNext:^(id  _Nullable x) {
        /**
         *  x : 分类方法(js_singalForSingleRequestWithURL:...)里 sendNext 传过来的数组
         *  你可以对每次传过来的数组的元素"再加工",知道达到你的要求后 再 sendNext
         */
        //...
        [subject sendNext:x];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    } completed:^{
        /**
         *  走到这里为,每次分页请求所有逻辑处理完毕
         */
        [subject sendCompleted];
    }];
    
    return subject;
}

@end
