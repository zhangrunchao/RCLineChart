//
//  KLineView.h
//  DrawTest
//
//  Created by ZRC on 16/3/31.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDataModel.h"

typedef void(^updateBlock)(id);


@interface KLineView : UIView
@property (nonatomic,retain) KDataModel *dataModel;
@property (nonatomic,retain) NSDate *startDate;
@property (nonatomic,retain) NSDate *endDate;
@property (nonatomic,assign) CGFloat xWidth; // x轴宽度
@property (nonatomic,assign) CGFloat yHeight; // y轴高度
@property (nonatomic,assign) CGFloat bottomHeight;
@property (nonatomic,assign) CGFloat kLineWidth; // k线的宽度 用来计算可存放K线实体的个数，也可以由此计算出起始日期和结束日期的时间段
@property (nonatomic,assign) CGFloat kLinePadding;
@property (nonatomic,retain) UIFont *font;
@property (nonatomic,copy) updateBlock finishUpdateBlock; // 定义一个block回调 更新界面
@property(nonatomic,assign) NSInteger rows;         //行数

-(id)initWithFrame:(CGRect)frame dataModel:(KDataModel*)model;
-(void)start;
-(void)update;
-(void)refreshData:(KDataModel*)datas;
@end
