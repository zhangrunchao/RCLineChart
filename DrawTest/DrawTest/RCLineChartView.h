//
//  RCChartView.h
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCLineChartView : UIView
/**
 * 初始化
 * title  : 图表名
 * xTitle : X轴名称
 * yTitle : Y轴名称
 * xCount : x显示数量
 * yCount : Y显示数量
 */
-(id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource title:(NSString *)title xTitle:(NSString*)xTitle yTitle:(NSString*)yTitle xCount:(NSInteger)xCount yCount:(NSInteger)yCount isNeedGrid:(BOOL)needGrid;
/**
 *  设置列间距
 *
 *  @param widthInterval 列间距
 */
-(void)setWidthInterval:(CGFloat)widthInterval;

/*
 *刷新数据源
 */
-(void)refreshData:(NSArray*)dataSource;

@end
