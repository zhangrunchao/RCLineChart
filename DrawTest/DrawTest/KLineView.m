//
//  KLineView.m
//  DrawTest
//
//  Created by ZRC on 16/3/31.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "KLineView.h"
#import "KLine.h"
#import "NSString+HexColors.h"
#import "UIView+SetRect.h"
@interface KLineView (){
//    NSThread *thread;       //线程  用于生成数据
    UIView *mainboxView; // k线图控件
    UIView *bottomView; // 成交量
    UIView *tapLineA;   //按下后的第一条线
    UIView *tapLineB;   //按下后的第二条线
    UILabel *tapLineALabel;     //按下后标签
    UILabel *tapLineBLabel;     //按下后标签
    NSMutableArray *pointArray;     //坐标数组
    CGFloat maDays;     //均价天数
    UILabel *ma5Label;   //5均线
    UILabel *ma10Label;  //10均线
    UILabel *ma20Label;  //20均线
    UILabel *startDateLabel;    //开始日期
    UILabel *endDateLabel;      //结束日期
    UILabel *volMaxLabel;       //成交量最大值
    BOOL isUpdate;
    BOOL isUpdateFinish;
    NSMutableArray *linesArray;
    NSMutableArray *linesOldArray;
    UIPinchGestureRecognizer *pinchGesture;
    CGPoint touchViewPoint;
    BOOL isPinch;


}

@end

@implementation KLineView
-(id)initWithFrame:(CGRect)frame dataModel:(KDataModel*)model{
    self = [super initWithFrame:frame];
    self.dataModel = model;
    [self config];
    return self;
}

-(void)config{
    self.xWidth = self.frame.size.width- 50; // k线图宽度
    self.yHeight = self.frame.size.height/4*3-20; // k线图高度
    self.bottomHeight = self.frame.size.height/4; // 底部成交量图的高度
    self.kLineWidth = 5;// k线实体的宽度
    self.kLinePadding = 1; // k实体的间隔
    self.endDate = [NSDate date];
    self.rows = 6;
    self.font = [UIFont systemFontOfSize:8];
    maDays = 20;
    isUpdate = NO;
    isUpdateFinish = YES;
    isPinch = NO;
    linesArray = [[NSMutableArray alloc] init];
    linesOldArray = [[NSMutableArray alloc] init];
    
    self.finishUpdateBlock = ^(id self){
        [self updateView];
    };
}

/**
 *  开始画图
 */
-(void)start{
    [self drawBox];
    
    [self drawLine];
//    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
//    [thread start];
}
/**
 *  更新图表
 */
-(void)update{
    if (self.kLineWidth>20)
        self.kLineWidth = 20;
    if (self.kLineWidth<1)
        self.kLineWidth = 1;
    isUpdate = YES;
//    if (!thread.isCancelled) {
//        [thread cancel];
//    }
    self.clearsContextBeforeDrawing = YES;

    [self drawLine];
    
//    [thread cancel];
//    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
//    [thread start];
    
}

-(void)refreshData:(KDataModel*)datas{
    self.dataModel = datas;
    [self update];
}


//更新图表
-(void)updateSelf{
    if (isUpdateFinish) {
        if (self.kLineWidth>20)
            self.kLineWidth = 20;
        if (self.kLineWidth<1)
            self.kLineWidth = 1;
        isUpdateFinish = NO;
        isUpdate = YES;
        pointArray = nil;
//        if (!thread.isCancelled) {
//            [thread cancel];
//        }
        self.clearsContextBeforeDrawing = YES;
        [self drawLine];
//        [thread cancel];
//        thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
//        [thread start];
        
    }
}
/**
 *  画边框和均线
 */
-(void)drawBox{
    // 画个k线图的框框
    if (mainboxView==nil) {
        mainboxView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-self.xWidth, 20, self.xWidth, self.yHeight)];
        mainboxView.backgroundColor = [@"222222" hexColor];
        mainboxView.layer.borderColor = [[@"#444444" hexColor] CGColor];
        mainboxView.layer.borderWidth = 0.5;
        mainboxView.userInteractionEnabled = YES;
        [self addSubview:mainboxView];
        // 添加手指捏合手势，放大或缩小k线图
        pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(touchBoxAction:)];
        [mainboxView addGestureRecognizer:pinchGesture];
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
        [longPressGestureRecognizer setMinimumPressDuration:0.3f];
        [longPressGestureRecognizer setAllowableMovement:50.0];
        [mainboxView addGestureRecognizer:longPressGestureRecognizer];
    }
    
    
    // 画个成交量的框框
    if (bottomView==nil) {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mainboxView.frame.size.height+20, self.xWidth, self.bottomHeight)];
        bottomView.backgroundColor = [@"222222" hexColor];
        bottomView.layer.borderColor = [[@"#444444" hexColor] CGColor];
        bottomView.layer.borderWidth = 0.5;
        bottomView.userInteractionEnabled = YES;
        [mainboxView addSubview:bottomView];
    }
    
    
    // 把显示开始结束日期放在成交量的底部左右两侧
    // 显示开始日期控件
    if (startDateLabel == nil) {
        startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y+bottomView.frame.size.height, 50, 15)];
        startDateLabel.font = self.font;
        startDateLabel.text = @"--";
        startDateLabel.textColor = [@"aaaaaa" hexColor];
        startDateLabel.backgroundColor = [UIColor clearColor];
        [mainboxView addSubview:startDateLabel];
    }
    
    // 显示结束日期控件
    if (endDateLabel == nil) {
        endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainboxView.frame.size.width-50, startDateLabel.frame.origin.y, startDateLabel.width, startDateLabel.height)];
        endDateLabel.font = self.font;
        endDateLabel.text = @"--";
        endDateLabel.textColor = [@"aaaaaa" hexColor];
        endDateLabel.backgroundColor = [UIColor clearColor];
        endDateLabel.textAlignment = NSTextAlignmentRight;
        [mainboxView addSubview:endDateLabel];
    }
    
    
    // 显示成交量最大值
    if (volMaxLabel==nil) {
        volMaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, mainboxView.frame.size.height + mainboxView.frame.origin.x, self.frame.size.width - mainboxView.frame.size.width - 2, self.font.lineHeight)];
        volMaxLabel.font = self.font;
        volMaxLabel.text = @"--";
        volMaxLabel.textColor = [@"aaaaaa" hexColor];
        volMaxLabel.backgroundColor = [UIColor clearColor];
        volMaxLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:volMaxLabel];
    }
    
    
    // 添加平均线值显示
    CGRect mainFrame = mainboxView.frame;
    
    // MA5 均线价格显示控件
    if (ma5Label == nil) {
        ma5Label = [[UILabel alloc] initWithFrame:CGRectMake(mainFrame.origin.x, 0, 40, 20)];
        ma5Label.backgroundColor = [UIColor clearColor];
        ma5Label.font = self.font;
        ma5Label.text = @"MA5:--";
        ma5Label.textColor = [UIColor whiteColor];
        [ma5Label sizeToFit];
        [self addSubview:ma5Label];
    }
    
    
    // MA10 均线价格显示控件
    if (ma10Label == nil) {
        ma10Label = [[UILabel alloc] initWithFrame:CGRectMake(ma5Label.right +10, 0, ma5Label.width, ma5Label.height)];
        ma10Label.backgroundColor = [UIColor clearColor];
        ma10Label.font = self.font;
        ma10Label.text = @"MA10:--";
        ma10Label.textColor = [@"#FF9900" hexColor];
        [ma10Label sizeToFit];
        [self addSubview:ma10Label];
    }
    
    
    // MA20 均线价格显示控件
    if (ma20Label == nil) {
        ma20Label = [[UILabel alloc] initWithFrame:CGRectMake(ma10Label.right +10 +10, 0, ma10Label.width, ma10Label.height)];
        ma20Label.backgroundColor = [UIColor clearColor];
        ma20Label.font = self.font;
        ma20Label.text = @"MA20:--";
        ma20Label.textColor =[@"#FF00FF" hexColor];
        [ma20Label sizeToFit];
        [self addSubview:ma20Label];
    }
    
    if (!isUpdate) {
        // 分割线
        CGFloat padRealValue = mainboxView.frame.size.height / 6;
        for (int i = 0; i<7; i++) {
            CGFloat y = mainboxView.frame.size.height-padRealValue * i;
            KLine *line = [[KLine alloc] initWithFrame:CGRectMake(0, 0, mainboxView.frame.size.width, mainboxView.frame.size.height)];
            line.lineColor = @"#333333";
            line.startPoint = CGPointMake(0, y);
            line.endPoint = CGPointMake(mainboxView.frame.size.width, y);
            [mainboxView addSubview:line];
        }
    }
    
}


/**
 *  画K线
 */
-(void)drawLine{
    self.dataModel.kCount = self.xWidth / (self.kLineWidth+self.kLinePadding) + 1; // K线中实体的总数
    NSLog(@"当前：%ld",self.dataModel.dataArray.count);
    // 开始画K线图
    [self drawKline];
    
    NSLog(@"处理得dddd");
    // 清除旧的k线
    if (linesOldArray.count>0 && isUpdate) {
        for (KLine *line in linesOldArray) {
            [line removeFromSuperview];
        }
    }
    linesOldArray = linesArray.copy;
    
    if (_finishUpdateBlock && isPinch) {
        _finishUpdateBlock(self);
    }
    isUpdateFinish = YES;
    // 结束线程
//    [thread cancel];
}

/**
 *  设置当前最大最小值
 */
-(void)setupMaxAndMinValue{
    CGFloat padValue = (self.dataModel.maxValue - self.dataModel.minValue) / _rows;
    if (self.dataModel.maxValue<=0) {
        self.dataModel.maxValue += padValue;
        self.dataModel.minValue -= padValue;
    }

}


/**
 *  画K线
 */
-(void)drawKline{
    
    [self setupMaxAndMinValue];
    // 平均线
    CGFloat padValue = (self.dataModel.maxValue - self.dataModel.minValue) / _rows;
    //行高
    CGFloat padRealValue = mainboxView.height / _rows;
    for (int i = 0; i < (_rows + 1); i++) {
        CGFloat y = mainboxView.height-padRealValue * i;
        // lable
        UILabel *leftTag = [[UILabel alloc] initWithFrame:CGRectMake(-40, y-30/2, 38, 30)];
        leftTag.text = [[NSString alloc] initWithFormat:@"%.2f",padValue * i +self.dataModel.minValue];
        leftTag.textColor = [@"cccccc" hexColor];
        leftTag.font = self.font;
        leftTag.textAlignment = NSTextAlignmentCenter;
        leftTag.backgroundColor = [UIColor clearColor];
        //[leftTag sizeToFit];
        [mainboxView addSubview:leftTag];
        [linesArray addObject:leftTag];
    }
    
    // 开始画连接线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    // MA5
    [self drawMAWithIndex:MA5 andColor:@"#FFFFFF"];
    // MA10
    [self drawMAWithIndex:MA10 andColor:@"#FF99OO"];
    // MA20
    [self drawMAWithIndex:MA20 andColor:@"#FF00FF"];
    
    // 开始画连K线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    NSArray *ktempArray = [self changeKPointWithData:self.dataModel.dataArray]; // 换算成实际每天收盘价坐标数组
    KLine *kline = [[KLine alloc] initWithFrame:CGRectMake(0, 0, mainboxView.width, mainboxView.height)];
    kline.points = ktempArray;
    kline.lineWidth = self.kLineWidth;
    kline.isKLine = YES;
    [mainboxView addSubview:kline];
    [linesArray addObject:kline];
    
    // 开始画连成交量
    NSArray *voltempArray = [self changeVolumePointWithData:self.dataModel.dataArray]; // 换算成实际成交量坐标数组
    KLine *volline = [[KLine alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, bottomView.height)];
    volline.points = voltempArray;
    volline.lineWidth = self.kLineWidth;
    volline.isKLine = YES;
    volline.isVol = YES;
    [bottomView addSubview:volline];
    volMaxLabel.text = [self changePriceUnitWithPrice:self.dataModel.volMaxValue];
    [linesArray addObject:volline];
    
    
    
}

/**
 *  画均线
 *
 *  @param index 均线类型
 *  @param color 颜色
 */
-(void)drawMAWithIndex:(MAType)index andColor:(NSString*)color{
    NSArray *tempArray = [self changePointWithData:self.dataModel.dataArray andMA:index]; // 换算成实际坐标数组
    KLine *line = [[KLine alloc] initWithFrame:CGRectMake(0, 0, mainboxView.width, mainboxView.height)];
    line.lineColor = color;
    line.points = tempArray;
    line.isKLine = NO;
    [mainboxView addSubview:line];
    [linesArray addObject:line];
}


#pragma mark 手指捏合动作
-(void)touchBoxAction:(UIPinchGestureRecognizer*)pGesture{
    isPinch  = NO;
    NSLog(@"状态：%ld==%f",pinchGesture.state,pGesture.scale);
    if (pGesture.state == UIGestureRecognizerStateChanged && isUpdateFinish) {
        if (pGesture.scale>1) {
            // 放大手势
            self.kLineWidth ++;
//            [self updateSelf];
        }else{
            // 缩小手势
            self.kLineWidth --;
//            [self updateSelf];
        }
    }
    if (pGesture.state == UIGestureRecognizerStateEnded) {
        isUpdateFinish = YES;
    }
}

#pragma mark 长按就开始生成十字线
-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer*)longResture{
    isPinch = YES;
    NSLog(@"gestureRecognizerHandle%ld",longResture.state);
    touchViewPoint = [longResture locationInView:mainboxView];
    // 手指长按开始时更新一般
    if(longResture.state == UIGestureRecognizerStateBegan){
        [self update];
    }
    // 手指移动时候开始显示十字线
    if (longResture.state == UIGestureRecognizerStateChanged) {
        [self isKPointWithPoint:touchViewPoint];
    }
    
    // 手指离开的时候移除十字线
    if (longResture.state == UIGestureRecognizerStateEnded) {
        [tapLineA removeFromSuperview];
        [tapLineB removeFromSuperview];
        [tapLineALabel removeFromSuperview];
        [tapLineBLabel removeFromSuperview];
        
        tapLineA = nil;
        tapLineB = nil;
        tapLineALabel = nil;
        tapLineBLabel = nil;
        isPinch = NO;
    }
}


/**
 *  更新界面信息
 */
-(void)updateView{
    NSLog(@"block");
    if (tapLineA==Nil) {
        tapLineA = [[UIView alloc] initWithFrame:CGRectMake(0,0, 0.5,
                                                               bottomView.height+bottomView.y)];
        tapLineA.backgroundColor = [UIColor whiteColor];
        [mainboxView addSubview:tapLineA];
        tapLineA.hidden = YES;
    }
    if (tapLineB==Nil) {
        tapLineB = [[UIView alloc] initWithFrame:CGRectMake(0,0, mainboxView.width,0.5)];
        tapLineB.backgroundColor = [UIColor whiteColor];
        tapLineB.hidden = YES;
        [mainboxView addSubview:tapLineB];
    }
    if (tapLineALabel==Nil) {
        CGRect oneFrame = tapLineA.frame;
        oneFrame.size = CGSizeMake(50, 12);
        tapLineALabel = [[UILabel alloc] initWithFrame:oneFrame];
        tapLineALabel.font = self.font;
        tapLineALabel.layer.cornerRadius = 5;
        tapLineALabel.backgroundColor = [UIColor whiteColor];
        tapLineALabel.textColor = [@"#333333" hexColor];
        tapLineALabel.textAlignment = NSTextAlignmentCenter;
        tapLineALabel.alpha = 0.8;
        tapLineALabel.hidden = YES;
        [mainboxView addSubview:tapLineALabel];
    }
    if (tapLineBLabel==Nil) {
        CGRect oneFrame = tapLineB.frame;
        oneFrame.size = CGSizeMake(50, 12);
        tapLineBLabel = [[UILabel alloc] initWithFrame:oneFrame];
        tapLineBLabel.font = self.font;
        tapLineBLabel.layer.cornerRadius = 5;
        tapLineBLabel.backgroundColor = [UIColor whiteColor];
        tapLineBLabel.textColor = [@"#333333" hexColor];
        tapLineBLabel.textAlignment = NSTextAlignmentCenter;
        tapLineBLabel.alpha = 0.8;
        tapLineBLabel.hidden = YES;
        [mainboxView addSubview:tapLineBLabel];
    }
    
    tapLineA.frame = CGRectMake(touchViewPoint.x,0, 0.5,
                                   bottomView.height+bottomView.y);
    tapLineB.frame = CGRectMake(0,touchViewPoint.y, mainboxView.width,0.5);
    CGRect oneFrame = tapLineA.frame;
    oneFrame.size = CGSizeMake(50, 12);
    tapLineALabel.frame = oneFrame;
    CGRect towFrame = tapLineB.frame;
    towFrame.size = CGSizeMake(50, 12);
    tapLineBLabel.frame = towFrame;
    
    tapLineA.hidden = NO;
    tapLineB.hidden = NO;
    tapLineALabel.hidden = NO;
    tapLineBLabel.hidden = NO;
    [self isKPointWithPoint:touchViewPoint];
}

/**
 *  数据换算成实际的点坐标数组
 *
 *  @param data    数据
 *  @param MAIndex 均线类型
 *
 *  @return 坐标数组
 */
-(NSArray*)changePointWithData:(NSArray*)data andMA:(MAType)MAIndex{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = 0.0f; // 起始点坐标
    for (KModel *item in data) {
        CGFloat currentValue = 0;
        if (MAIndex == MA5) {
            currentValue =[item.ma5 floatValue];// 得到前五天的均价价格
        }else if(MAIndex == MA10){
            currentValue =[item.ma10 floatValue];// 得到前十天的均价价格
        }else if(MAIndex == MA20){
            currentValue =[item.ma20 floatValue];// 得到前十天的均价价格
        }
        
                // 换算成实际的坐标
        CGFloat currentPointY = mainboxView.height - ((currentValue - self.dataModel.minValue) / (self.dataModel.maxValue -self.dataModel.minValue) * mainboxView.height);
        CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
        [tempArray addObject:NSStringFromCGPoint(currentPoint)]; // 把坐标添加进新数组
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
    }
    return tempArray;
}


#pragma mark 把股市数据换算成实际的点坐标数组
-(NSArray*)changeKPointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    pointArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = self.kLineWidth/2; // 起始点坐标
    CGFloat yHeight = self.dataModel.maxValue - self.dataModel.minValue ; // y的价格高度
    CGFloat yViewHeight = mainboxView.height ;// y的实际像素高度
    for (KModel *item in data) {
        CGFloat heightvalue = [item.high floatValue];// 得到最高价
        CGFloat lowvalue = [item.low floatValue];// 得到最低价
        CGFloat openvalue = [item.open floatValue];// 得到开盘价
        CGFloat closevalue = [item.close floatValue];// 得到收盘价
        // 换算成实际的坐标
        CGFloat heightPointY = yViewHeight * (1 - (heightvalue - self.dataModel.minValue) / yHeight);
        CGPoint heightPoint =  CGPointMake(PointStartX, heightPointY); // 最高价换算为实际坐标值
        CGFloat lowPointY = yViewHeight * (1 - (lowvalue - self.dataModel.minValue) / yHeight);;
        CGPoint lowPoint =  CGPointMake(PointStartX, lowPointY); // 最低价换算为实际坐标值
        CGFloat openPointY = yViewHeight * (1 - (openvalue - self.dataModel.minValue) / yHeight);;
        CGPoint openPoint =  CGPointMake(PointStartX, openPointY); // 开盘价换算为实际坐标值
        CGFloat closePointY = yViewHeight * (1 - (closevalue - self.dataModel.minValue) / yHeight);;
        CGPoint closePoint =  CGPointMake(PointStartX, closePointY); // 收盘价换算为实际坐标值
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(heightPoint),
                                 NSStringFromCGPoint(lowPoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 item.date, // 保存日期时间
                                 item.close, // 收盘价
                                 item.ma5, // MA5
                                 item.ma10, // MA10
                                 item.ma20, // MA20
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        currentArray = Nil;
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
        
        // 在成交量视图左右下方显示开始和结束日期
        if ([data indexOfObject:item] == 0) {
            startDateLabel.text = item.date;
        }
        if ([data indexOfObject:item] == data.count-1) {
            endDateLabel.text = item.date;
        }
    }
    pointArray = tempArray;
    return tempArray;
}

/**
 *  市数据换算成成交量的实际坐标数组
 *
 *  @param NSArray 数据
 *
 *  @return 坐标数组
 */
-(NSArray*)changeVolumePointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = self.kLineWidth/2; // 起始点坐标
    CGFloat yHeight = self.dataModel.volMaxValue - self.dataModel.volMinValue ; // y的价格高度
    CGFloat yViewHeight = bottomView.height ;// y的实际像素高度
    for (KModel *item in data) {
        CGFloat volumevalue = [item.salesVolume floatValue];// 得到没份成交量

        // 换算成实际的坐标
        CGFloat volumePointY = yViewHeight * (1 - (volumevalue - self.dataModel.volMinValue) / yHeight);
        CGPoint volumePoint =  CGPointMake(PointStartX, volumePointY); // 成交量换算为实际坐标值
        CGPoint volumePointStart = CGPointMake(PointStartX, yViewHeight);
        // 把开盘价收盘价放进去好计算实体的颜色
        CGFloat openvalue = [item.open floatValue];// 得到开盘价
        CGFloat closevalue = [item.close floatValue];// 得到收盘价
        CGPoint openPoint =  CGPointMake(PointStartX, closevalue); // 开盘价换算为实际坐标值
        CGPoint closePoint =  CGPointMake(PointStartX, openvalue); // 收盘价换算为实际坐标值
        
        
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(volumePointStart),
                                 NSStringFromCGPoint(volumePoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        currentArray = Nil;
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
        
    }
    NSLog(@"处理完成");
    
    return tempArray;
}

#pragma mark 判断并在十字线上显示提示信息
-(void)isKPointWithPoint:(CGPoint)point{
    CGFloat itemPointX = 0;
    for (NSArray *item in pointArray) {
        CGPoint itemPoint = CGPointFromString([item objectAtIndex:3]);  // 收盘价的坐标
        itemPointX = itemPoint.x;
        int itemX = (int)itemPointX;
        int pointX = (int)point.x;
        if (itemX == pointX || point.x - itemX <= self.kLineWidth / 2) {
            tapLineA.frame = CGRectMake(itemPointX,tapLineA.y, tapLineA.width, tapLineA.height);
            tapLineB.frame = CGRectMake(tapLineB.x,itemPoint.y, tapLineB.width, tapLineB.height);
            // 垂直提示日期控件
            tapLineALabel.text = [item objectAtIndex:4]; // 日期
            CGFloat oneLableY = bottomView.height+bottomView.y;
            CGFloat oneLableX = 0;
            if (itemPointX < tapLineALabel.width / 2) {
                oneLableX = tapLineALabel.width / 2 - itemPointX;
            }
            if ((mainboxView.width - itemPointX) < tapLineALabel.width/2) {
                oneLableX = -(tapLineALabel.width/2 - (mainboxView.width - itemPointX));
            }
            tapLineALabel.frame = CGRectMake(itemPointX - tapLineALabel.width/2 + oneLableX, oneLableY,
                                                tapLineALabel.width, tapLineALabel.height);
            // 横向提示价格控件
            tapLineBLabel.text = [[NSString alloc] initWithFormat:@"%@",[item objectAtIndex:5]]; // 收盘价
            CGFloat twoLableX = tapLineBLabel.x;
            // 如果滑动到了左半边则提示向右跳转
            if ((mainboxView.width - itemPointX) > mainboxView.width/2) {
                twoLableX = mainboxView.width - tapLineBLabel.width;
            }else{
                twoLableX = 0;
            }
            tapLineBLabel.frame = CGRectMake(twoLableX,itemPoint.y - tapLineBLabel.height/2 ,tapLineBLabel.width, tapLineBLabel.height);
            if (item.count >= 6) {
                // 均线值显示
                ma5Label.text = [[NSString alloc] initWithFormat:@"MA5:%.2f",[[item objectAtIndex:5] floatValue]];
                [ma5Label sizeToFit];
            }
           
            if (item.count >= 7) {
                // 均线值显示
                ma10Label.text = [[NSString alloc] initWithFormat:@"MA10:%.2f",[[item objectAtIndex:6] floatValue]];
                [ma10Label sizeToFit];
                ma10Label.frame = CGRectMake(ma5Label.x + ma5Label.width + 10, ma10Label.y, ma10Label.width, ma10Label.height);
            }
            if (item.count >= 8) {
                // 均线值显示
                ma20Label.text = [[NSString alloc] initWithFormat:@"MA20:%.2f",[[item objectAtIndex:7] floatValue]];
                [ma20Label sizeToFit];
                ma20Label.frame = CGRectMake(ma10Label.x + ma10Label.width + 10, ma20Label.y, ma20Label.width, ma20Label.height);

            }
            break;
        }
    }
    
}


/**
 *  修改价格单位
 *
 *  @param price 价格
 *
 *  @return 带单位价格
 */
-(NSString*)changePriceUnitWithPrice:(CGFloat)price{
    CGFloat newPrice = 0;
    NSString *unit = @"万";
    if((int)price > 100000000){
        unit = @"亿";
        newPrice = price / 100000000 ;
    }else if((int)price > 10000000){
        unit = @"千万";
        newPrice = price / 10000000 ;
    }else{
        newPrice = price / 10000 ;
    }
    
    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@",newPrice,unit];
    return newstr;
}


@end
