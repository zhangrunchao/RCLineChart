//
//  ViewController.m
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "ViewController.h"
#import "RCLineChartView.h"
#import "RCLineChartModel.h"
#import "WxHxD.h"
#import "UIView+SetRect.h"

@interface ViewController ()
@property (nonatomic,strong) RCLineChartView *chartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0 ; i < 70 ;  i++) {
        RCLineChartModel *model = [[RCLineChartModel alloc] initWithX:[NSString stringWithFormat:@"%d月",(i+1)] Y:@[[NSNumber numberWithInt:arc4random() % 100],[NSNumber numberWithInt:arc4random() % 100],[NSNumber numberWithInt:arc4random() % 100]]];
        
        [dataArray addObject:model];
    }
    
    _chartView = [[RCLineChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 300) dataSource:dataArray title:@"测试" xTitle:nil yTitle:nil xCount:[dataArray count] yCount:5 isNeedGrid: YES];
    
    
    [_chartView setWidthInterval:50];
    
    [self.view addSubview:_chartView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
