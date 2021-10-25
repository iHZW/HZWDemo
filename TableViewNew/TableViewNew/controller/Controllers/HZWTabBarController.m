//
//  HZWTabBarController.m
//  TableViewNew
//
//  Created by HZW on 2018/1/8.
//  Copyright © 2018年 韩志伟. All rights reserved.
//

#import "HZWTabBarController.h"
#import "HSViewConrtroller.h"

@interface HZWTabBarController ()

@end

@implementation HZWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor purpleColor];
//    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@""] tag:100];
//    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"我以外的" image:[UIImage imageNamed:@""] tag:101];
//    NSArray *array = @[tabBarItem1,tabBarItem2];
//    [self.tabBar setItems:array];
   
    
    HSViewConrtroller *ctrl1 = [[HSViewConrtroller alloc] init];
    UINavigationController *navCtrl1 = [[UINavigationController alloc] initWithRootViewController:ctrl1] ;
    ctrl1.title = @"我的";
    [self addChildViewController:navCtrl1];
    
    
    HSViewConrtroller *ctrl2 = [[HSViewConrtroller alloc] init];
    UINavigationController *navCtrl2 = [[UINavigationController alloc] initWithRootViewController:ctrl2] ;
    ctrl2.title = @"我以外的";
    [self addChildViewController:navCtrl2];
    
    // Do any additional setup after loading the view.
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
