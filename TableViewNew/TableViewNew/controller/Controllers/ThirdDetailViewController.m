//
//  ThirdDetailViewController.m
//  TableViewNew
//
//  Created by HZW on 15/11/16.
//  Copyright © 2015年 韩志伟. All rights reserved.
//

#import "ThirdDetailViewController.h"

@interface ThirdDetailViewController ()
{
    
    
}

@property (nonatomic, strong) UITextField *textFieldA;
@property (nonatomic, strong) UITextField *textFieldB;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *afterMutableArray;
@property (nonatomic, strong) NSArray *beforeArray;
@property (nonatomic, strong) NSArray *afterArray;
@property (nonatomic, strong) UILabel *contentLabel; /**< 显示label内容 */





@end


@implementation ThirdDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createData];
    
    
    
#ifndef FINISH_TEST
    [self createView];
#endif
    
/**< FIRST_OBJECT_TRUE 为真 执行第一个 ,否则只想第二个 */
#ifdef FIRST_OBJECT_TRUE
#define kTESTVALUE       2
#else
#define kTESTVALUE       3
#endif
    
    NSLog(@"kTESTVALUE = %@",@(kTESTVALUE));

}

- (void)createData
{
    self.dataArray = [NSMutableArray array];
    self.beforeArray = [NSArray arrayWithObjects:@"2",@"4",@"1", nil];
    _dataArray = [NSMutableArray arrayWithArray:self.beforeArray];
    
    self.afterArray = [NSArray array];
    self.afterArray = [self arraySort];
    
}


- (NSArray *)arraySort
{
    NSArray *array = [self.beforeArray sortedArrayUsingSelector:@selector(compare:)];
    
    return array;
}


- (void)createView
{
    self.textFieldA = [[UITextField alloc]initWithFrame:CGRectMake(50, 80, 200, 40)];
    _textFieldA.borderStyle = UITextBorderStyleRoundedRect;
    NSMutableString *str = [NSMutableString string];
    for (NSInteger i=0; i<[_beforeArray count]; i++) {
        [str appendString:[NSString stringWithFormat:@"%@",self.beforeArray[i]]];
    }
    _textFieldA.text = str;
    [self.view addSubview:_textFieldA];
    
    
    self.textFieldB = [[UITextField alloc]initWithFrame:CGRectMake(50, 140, 200, 40)];
    _textFieldB.borderStyle = UITextBorderStyleRoundedRect;
    
    NSMutableString *str2 = [NSMutableString string];
    for (NSInteger i=0; i<[_afterArray count]; i++) {
        [str2 appendString:[NSString stringWithFormat:@"%@",self.afterArray[i]]];
    }
    _textFieldB.text = str2;
    [self.view addSubview:_textFieldB];
    
    self.contentLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"asdfsdfqwerqweqeacsqewrqwerqwexqwexqweroqjpwjix;npiuehquixnfqc;;;";
    CGFloat height = [self.contentLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.frame = CGRectMake(50, 200, 100, height);
    [self.view addSubview:self.contentLabel];
    
}















@end
