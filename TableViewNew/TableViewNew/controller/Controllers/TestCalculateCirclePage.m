//
//  TestCalculateCirclePage.m
//  TableViewNew
//
//  Created by HZW on 2018/12/21.
//  Copyright © 2018 韩志伟. All rights reserved.
//

#import "TestCalculateCirclePage.h"

@interface TestCalculateCirclePage ()

@property (nonatomic, strong) UIView *circleBackView;


@end

@implementation TestCalculateCirclePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleBackView];
    
    [self createCircleSubView];
    
}

- (UIView *)circleBackView
{
    if (!_circleBackView) {
        _circleBackView = [UIView viewForColor:UIColorFromRGB(0xEDEDED) withFrame:CGRectMake(20, 150, kMainScreenWidth - 20*2, kMainScreenWidth - 20*2)];
    }
    return _circleBackView;
}


/**< 创建 */
- (void)createCircleSubView
{
    int count = 30;
    for (NSInteger i=0; i<count; i++) {
        CGFloat value = 360/count;
        CGFloat R = CGRectGetWidth(self.circleBackView.frame)/2;
        CGFloat X = R;//CGRectGetMidX(self.circleBackView.frame);
        CGFloat Y = 0;
        
        CGFloat m = R * sin([self huDuFromdu:(value*i)]);
        CGFloat n = R - R * cos([self huDuFromdu:(value*i)]);
        if (i != 0) {
            X += m;
            Y += n;
        }
        CGRect rect = CGRectMake(0, 0, 30, 30);
        UILabel *label = [UILabel labelWithFrame:rect text:[NSString stringWithFormat:@"%@",@(i)] textColor:[UIColor blueColor] font:PASFont(15)];
        [self.circleBackView addSubview:label];
        label.center = CGPointMake(X, Y);
    }
}

-(float)huDuFromdu:(float)du
{
    return M_PI/(180/du);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
