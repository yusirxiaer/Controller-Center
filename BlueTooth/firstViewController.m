//
//  firstViewController.m
//  BlueTooth
//
//  Created by sq-ios48 on 16/4/14.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "firstViewController.h"
#import "DKCircleButton.h"
#import "sendViewController.h"
#import "functionViewController.h"
#define Centerx self.view.center.x
#define Centery self.view.center.y
#define height 100
#define buttonSquareSide 150
@interface firstViewController ()
@property (nonatomic,strong)  DKCircleButton *Start;
@property (nonatomic,strong)  DKCircleButton *Function;

@end

@implementation firstViewController


#pragma mark - 懒加载
- (DKCircleButton *)Start {
    if (!_Start) {
        
        _Start = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, buttonSquareSide, buttonSquareSide)];
        
        
        _Start.titleLabel.font = [UIFont systemFontOfSize:40];
        
        [_Start setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
            [_Start setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
//            [_Start setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
        [_Start setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
            [_Start setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
            [_Start setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
        [_Start addTarget:self action:@selector(didStartClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_Start];

    }
    return _Start;
}

- (DKCircleButton *)Function {
    if (!_Function) {
        
        _Function = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, buttonSquareSide, buttonSquareSide)];
        
        
        _Function.titleLabel.font = [UIFont systemFontOfSize:35];
        
        [_Function setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
            [_Function setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
            [_Function setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
        [_Function setTitle:NSLocalizedString(@"Function", nil) forState:UIControlStateNormal];
            [_Function setTitle:NSLocalizedString(@"Function", nil) forState:UIControlStateSelected];
            [_Function setTitle:NSLocalizedString(@"Function", nil) forState:UIControlStateHighlighted];
        [_Function addTarget:self action:@selector(didFunctionClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_Function];
    }
    return _Function;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    self.title = @"BlueTooth Domain";
    [self setBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setBtn
{
    self.Start.center =CGPointMake(Centerx, Centery-height-64);
    self.Function.center =CGPointMake(Centerx, Centery+height-64);
}
-(void)didStartClicked
{
    
    sendViewController *sendVc=[[sendViewController alloc]init];
    [self.navigationController pushViewController:sendVc animated:YES];
//    [self presentViewController:sendVc animated:YES completion:nil];
}
-(void)didFunctionClicked
{
   
    functionViewController *functionVc=[[functionViewController alloc]init];
    [self.navigationController pushViewController:functionVc animated:YES];
//    [self presentViewController:sendVc animated:YES completion:nil];
}


@end
