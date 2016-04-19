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
#import "KLineView.h"
#import "KDataModel.h"

@interface ViewController ()
@property (nonatomic,strong) RCLineChartView *chartView;
@property (nonatomic,strong) KLineView       *lineView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:1];
//  线形图数据
    for (int i = 0 ; i < 70 ;  i++) {
        RCLineChartModel *model = [[RCLineChartModel alloc] initWithX:[NSString stringWithFormat:@"%d月",(i+1)] Y:@[[NSNumber numberWithInt:arc4random() % 100],[NSNumber numberWithInt:arc4random() % 100],[NSNumber numberWithInt:arc4random() % 100]]];
        
        [dataArray addObject:model];
    }
//    线形图
    _chartView = [[RCLineChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 300) dataSource:dataArray title:@"测试" xTitle:nil yTitle:nil xCount:[dataArray count] yCount:5 isNeedGrid: YES];
    
    
    [_chartView setWidthInterval:50];
    
    [self.view addSubview:_chartView];
    
    
    
//    //K线图数据
//    for (int i = 0 ; i < 70 ;  i++) {
//        KModel *m = [[KModel alloc] init];
//        m.date = [NSString stringWithFormat:@"%d",i+1];
//        m.open = [NSNumber numberWithInt:arc4random() % 10000];
//        m.close = [NSNumber numberWithInt:arc4random() % 10000];
//        m.high =[NSNumber numberWithInt:arc4random() % 10000];
//        m.salesVolume = [NSNumber numberWithInt:arc4random() % 10000];
//        m.low = [NSNumber numberWithInt: [m.open intValue] - 5];
//        [dataArray addObject:m];
//    }
//    CGFloat kLineWidth = 5;
//    CGFloat kLinePadding = 1;
//
//    KDataModel *model = [[KDataModel alloc] initWithData:dataArray kCount:260/(kLineWidth + kLinePadding)+1];
//    //K线图
//    _lineView = [[KLineView alloc]  initWithFrame: CGRectMake(0, 200, 310, 200) dataModel:model];
// 
//    _lineView.kLineWidth = kLineWidth;
//    _lineView.kLinePadding = kLinePadding;
//    _lineView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_lineView];
//
//    [_lineView start]; // k线图运行



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
