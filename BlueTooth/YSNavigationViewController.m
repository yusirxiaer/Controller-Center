//
//  YSNavigationViewController.m
//  YUSIR微博客户端2.0
//
//  Created by sq-ios40 on 16/3/9.
//  Copyright © 2016年 YUSIR. All rights reserved.
//

#import "YSNavigationViewController.h"

@interface YSNavigationViewController ()

@end

@implementation YSNavigationViewController

/**
 *  第一次使用这个类的时候会调用（1个类只会调用一次）
 */
+ (void)initialize {
    [self setupNaviBarTheme];
    
    [self setupBarButtonItemTheme];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -设置导航栏
/**
 *  设置导航栏主题
 */
+ (void)setupNaviBarTheme {
    // 取出appearance
    UINavigationBar *naviBar = [UINavigationBar appearance];
    
    // 设置背景
//        [naviBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    //设置导航栏背景
    naviBar.barTintColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    //设置透明度
    [naviBar setTranslucent:NO];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:25];
    [naviBar setTitleTextAttributes:textAttrs];
    
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme {
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
//    [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // 设置普通状态
    // key：NS****AttributeName
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] =  [UIColor lightGrayColor];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


@end
