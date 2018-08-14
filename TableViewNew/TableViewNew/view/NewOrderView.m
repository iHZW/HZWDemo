//
//  NewOrderView.m
//  TableViewNew
//
//  Created by HZW on 2017/12/29.
//  Copyright © 2017年 韩志伟. All rights reserved.
//

#import "NewOrderView.h"
#define kLeftSpace    15


@interface NewOrderView ()

@property (nonatomic, strong) NSMutableArray *sortArray;

@property (nonatomic, strong) UIImageView *imageView;

/**< 串行队列 */
@property (nonatomic, strong) dispatch_queue_t serialQueue;
/**< 并行队列 */
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) NSLock *lock;


@end

@implementation NewOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor grayColor];
        [self loadSubView];
        
//        [self GCDGroud];
//        [self threadDetail];

    }
    return self;
}

#pragma mark  -- 多线程
- (void)threadDetail
{
    /**< 1:线程死锁 */
//            NSLog(@"A:%@",[NSThread currentThread]);
    //        dispatch_sync(dispatch_get_main_queue(), ^{
    //            NSLog(@"B:%@",[NSThread currentThread]);
    //        });
    //        NSLog(@"C:%@",[NSThread currentThread]);
    
    /**< 2:没问题 */  /**< 执行顺序   A->B->C */
    NSLog(@"A:%@",[NSThread currentThread]);
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    NSLog(@"C:%@",[NSThread currentThread]);
    
    /**< 3:一样没问题  执行顺序 A->C->B */
    NSLog(@"A:%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    NSLog(@"C:%@",[NSThread currentThread]);
    
    
    
    /**< 队列和执行方式的关系 */
//    /**< 串行队列 */
//    self.serialQueue = dispatch_queue_create("test.serialQueue", DISPATCH_QUEUE_SERIAL);
//
//    /**< 并行队列 */
//    self.concurrentQueue = dispatch_queue_create("test.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    /**< 同步执行串行队列 A(1)->B(1)->C(1)*/
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    
    
    /**< 同步并行   执行结果  A(1)->B(1)->C(1)*/
    dispatch_sync(self.concurrentQueue, ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    
    dispatch_sync(self.concurrentQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    
    dispatch_sync(self.concurrentQueue, ^{
        NSLog(@"C:%@",[NSThread currentThread]);
    });
    
    /**< 异步串行 执行结果 A(3)->B(3)->C(3) 会开辟新的线程串行 */
    dispatch_async(self.serialQueue, ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    dispatch_async(self.serialQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    dispatch_async(self.serialQueue, ^{
        NSLog(@"C:%@",[NSThread currentThread]);
    });
    
    
    /**< 异步并行  执行结果  B(4)->A:(3)->C(5) 会开辟多个线程并行*/
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"C:%@",[NSThread currentThread]);
    });
    
    [self GCDOtherMethod];
}

#pragma mark  -- GCD的其他函数
- (void)GCDOtherMethod
{
    /**< 主队列 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    /**< 全局队列 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    /**< 自定义队列执行 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), self.serialQueue, ^{
        NSLog(@"C:%@",[NSThread currentThread]);
    });
}

/**< dispatch_group_t  适用于多个队列任务执行完成后通知  dispatch_group_notify
如 下载多个图片结束后合成一张大图展示
 */
- (void)GCDGroud
{
    dispatch_group_t group = dispatch_group_create();
    
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=776127947,2002573948&fm=26&gp=0.jpg"]]];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=776127947,2002573948&fm=26&gp=0.jpg"]]];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, CGRectGetHeight(self.frame)), NO, .0f);
        [image2 drawInRect:CGRectMake(0, 0, 40, CGRectGetHeight(self.frame))];
        [image1 drawInRect:CGRectMake(40, 0, 40, CGRectGetHeight(self.frame))];
        UIImage *image_3 = UIGraphicsGetImageFromCurrentImageContext();
        self.imageView.image = image_3;
        UIGraphicsEndImageContext();
    });
}

#pragma mark   -- 栅栏函数
- (void)dispatch_barrier_t
{
     /**< 执行结果 (dispatch_barrier_sync)B->A->Big->C->Small->D->E  / (dispatch_barrier_async)B->A->Big->Small->C1->D->E    */
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"A:%@",[NSThread currentThread]);
    });
    
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"B:%@",[NSThread currentThread]);
    });
    NSLog(@"Big");
    /**< dispatch_barrier_async 和 dispatch_barrier_sync 对于线程拦截作用是一样的,只不过对于其他函数 执行了同步和异步的原则 */
//    dispatch_barrier_sync(self.concurrentQueue, ^{
//        NSLog(@"C:%@",[NSThread currentThread]);
//    });
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        NSLog(@"C1:%@",[NSThread currentThread]);
    });
    
    NSLog(@"Small");

    
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"D:%@",[NSThread currentThread]);
    });
    
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"E:%@",[NSThread currentThread]);
    });
}

/**< 用于重复执行某个任务 */
- (void)dispatch_apply
{
    dispatch_apply(100, self.serialQueue, ^(size_t i) {
        /**< 串行队列顺序打印0~99 */
        NSLog(@"第%@次",@(i));
    });
    
    dispatch_apply(100, self.concurrentQueue, ^(size_t i) {
       /**< 并行队列随机打印0~99 */
        NSLog(@"第%@次",@(i));
    });
    
    /**< 需要注意的是这个函数是  同步函数  一下使用会造成线程死锁(主线程同步执行主队列任务)*/
//    dispatch_apply(100, dispatch_get_main_queue(), ^(size_t) {
//        NSLog(@"第%@次",@(i));
//    });
}

#pragma mark  -- 信号量 (初始化一个大于0 的值  相当于最大并发数)
- (void)dispatch_semaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_apply(5, self.concurrentQueue, ^(size_t i) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"第%@次%@",@(i),[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
    });
}

/**< 使用NSOperation  NSOperationQueue */
- (void)testNsOperationQueue
{
    NSBlockOperation *blockQueration = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@--%@",[NSOperationQueue currentQueue] , [NSThread currentThread]);
    }];
    [blockQueration start];
    
    [blockQueration addExecutionBlock:^{
        NSLog(@"A:%@--%@",[NSOperationQueue currentQueue] , [NSThread currentThread]);
    }];
    
    [blockQueration addExecutionBlock:^{
        NSLog(@"B:%@--%@",[NSOperationQueue currentQueue] , [NSThread currentThread]);
    }];
    
    /**< addExecutionBlock 异步并行  开辟了多个线程 */
}

#pragma mark  -- 测试线程锁
- (void)testThreadLock
{
    self.lock = [[NSLock alloc] init];
    
    for (NSInteger i=0; i<10; i++) {
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"out = %@",[self getSynchronizedSourceOut]);
        });
    }
}

/**< 线程锁 NSLock */
- (NSString *)getNSLockSourceOut
{
    NSString *sourceString = @"没有了,输光了";
    [self.lock lock];
    if (self.sortArray.count > 0) {
        sourceString = [NSString stringWithFormat:@"sourceString = %@",[[self.sortArray lastObject] stringValue]];
        [self.sortArray removeLastObject];
    }
    [self.lock unlock];
    return sourceString;
}

/**< 线程锁 synchronized */
- (NSString *)getSynchronizedSourceOut
{
    NSString *sourceString = @"没有了,输光了";
    
    @synchronized(self)
    {
        if (self.sortArray.count > 0) {
            sourceString = [NSString stringWithFormat:@"sourceString = %@",[[self.sortArray lastObject] stringValue]];
            [self.sortArray removeLastObject];
        }
    }
    return sourceString;
}

- (void)loadSubView
{
    [self addSubview:self.nameLabel];
    [self addSubview:self.textView];
    [self addSubview:self.clickBtn];
    [self.clickBtn bringSubviewToFront:self];
    [self addSubview:self.imageView];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(kLeftSpace);
        make.width.mas_equalTo(100);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.nameLabel.mas_right).offset(80);
        make.right.equalTo(self).offset(-kLeftSpace);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(80);
    }];
    
//    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self.mas_top).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
    
    
}


- (NSMutableArray *)sortArray
{
    if (!_sortArray) {
        _sortArray = [[NSMutableArray alloc] initWithArray:@[@(55), @(23),@(93),@(23),@(4),@(56),@(1),@(34),@(69)]];
    }
    return _sortArray;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = PASFont(20);
    }
    return _nameLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = .5;
        _textView.cornerRadius = 4;
        _textView.font = PASFont(15);
    }
    return _textView;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithFrame:CGRectMake(0, -20, 50, 50) target:self action:@selector(clickAction:) title:@"排序" font:PASFont(18) titleColor:UIColorFromRGB(0X00BA50) bgImage:nil tag:13132 block:nil];
        _clickBtn.backgroundColor = [UIColor blueColor];
    }
    return _clickBtn;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

#pragma mark  -- 串行队列
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("test.serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}

#pragma mark  -- 并行队列
- (dispatch_queue_t)concurrentQueue
{
    if (!_concurrentQueue) {
        _concurrentQueue = dispatch_queue_create("test.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}


- (void)clickAction:(UIButton *)sender
{
    NSLog(@"clickActionBtn");
    
    /**< 冒泡降序 */
//    [self testMPSort];
    /**< 选择升序 */
//    [self testSelectSort];
    /**< 快速排序 */
//    [self quickSortArray:self.sortArray leftIndex:0 rightIndex:self.sortArray.count-1];
    NSLog(@"self.sortArray = %@",self.sortArray);
    
    /**< 信号量测试 */
//    [self dispatch_semaphore];
    
    /**< 测试线程锁 */
//    [self testThreadLock];
    
    [self testSortForMaoPao];
    NSLog(@"testSortForMaoPao = %@",self.sortArray);
    
    [self testSortForSelect];
    NSLog(@"testSortForSelect = %@",self.sortArray);

    [self testSortForQuickWithArray:self.sortArray leftIndex:0 rightIndex:(self.sortArray.count - 1)];
    NSLog(@"testSortForQuickWithArray = %@",self.sortArray);
    
    NSLog(@"最大公约数%@",@([self testMaxGYS:3 numTwo:6]));

    NSLog(@"最小公倍数%@",@([self testMinGBS:2 numTwo:6]));
    
    NSInteger index = [self testSearchForHalf:self.sortArray searchNumber:34];
    NSLog(@"index = %@",@(index));
    
//    @([self getSearchArray:self.sortArray searchObj:69])
    
    NSLog(@"二分查找下标为 = %@",@([self testSearchForHalf:self.sortArray searchNumber:69]));

}


- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    /**< 方法一:(类方法) */
//    [NSThread detachNewThreadSelector:@selector(upLoadImage) toTarget:self withObject:nil];
    
    /**< 方法二:(对象方法) */
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(upLoadImage) object:nil];
//    [thread start];
}

- (void)upLoadImage
{
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
     //必须在主线程更新UI，Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)，waitUntilDone:是否线程任务完成执行
    [self performSelectorOnMainThread:@selector(setimageData:) withObject:imageData waitUntilDone:YES];
}

- (void)setimageData:(NSData *)imageData
{
    self.imageView.image = [UIImage imageWithData:imageData];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //判断当前控制器能否接收事件
    if (self.userInteractionEnabled == NO ||
        self.hidden == YES ||
        self.alpha < .01) {
        return nil;
    }
    
    //判断点在不在当前控制器
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
//    NSInteger count = self.subviews.count;
//
//    for (NSInteger i=count-1; i>0; i--) {
//
//        UIView *childView = self.subviews[i];
//
//        CGPoint childPoint = [self convertPoint:point toView:childView];
//
//        UIView *fitView = [self hitTest:childPoint withEvent:event];
//
//        if (fitView) {
//            return fitView;
//        }
//    }
    
    CGPoint btnPoint = [self convertPoint:point toView:self.clickBtn];
    if ([self.clickBtn pointInside:btnPoint withEvent:event]) {
        return self.clickBtn;
    }
    
    return [super hitTest:point withEvent:event];
    
//    return self;
}

#pragma mark  -- 冒泡排序
- (void)testMPSort{
    
    int array[10] = {55, 23, 93, 23, 4, 56, 1, 34, 11, 69};
    int number = sizeof(array)/sizeof(int);
    for (NSInteger i=0; i<number-1; i++) {
        for (NSInteger j=0; j<number-1-i; j++) {
            if (array[j] < array[j+1]) {
                int temp = array[j];
                array[j] = array[j+1];
                array[j+1] = temp;
            }
        }
    }
    
    for (NSInteger i=0; i<number-1; i++) {
        printf("result = %d",array[i]);
        
        if (i == number - 1) {
            printf("\n");
        }else{
            printf(" ");
        }
    }
}


- (void)testSelectSort
{
    int array[10] = {55, 23, 93, 23, 4, 56, 1, 34, 11, 69};
    
    int number = sizeof(array)/sizeof(int);
    
    for (NSInteger i=0; i<number-1; i++) {
        
        for (NSInteger j=i+1; j<number-1; j++) {
            /**< 升序排列 */
            if (array[i] > array[j]) {
                int temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
    }
    
    for (NSInteger i=0; i<number - 1; i++) {
        printf("%d",array[i]);
        if (i == number - 1) {
            printf("\n");
        }else{
            printf(" ");
        }
    }
}


/**< 快速排序 */
//- (void)quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex
//{
//    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
//        return ;
//    }
//
//    NSInteger i = leftIndex;
//    NSInteger j = rightIndex;
//    /**< 记录基准数 */
//    NSInteger key = [array[i] integerValue];
//
//    while (i < j) {
//        /**< 先从右侧查找比基准数小的值 */
//        while (i < j && [array[j] integerValue] >= key) {
//            j--;
//        }
//        /**< 如果比基准数小则找到的小值移动到i的位置 */
//        array[i] = array[j];
//        /**< 右侧查到一个比基准数小的值,就从i开始往后找比基准数大的值 */
//        while (i<j && [array[i] integerValue] <= key) {
//            i++;
//        }
//        /**< 如果比基数大则调整到右侧 */
//        array[j] = array[i];
//    }
//
//    array[i] = @(key);
//    /**< 递归排序 */
//    /**< 基准数左侧的 */
//    [self quickSortArray:array leftIndex:leftIndex rightIndex:i-1];
//    /**< 基准数右侧的 */
//    [self quickSortArray:array leftIndex:i+1 rightIndex:rightIndex];
//}

/**< 快速排序 */
- (void)quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {
        return;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    /**< 参考值 */
    NSInteger key = [array[i] integerValue];
    
    while (i < j) {
        /**< 先从右侧开始遍历找到比基准值小的移动到i的位置 */
        while (i < j && [array[j] integerValue] >= key) {
            j--;
        }
        array[i] = array[j];
        
        /**< 然后从i的位置开始遍历找到比基准值大的移动到j的位置 */
        while (i<j && [array[i] integerValue] <= key) {
            i++;
        }
        array[j] = array[i];
    }
    
    array[i] = @(key);
    
    [self quickSortArray:array leftIndex:leftIndex rightIndex:i-1];
    [self quickSortArray:array leftIndex:i+1 rightIndex:rightIndex];
}




- (void)testSortForMaoPao
{
    NSInteger num = self.sortArray.count;
    for (NSInteger i=0; i<num - 1; i++) {
        for (NSInteger j=0; j<num-1-i; j++) {
            if (self.sortArray[j] > self.sortArray[j+1]) {
                NSInteger temp = [self.sortArray[j] integerValue];
                self.sortArray[j] = self.sortArray[j+1];
                self.sortArray[j+1] = @(temp);
            }
        }
    }
}


- (void)testSortForSelect
{
    NSInteger num = self.sortArray.count;
    
    for (NSInteger i=0; i<num-1; i++) {
        for (NSInteger j=i+1; j<num-1; j++) {
            if ([self.sortArray[i] integerValue] > [self.sortArray[j] integerValue]) {
                NSInteger temp = [self.sortArray[i] integerValue];
                self.sortArray[i] = self.sortArray[j];
                self.sortArray[j] = @(temp);
            }
        }
    }
}


- (void)testSortForQuickWithArray:(NSMutableArray *)array
                        leftIndex:(NSInteger)leftIndex
                       rightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {
        return;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    NSInteger key = [array[i] integerValue];
    
    while (i<j) {
        while (i<j && [array[j] integerValue] >= key) {
            j--;
        }
        
        array[i] = array[j];
        
        while (i<j && [array[i] integerValue] < key) {
            i++;
        }
        
        array[j] = array[i];
    }
    
    array[i] = @(key);
    
    [self testSortForQuickWithArray:array leftIndex:leftIndex rightIndex:i-1];
    [self testSortForQuickWithArray:array leftIndex:i+1 rightIndex:rightIndex];
}


/**< 二分查找  前提数组是有序的 */
- (NSInteger)testSearchForHalf:(NSMutableArray *)array searchNumber:(NSInteger)searchNumber
{
    NSInteger index = -1;
    if (array.count  >0) {
        NSUInteger low = 0;
        NSUInteger height = array.count-1;
        while (low <= height) {
            NSUInteger mid = low + (height - low)/2;
            NSInteger num = [[array objectAtIndex:mid] integerValue];
            if (searchNumber == num) {
                index = mid;
                break;
            }else if (searchNumber > num){
                low++;
            }else if (searchNumber < num){
                height++;
            }
        }
    }

    return index;
}

/**< 二分查找法 */
- (NSInteger)getSearchArray:(NSMutableArray *)array searchObj:(NSInteger)searchObj
{
    NSInteger index = -1;
    
    NSInteger low = 0;
    NSInteger height = array.count-1;
    
    while (low <= height) {
        NSInteger mid = low + (height - low)/2;
        NSInteger midValue = [array[mid] integerValue];
        
        if (searchObj == midValue) {
            index = mid;
            break;
        }else if (midValue > searchObj){
            height -= 1;
        }else{
            low += 1;
        }
    }
    return index;
}

/**< 有序的数组找到某个值在数组中的位置 找不到就返回-1*/
- (NSInteger)getHalfSearchArray:(NSMutableArray *)array searchObj:(NSInteger)searchObj
{
    NSInteger index = -1;
    
    NSInteger low = 0;
    NSInteger height = array.count - 1;
    
    while (low <= height) {
        NSInteger mid = low + (height - low)/2;
        NSInteger midValue = [array[mid] integerValue];
        
        if (midValue == searchObj) {
            index = mid;
            break;
        }else if (midValue > searchObj){
            height -= 1;
        }else{
            low += 1;
        }
    }
    return index;
}




/**< 求两个数的最大公约数 */
- (NSInteger)testMaxGYS:(NSInteger)numOne numTwo:(NSInteger)numTwo
{
    while (numOne != numTwo) {
        if (numOne > numTwo) {
            numOne = numOne - numTwo;
        }else{
            numTwo = numTwo - numOne;
        }
    }
    return numOne;
}


/**< 求两个数的最小公倍数 */
- (NSInteger)testMinGBS:(NSInteger)numOne numTwo:(NSInteger)numTwo
{
    NSInteger maxGYS = [self testMaxGYS:numOne numTwo:numTwo];
    NSInteger minCBS = maxGYS == 0 ? 0 : (numOne * numTwo/maxGYS);
    return minCBS;
}

@end
