//
//  JSRequestTools.m
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import "JSRequestTools.h"
#import "JSLoadMoreHeader.h"

@implementation JSRequestTools

+ (RACSignal *)js_postURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypePOST URL:url para:para];
}

+ (RACSignal *)js_getURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypeGET URL:url para:para];
}

+ (RACSignal *)js_deleteURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypeDELETE URL:url para:para];
}

+ (RACSignal *)js_putURL:(NSString *)url para:(NSMutableDictionary *)para{
    
    return [self js_baseRequestWithType:RequestTypePUT URL:url para:para];
}

+ (RACSignal *)js_uploadURL:(NSString *)url para:(NSMutableDictionary *)para files:(NSMutableArray <JSFileConfig *>*)files{
    return [self js_baseRequestWithType:RequestTypePOSTUPLOAD URL:url para:para files:files];
}

+ (RACSignal *)js_baseRequestWithType:(RequestType)type URL:(NSString *)url para:(NSMutableDictionary *)para{
    return [self js_baseRequestWithType:type URL:url para:para files:nil];
}

+ (RACSignal *)js_baseRequestWithType:(RequestType)type URL:(NSString *)url para:(NSMutableDictionary *)para files:(NSMutableArray <JSFileConfig *>*)files{
    
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
            
        case RequestTypePUT:
        {
            [manage PUT:url
              parameters:para
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
            
        case RequestTypeDELETE:
        {
            [manage DELETE:url
              parameters:para
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
        case RequestTypePOSTUPLOAD:
        {
                [manage POST:url
                  parameters:para
   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
       for (JSFileConfig *file in files) {
           [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
       }
   }
                    progress:^(NSProgress * _Nonnull uploadProgress) {
                        [subject sendNext:uploadProgress];
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [subject sendCompleted];
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         [subject sendError:error];
                     }];
            
        }
            break;
            
    }
    return subject;
}

@end


/**
 *  用来封装上传参数
 */
@implementation JSFileConfig

+ (instancetype)fileConfigWithfileData:(NSData *)fileData
                                  name:(NSString *)name
                              fileName:(NSString *)fileName
                              mimeType:(NSString *)mimeType {
    
    return [[self alloc] initWithfileData:fileData
                                     name:name
                                 fileName:fileName
                                 mimeType:mimeType];
}

- (instancetype)initWithfileData:(NSData *)fileData
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        mimeType:(NSString *)mimeType {
    
    if (self = [super init]) {
        
        _fileData = fileData;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end
