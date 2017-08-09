//
//  NSObject+LoadMoreService.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

static NSInteger const PerPageMaxCount = 20;

@interface NSObject (LoadMoreService)
/**
 *  每次请求追加的indexpaths
 */
@property (nonatomic, strong) NSMutableArray *appendingIndexpaths;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  原始请求数据
 */
@property (nonatomic, strong) id orginResponseObject;
/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  是否请求中
 */
@property (nonatomic, assign) BOOL isRequesting;
/**
 *  是否数据加载完
 */
@property (nonatomic, assign) BOOL isNoMoreData;

/**
 *  单一请求分页加载数据
 *
 *  @param baseURL               请求地址
 *  @param para                  请求参数
 *  @param keyOfArray            取数组的key(注:多层请用/分隔)
 *  @param classNameOfModelArray 序列化model的class_name
 *  @param isReload              (YES:刷新、NO:加载更多)
 *
 *  @return RACSingal
 */
- (RACSignal *)js_singalForSingleRequestWithURL:(NSString *)baseURL
                                           para:(NSMutableDictionary *)para
                                     keyOfArray:(NSString *)keyOfArray
                          classNameOfModelArray:(NSString *)classNameOfModelArray
                                       isReload:(BOOL)isReload;


@end
