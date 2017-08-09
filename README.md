# JSLoadMoreServiceDemo
[![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-red.svg)](https://github.com/josin22/JSLoadMoreService)
[![CocoaPods Compatible](https://img.shields.io/badge/build-passing-green.svg)](https://github.com/josin22/JSLoadMoreService)

让预加载,成为你分页的好朋友
# 安装
支持pod 安装

	pod 'JSLoadMoreService', '~> 1.1.0'
  
# 使用
优雅的建一个viewmodel类,
然后下面就是怎样调用分类的方法:
```- (RACSignal *)siganlForJokeDataIsReload:(BOOL)isReload{
    
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
```
在你的cellForRowAtIndexPath:代理里选择调用回调
```**
    *  根据当期index计算是否回调preloadblock
    */
    [self preloadDataWithCurrentIndex:indexPath.row];
    ```

优雅的配置tableview的上拉刷新和预加载

```- (JSListTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView = [[JSListTableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStyleGrouped];
        [self.view addSubview:_listTableView];
        
        kWeakSelf(self)
        /**
         *  刷新
         */
        [_listTableView headerReloadBlock:^{
            kStrongSelf(self)
            [self requestGoodListIsReload:YES];
        }];
        /**
         *  预加载
         */
        _listTableView.js_preloadBlock = ^{
            kStrongSelf(self)
            [self requestGoodListIsReload:NO];
        };
    }
    return _listTableView;
}
```

详细的实现步骤请访问[我的博客](http://qiaotongxin.cc/2017/08/06/20170807/)

如果用起来能让你愉悦,别忘记给个star,👍一下~
