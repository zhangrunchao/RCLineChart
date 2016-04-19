//
//  RCLineChartContentView.m
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "RCLineChartContentView.h"
#import "RCLineChartModel.h"
#import "RCLineChartCommon.h"

#define DEFAULT_Y_COUNT 4 //默认可见区域y轴竖线总数
#define DEFAULT_X_COUNT 15 //默认可见区域x轴总数
#define DEFAULT_TEXT_FONT 8

#define MARGIN_LEFT 40
#define MARGIN_RIGHT 15
#define MARGIN_BOTTOM 30

#define WIDTH_INTERVAL 5


@interface RCLineChartContentView()<UIGestureRecognizerDelegate>
@property (strong, nonatomic)   NSMutableArray    *xArray; //x轴刻度
@property (strong, nonatomic)   NSMutableArray    *yArray; //左边y轴刻度
@property (strong, nonatomic)   NSArray           *dataSource; //数据源
@property (nonatomic, assign)   CGFloat           xContentScroll;   //x滚动距离


@property (nonatomic)           NSInteger         xLabelShowCount; //X轴显示标签总数
@property (nonatomic)           NSInteger         currYStepCount; //当前y轴刻度总数
@property (nonatomic)           NSInteger         totalXCount;     //X轴总数
@property (nonatomic,strong)    CAShapeLayer      *contentLayer;
@property (nonatomic)           CGPoint           lastScalePoint;   //上次缩放点


//左边距
@property CGFloat marginLeft;
//右边距
@property CGFloat marginRight;
//底边距
@property CGFloat marginBottom;
//x平均宽度
@property CGFloat xPerStepWidth;
//y平均高度
@property CGFloat yPerStepHeight;
//xy文本字体
@property (strong, nonatomic) UIFont *xyTextFont;
//xy文本颜色
@property (strong, nonatomic) UIColor *xyTextColor;
//数据行颜色
@property UIColor *dataLineColor;

@property(nonatomic) int maxY;          //Y最大值
@property(nonatomic) int minY;          //Y最小值
@property(nonatomic) int distanceY;     //Y距离
@property(nonatomic) CGFloat scaleLevel;    //缩放等级
@property(nonatomic) CGFloat curScaleLevel; //本次缩放
@property(nonatomic) BOOL isNeedGrid;
@end

@implementation RCLineChartContentView

/*
 *  xCount : X显示个数
 *  yCount : Y显示个数
 */
-(id)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource xCount:(NSInteger)xCount yCount:(NSInteger)yCount isNeedGrid:(BOOL)needGrid{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = dataSource;
        self.totalXCount = self.dataSource.count;
        self.xLabelShowCount = xCount;
        self.currYStepCount = yCount;
        self.xyTextFont = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        self.xyTextColor = [UIColor lightGrayColor];
        self.dataLineColor = [UIColor lightGrayColor];
        self.isNeedGrid = needGrid;
        //总缩放等级
        _scaleLevel = 1;
        //本次缩放等级
        _curScaleLevel = 1;
        
        [self refreshConfig];
        
    }
    return self;
}



-(void)refreshConfig{

    double Ymax = 0 ,Ymin = 0;
    
    //获取Y轴最大最小值
    for(int i = 0 ; i < [self.dataSource count] ; i++){
        
        RCLineChartModel *model = [self.dataSource objectAtIndex:i];
        NSArray *valuesY = model.valuesY;
        for (int j = 0; j < valuesY.count; j++) {
            double value  = [valuesY[j] doubleValue];
            if (Ymax < value) {
                Ymax = value;
            }else if(Ymin > value){
                Ymin = value;
            }

        }
    }
    
    //Y轴最大值 提高0.2
    self.maxY = (int)(Ymax * 1.2);
    self.minY = (int)(Ymin * 0.8f);
    self.distanceY = (Ymax - Ymin) / (self.currYStepCount );
    
    
    //X轴 列间距
    self.xPerStepWidth = WIDTH_INTERVAL;
    //Y轴 行间距
    self.yPerStepHeight = (self.height - MARGIN_BOTTOM) / (self.currYStepCount + 1);

    

}


-(void)drawRect:(CGRect)rect{
    
    //画横坐标轴和纵坐标轴
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, .2f, .2f, .2f, .6);
    CGContextMoveToPoint(ctx, MARGIN_LEFT, 0);
    CGContextAddLineToPoint(ctx, MARGIN_LEFT, self.height - MARGIN_BOTTOM);
    CGContextAddLineToPoint(ctx, self.width , self.height - MARGIN_BOTTOM);
    CGContextStrokePath(ctx);
    
    //画横坐标标签
    NSMutableDictionary *attribute              = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraphStyle     = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment                    = NSTextAlignmentCenter;
    attribute[NSForegroundColorAttributeName]   = [UIColor blackColor];
    attribute[NSFontAttributeName]              = [UIFont systemFontOfSize:11];
    attribute[NSParagraphStyleAttributeName]    = paragraphStyle;
    for(int i = 0 ; i < [self.dataSource count]; i++){
        RCLineChartModel *model = [self.dataSource objectAtIndex:i];
        CGContextSetRGBStrokeColor(ctx, .2f, .2f, .2f, .2f);
        
        float x = MARGIN_LEFT + ((i + 1) * self.xPerStepWidth + self.xContentScroll) * _scaleLevel *_curScaleLevel;
        if (x < MARGIN_LEFT ) {
            //如果x值小于左边距 则忽略
            continue;
        }
        
        //显示横坐标标签   即如 xLabelShowCount = 5  dataSource有30个点，则显示 0 ，6，12，18，24，30
        if ( i % (int)(self.dataSource.count / self.xLabelShowCount) == 0  || i == self.dataSource.count - 1) {
            CGRect cubeRect = CGRectMake(MARGIN_LEFT + ((2 * i + 1) / 2.0 * self.xPerStepWidth+self.xContentScroll) * _scaleLevel * _curScaleLevel, self.height - MARGIN_BOTTOM, self.xPerStepWidth * _scaleLevel * _curScaleLevel, MARGIN_BOTTOM);
            [model.valueX drawInRect:cubeRect withAttributes:attribute];
        }
       
        
        //是否需要画网格
        if (self.isNeedGrid) {
            CGContextMoveToPoint(ctx,x , self.height - MARGIN_BOTTOM);
            CGContextSetRGBStrokeColor(ctx, .2f, .2f, .2f, .6);
            CGContextAddLineToPoint(ctx, x, 0);
            
        }
        CGContextStrokePath(ctx);

    }
    
    
    
    
    
    //画纵坐标标签
    for (int i = 0 ; i < (self.currYStepCount+1); i++) {
        int value       = (self.minY + i * self.distanceY) * _curScaleLevel *_scaleLevel;
        CGRect cubeRect = CGRectMake(5, self.height - MARGIN_BOTTOM - 10 - i * self.yPerStepHeight, MARGIN_LEFT - 5 , 20);
        [[NSString stringWithFormat:@"%d",value] drawInRect:cubeRect withAttributes:attribute];
        CGContextSetRGBStrokeColor(ctx, .2f, .2f, .2f, .1f);
        if (self.isNeedGrid) {

            CGContextMoveToPoint(ctx, MARGIN_LEFT, self.height - MARGIN_BOTTOM - i * self.yPerStepHeight);
            CGContextAddLineToPoint(ctx, self.width - MARGIN_RIGHT , self.height - MARGIN_BOTTOM - i * self.yPerStepHeight);
        
        }
        CGContextStrokePath(ctx);


    }
    //临时存放
    NSMutableArray *pointArray = [NSMutableArray new];
    
    //画点
    for ( int i = 0; i<[self.dataSource count]; i++) {
        //取出model
        RCLineChartModel *model = [self.dataSource objectAtIndex:i];
        //获取y值 处理多维数组  x:2016-04-19  Y:15,25,35
        NSArray *valuesArray    = model.valuesY;
    
        for (int j = 0 ; j < valuesArray.count; j++) {
            //如果第一次循环  生成字典
            if (i == 0 ) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]  initWithCapacity:1];
                [pointArray addObject:dic];
            }
            //依次取出model中第j个值
            double           d      = [[valuesArray objectAtIndex:j] doubleValue];
            //计算当前值得x坐标
            float            x      = MARGIN_LEFT + ((i + 1) * self.xPerStepWidth  + self.xContentScroll) * _curScaleLevel * _scaleLevel;
            
            //判断x坐标是否小于左边距
            if (x < MARGIN_LEFT ) {
                //如果x坐标小于左边距 判断model的索引  如果是最后一个Model则break;
                if (i == self.dataSource.count - 1) {
                    break;
                }else{
                    //如果model不是最后一个 则记录临时点 即 i --> 索引   d-->数值  并循环下一次
                    //记录临时点
                    NSMutableDictionary *dic = [pointArray objectAtIndex:j];
                    [dic setObject:[NSNumber numberWithInt:i] forKey:@"i"];
                    [dic setObject:[NSNumber numberWithDouble:d] forKey:@"d"];
                    continue;
                }
            }else {
                //x坐标大于左边距
                //计算y坐标
                CGFloat          y      = self.height - MARGIN_BOTTOM -  (d / (self.distanceY*_curScaleLevel *_scaleLevel)) * self.yPerStepHeight;
                
                CGPoint startPoint ;
                CGPoint endPoint   ;

                
                if ( i == 0) {
                    //绘制第一个点前 先将画笔移动到原点到第一个点直线 与 Y轴的交点 则记录临时点 即 i --> 索引   d-->数值  并循环下一次
                    NSMutableDictionary *dic = [pointArray objectAtIndex:j];
                    [dic setObject:[NSNumber numberWithInt:i] forKey:@"i"];
                    [dic setObject:[NSNumber numberWithDouble:d] forKey:@"d"];
                    
                    //计算开始点坐标和结束点坐标
                    startPoint = CGPointMake(MARGIN_LEFT,  [self pointByLineAndYAxixFromPointA:CGPointMake(MARGIN_LEFT+_xContentScroll  *_curScaleLevel *_scaleLevel                                                                                                                                                                                                   , self.height - MARGIN_BOTTOM) pointB:CGPointMake(x, y) resultX:MARGIN_LEFT]);
                    endPoint   = CGPointMake(x, y);
                    
                    //画线和点
                    [RCLineChartCommon drawLine:ctx startPoint:startPoint endPoint:endPoint lineColor:[UIColor colorWithRed:.6f green:.4f blue:.5f alpha:1]];
                    
                    [RCLineChartCommon drawPoint:ctx point:CGPointMake(x, y ) color:[UIColor colorWithRed:.3f green:.6f blue:.9f alpha:1]];
                
                }else{
                    //如果不是第一个 则取出上一个临时点
                    NSMutableDictionary *dic =[pointArray objectAtIndex:j];
                    NSInteger ki = [[dic objectForKey:@"i"] integerValue];
                    double    kd = [[dic objectForKey:@"d"] doubleValue];
                    
                    //计算上一个临时点的x坐标及y坐标
                    CGFloat lastY =self.height - MARGIN_BOTTOM -  (kd / (self.distanceY*    _curScaleLevel *_scaleLevel)) * self.yPerStepHeight;
                    CGFloat lastX =MARGIN_LEFT + ((ki+1) * self.xPerStepWidth+_xContentScroll ) * _curScaleLevel * _scaleLevel;
                    
                    //判断上一个坐标x点是否小于左边
                    if (lastX < MARGIN_LEFT) {
                        //计算上一个点与当前点的直线  和 左边的焦点
                        startPoint = CGPointMake(MARGIN_LEFT,  [self pointByLineAndYAxixFromPointA:CGPointMake(lastX,lastY) pointB:CGPointMake(x, y) resultX:MARGIN_LEFT]);
                        endPoint   = CGPointMake(x, y);
                        //连接两点
                        [RCLineChartCommon drawLine:ctx startPoint:startPoint endPoint:endPoint lineColor:[UIColor colorWithRed:.6f green:.4f blue:.5f alpha:1]];
                    }else{
                        //连接上一点和当前点
                        startPoint = CGPointMake(lastX,lastY);
                        endPoint   = CGPointMake(x, y);
                        [RCLineChartCommon drawLine:ctx startPoint: startPoint endPoint: endPoint lineColor:[UIColor colorWithRed:.6f green:.4f blue:.5f alpha:1]];
                    }

                    //画线
                    [RCLineChartCommon drawPoint:ctx point:CGPointMake(MARGIN_LEFT + ((i + 1) * self.xPerStepWidth + self.xContentScroll) *_curScaleLevel *_scaleLevel, y ) color:[UIColor colorWithRed:.3f green:.6f blue:.9f alpha:1]];
                    //记录临时点
                    [dic setObject:[NSNumber numberWithInt:i] forKey:@"i"];
                    [dic setObject:[NSNumber numberWithDouble:d] forKey:@"d"];
                    
                }
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                path.lineCapStyle = kCGLineCapRound; //线条拐角
                path.lineJoinStyle = kCGLineCapRound; //终点处理
                
                [path moveToPoint:CGPointMake(startPoint.x , self.height - MARGIN_BOTTOM)];
                
                // Draw the lines
                [path addLineToPoint:startPoint];
                [path addLineToPoint:endPoint];
                [path addLineToPoint:CGPointMake(endPoint.x , self.height - MARGIN_BOTTOM)];
                [path closePath];//第五条线通过调用closePath方法得到的
                
                
                //画渐变
                UIColor *lineStartColor =[UIColor colorWithRed:j*0.88+0.1 green:(j+1)*0.13+0.04 blue:(j+3)*0.96+0.1 alpha:.4];
                UIColor *lineEndColor =[UIColor colorWithRed:j*0.88+0.1 green:(j+1)*0.13+0.04 blue:(j+3)*0.96+0.1 alpha:.2];

                [self drawLinearGradient:ctx path:path.CGPath startColor:[lineStartColor CGColor] endColor:[lineEndColor CGColor]];
                
            }
            
        }
        
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)zoomByPoint:(CGPoint)point scale:(CGFloat)scale{
    //如果宽间距 * 当前缩放等级 *本次缩放等级 小于35 或者 大于 150  不允许缩放
    if (self.xPerStepWidth * _scaleLevel * scale < 35 || self.xPerStepWidth * _scaleLevel * scale > 150) {
        return;
    }
    CGFloat dis = 0.0f;
    //最后放大点
    if( _lastScalePoint.x){
        //判断两点是否相同  如果相同不做处理  如果不同 计算距离，并平移
        if (point.x != _lastScalePoint.x) {
            dis = point.x - _lastScalePoint.x;
        }
    }else{
        //计算距离并平移
        dis =point.x - (self.width - MARGIN_LEFT)/2;
    }
    
    if (_xContentScroll - dis >0) {
        _xContentScroll = 0;
    }else{
        _xContentScroll -= dis;
        
    }
    //记录上次放大点
    _lastScalePoint = point;
    //记录本次放大等级
    _curScaleLevel = scale;
    
    [self setNeedsDisplay];
}


-(void)stopZoom{
    //用户停止缩放  当缩放距离小于35 或者 大于150时  禁止缩放
    if (self.xPerStepWidth * _scaleLevel * _curScaleLevel < 35 || self.xPerStepWidth * _scaleLevel * _curScaleLevel > 150) {
        return;
    }
    //缩放等级 = 缩放等级 * 当前缩放等级
    _scaleLevel     = _scaleLevel * _curScaleLevel;
    //当前缩放等级置 1
    _curScaleLevel  = 1;
    [self setNeedsDisplay];

}

-(void)setWidthInterval:(CGFloat)widthInterval{
    self.xPerStepWidth = widthInterval;
    [self setNeedsLayout];
}


- (void)drawLinearGradient:(CGContextRef)context

                      path:(CGPathRef)path

                startColor:(CGColorRef)startColor

                  endColor:(CGColorRef)endColor

{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path);
    
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}

#pragma mark -
#pragma mark touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation       = [[touches anyObject] locationInView:self];
    CGPoint prevouseLocation    = [[touches anyObject] previousLocationInView:self];
    //本次平移和上次平移的距离
    float   xDiffrance          = touchLocation.x-prevouseLocation.x;
    //移动累加
    _xContentScroll            += xDiffrance;
    //当移动大于0时  则修改为0 即起始点
    if (_xContentScroll > 0) {
        _xContentScroll = 0;
    }
    //当向左滑动移动值为负数  移动值大于（总数量-1） * 每点间隔 即 总宽度
    if (-_xContentScroll > (self.xPerStepWidth * (self.totalXCount -1)  )) {
        //设置移动值为 最右值
        _xContentScroll  = -(self.xPerStepWidth * (self.totalXCount-1 ));
    }
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)refreshData:(NSArray *)dataSource{
    self.dataSource  = dataSource;
    _scaleLevel      = 1;
    _curScaleLevel   = 1;
    
    [self refreshConfig];
    [self setNeedsLayout];
}


/**
 *  取两点间直线与Y轴的交点
 *
 *  @param point1 A点
 *  @param point2 B点
 *
 *  @return 与Y轴的交点Y值
 */
-(CGFloat)pointByLineAndYAxixFromPointA:(CGPoint)point1 pointB:(CGPoint)point2  resultX:(CGFloat)resultX{
    //A点X坐标
    CGFloat pax = point1.x;
    //B点X坐标
    CGFloat pbx = point2.x;
    //A点y坐标
    CGFloat pay = point1.y;
    //B点y坐标
    CGFloat pby = point2.y;
    
    //计算两点间直线和Y轴的交点的Y值
    CGFloat resultY = (resultX - pbx) / (pax - pbx) * (pay - pby) +pby;
    return  resultY;

}


@end
