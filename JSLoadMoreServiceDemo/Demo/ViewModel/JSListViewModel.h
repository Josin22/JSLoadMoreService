//
//  JSListViewModel.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import <Foundation/Foundation.h>
#import "NSObject+LoadMoreService.h"

@interface JSListViewModel : NSObject

- (RACSignal *)siganlForJokeDataIsReload:(BOOL)isReload;

@end
