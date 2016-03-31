//
//  RCLineChartContentView.h
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AnimationProperty.h"
#import "WxHxD.h"
#import "UIView+SetRect.h"

@interface RCLineChartContentView : UIView

/*
 *  构造函数，必须使用
 */
-(id)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource xCount:(NSInteger)xCount yCount:(NSInteger)yCount isNeedGrid:(BOOL)needGrid;

/*
 * 缩放
 */
-(void)zoomByPoint:(CGPoint)point scale:(CGFloat)scale;

/**
 *  停止缩放  即本次缩放完成
 */
-(void)stopZoom;

/**
 *  设置列间距
 *
 *  @param widthInterval 列间距
 */
-(void)setWidthInterval:(CGFloat)widthInterval;

/*
 *  刷新数据源
 */
-(void)refreshData:(NSArray*)dataSource;


@end
