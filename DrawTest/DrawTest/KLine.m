//
//  KLine.m
//  DrawTest
//
//  Created by ZRC on 16/3/31.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "KLine.h"
#import "HexColors.h"
#import "KColor.h"
#import "UIColor+helper.h"
@implementation KLine
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.startPoint = self.frame.origin;
        self.endPoint = self.frame.origin;
        self.lineWidth = 2.0f;
        self.isKLine= NO;
        self.isVol = NO;
        self.lineColor = @"#000000";

    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    
    // 获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.isKLine) {
        // 画k线
        for (NSArray *item in self.points) {
            // 转换坐标
            CGPoint heightPoint,lowPoint,openPoint,closePoint;
            heightPoint = CGPointFromString([item objectAtIndex:0]);
            lowPoint = CGPointFromString([item objectAtIndex:1]);
            openPoint = CGPointFromString([item objectAtIndex:2]);
            closePoint = CGPointFromString([item objectAtIndex:3]);
            [self drawKLineContext:context height:heightPoint low:lowPoint open:openPoint close:closePoint];
        }
        
    }else{
        // 画连接线
        [self drawNormalLineContext:context];
    }

}

/**
 *  画普通线段
 *  如果startpoint和endpoint的x，y轴相同，表示一个区域。
 *  如果不同 表示一个线段
 *
 *  @param context context
 */
-(void)drawNormalLineContext:(CGContextRef)context{
    CGContextSetLineWidth(context, self.lineWidth);
    //抗锯齿
    CGContextSetShouldAntialias(context, YES);
    //设置线条颜色
    KColor *colormodel = [UIColor RGBWithHexString:self.lineColor withAlpha:self.alpha];
   CGContextSetRGBStrokeColor(context, (CGFloat)colormodel.R/255.0f, (CGFloat)colormodel.G/255.0f, (CGFloat)colormodel.B/255.0f, self.alpha);
    if (self.startPoint.x == self.endPoint.x && self.endPoint.y == self.startPoint.y) {
        // 定义多个个点 画多点连线
        for (id item in self.points) {
            CGPoint currentPoint = CGPointFromString(item);
            if ((int)currentPoint.y < (int)self.frame.size.height && currentPoint.y>0) {
                if ([self.points indexOfObject:item] == 0) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                    continue;
                }
                CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
                CGContextStrokePath(context); //开始画线
                if ([self.points indexOfObject:item] < self.points.count) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                }
                
            }
        }
    }else{
        // 定义两个点 画两点连线
        const CGPoint points[] = {self.startPoint,self.endPoint};
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
}


-(void)drawKLineContext:(CGContextRef)context height:(CGPoint)heightPoint low:(CGPoint)lowPoint open:(CGPoint)openPoint close:(CGPoint)closePoint {
    //抗锯齿
    CGContextSetShouldAntialias(context, NO);
    // 首先判断是绿的还是红的，根据开盘价和收盘价的坐标来计算
    BOOL isKong = NO;
    CGContextSetRGBStrokeColor(context, 255/255.0f, 0/255.0f, 0/255.0f, 1);
    // 如果开盘价在收盘价上方 则为绿色 即空
    if (openPoint.y<closePoint.y) {
        isKong = YES;
        CGContextSetRGBStrokeColor(context, 0/255.0f, 255/255.0f, 255/255.0f, 1);
    }
    // 设置颜色
    
    // 首先画一个垂直的线包含上影线和下影线
    // 定义两个点 画两点连线
    if (!self.isVol) {
        CGContextSetLineWidth(context, 1); // 上下阴影线的宽度
        if (self.lineWidth<=2) {
            CGContextSetLineWidth(context, 0.5); // 上下阴影线的宽度
        }
        const CGPoint points[] = {heightPoint,lowPoint};
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    // 再画中间的实体
    CGContextSetLineWidth(context, self.lineWidth); // 改变线的宽度
    CGFloat halfWidth = 0;//width/2;
    // 纠正实体的中心点为当前坐标
    openPoint = CGPointMake(openPoint.x - halfWidth, openPoint.y);
    closePoint = CGPointMake(closePoint.x-halfWidth, closePoint.y);
    if (self.isVol) {
        openPoint = CGPointMake(heightPoint.x-halfWidth, heightPoint.y);
        closePoint = CGPointMake(lowPoint.x-halfWidth, lowPoint.y);
    }
    // 开始画实体
    const CGPoint point[] = {openPoint,closePoint};
    CGContextStrokeLineSegments(context, point, 2);  // 绘制线段（默认不绘制端点）
    //CGContextSetLineCap(context, kCGLineCapSquare) ;// 设置线段的端点形状，方形
}

@end
