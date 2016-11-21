//
//  URLHTTP.m
//  TableViewNew
//
//  Created by HZW on 15/11/1.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "URLHTTP.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#define WMAIN   [[UIScreen mainScreen] bounds].size.width
#define HMAIN   [[UIScreen mainScreen] bounds].size.height

static NSString *tableCellId = @"cellId";

@interface URLHTTP ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    UITextField *_nameText;
    UITextField *_pwdText;
    AFHTTPRequestOperationManager *_manager;
    UITableView *_tbView;
}
@property (nonatomic, assign) BOOL isLoading;/**< 刷新 */
@property (nonatomic, assign) BOOL isUpLoad;/**< 加载更多 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableData *dataSource;



@end


@implementation URLHTTP

- (NSMutableData *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableData data];
    }
    return _dataSource;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameText.text = @"123";
    _pwdText.text = @"123";
    [self createUI];
}

- (void)createUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WMAIN, HMAIN) style:UITableViewStylePlain];
    _tbView.backgroundColor = [UIColor grayColor];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    
    [_tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellId];
    
    [self.view addSubview:_tbView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)createHttp
{
    @pas_weakify_self
    _tbView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_isUpLoad) {
            return ;
            @pas_strongify_self
            [self endRefresh];
        }
        _isLoading = YES;
    }];
    
    _tbView.footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)endRefresh
{
    
}


- (void)clickBtn
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://login?username=%@&pwd=%@",_nameText.text,_pwdText.text]];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
//    NSMutableURLRequest *mutableResuest = [[NSMutableURLRequest alloc]init];
//    [mutableResuest setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [connection start];
}





- (void)createData
{
    NSString *stringURL = [NSString stringWithFormat:@"http://login?username=%@&pwd=%@",_nameText.text,_pwdText.text];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /*
     发送一个同步请求,在主线程发送请求 ,,会阻塞主线程
     */
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    /*发送异步请求  没有返回值*/
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"**%@",[NSThread currentThread]);//打印当前线程
        if (connectionError || data == nil) {
            return ;
        }
        //json数据转换为NSString ->单后对字符串做处理-> 左后再转换为json数据
        //        NSMutableString *string = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //        NSString *dataString = [self clicpString:string];
        //        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([request isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result;
            NSString *erroeString = dict[@"error"];
            
        }
    }];
    
}

/**< AFNetWorking 数据请求*/
//- (void)createAFHttp
//{
////    if ([[JSActionModule getArray] count] == 0) {
////        [_tbView.header endRefreshing];
////        return;
////    }
//    if (_isLoading) {
//        [_dataArray removeAllObjects];
//    }
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20.f;/**< 设置延迟时间 */
//    @pas_weakify_self
//    [manager GET: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @pas_strongify_self
//        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dict = result;
//            self.mindID = [DataFormatterFunc strValueForKey:@"id" ofDict:dict];
//            NSArray *sectionArray = [DataFormatterFunc arrayValueForKey:@"records" ofDict:dict];
//            for (NSDictionary *sectionDict in sectionArray) {
//                //创建模型对象
//                PASInfoOptionalModel *model = [[PASInfoOptionalModel alloc] init];
//                model.infoCode = sectionDict[@"infoCode"];
//                [model setValuesForKeysWithDictionary:sectionDict];
//                [self.dataArray addObject:model];
//            }
//            //刷新表格
//            [self.tbView reloadData];
//            
//            if (_dataArray) {
//                _imageView.hidden = YES;
//                _bgLabel.hidden = YES;
//            }else{
//                _imageView.hidden = NO;
//                _bgLabel.hidden = NO;
//            }
//        }
//        [self endRefresh];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        @pas_strongify_self
//        [self endRefresh];
//    }];
//    
//}


#pragma mark   -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tbView dequeueReusableCellWithIdentifier:tableCellId];

    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:arc4random()%256/255.0];
    
    return cell;
}


#pragma mark   -- UIConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",response);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_dataSource appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"加载完成");
}









@end
