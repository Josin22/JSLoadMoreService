//
//  UITableView+Prereload.h
//  JSLoadMoreServiceDemo
//
//  Created by 乔同新 on 2017/8/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;

static NSInteger const PreloadMinCount = 10;

typedef void(^PreloadBlock)(void);

typedef void(^ReloadBlock)(void);

@interface UITableView (Prereload)

@property (nonatomic, copy  ) PreloadBlock js_preloadBlock;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)preloadDataWithCurrentIndex:(NSInteger)currentIndex;

- (void)headerReloadBlock:(ReloadBlock)js_reloadBlock;

- (void)endReload;

@end
