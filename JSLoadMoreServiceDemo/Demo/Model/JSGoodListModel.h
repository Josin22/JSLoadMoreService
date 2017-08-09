//
//  JSGoodListModel.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//  Github: https://github.com/Josin22/JSLoadMoreService

#import <Foundation/Foundation.h>

@interface JSGoodListModel : NSObject

@property (nonatomic, copy ) NSString *title;
@property (nonatomic, copy ) NSString *avatar_url;
@property (nonatomic, strong) NSNumber *price;

@end
