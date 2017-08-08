//
//  JSRequestTools.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "JSRequestTools.h"
#import "JSLoadMoreHeader.h"

@implementation JSRequestTools

+ (RACSignal *)js_postURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypePOST URL:url para:para];
}

+ (RACSignal *)js_getURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypeGET URL:url para:para];
}

+ (RACSignal *)js_baseRequestWithType:(RequestType)type URL:(NSString *)url para:(NSMutableDictionary *)para{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer.timeoutInterval = 30.f;
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manage.responseSerializer = response;
    switch (type) {
        case RequestTypeGET:
        {
            [manage GET:url
             parameters:para
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [subject sendNext:responseObject];
                    [subject sendCompleted];
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [subject sendError:error];
                }];
            
        }
            break;
        case RequestTypePOST:
        {
            [manage POST:url
              parameters:para
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                     //                     NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                     [subject sendNext:responseObject];
                     [subject sendCompleted];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                     [subject sendError:error];
                 }];
            
        }
            break;
    }
    return subject;
}

@end
