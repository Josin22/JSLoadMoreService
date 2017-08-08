//
//  JSRequestTools.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGET = 0,
    RequestTypePOST
};
/**
 *  简单用RAC封装的请求下
 */
@interface JSRequestTools : NSObject

+ (RACSignal *)js_postURL:(NSString *)url para:(NSMutableDictionary *)para;

+ (RACSignal *)js_getURL:(NSString *)url para:(NSMutableDictionary *)para;


@end
