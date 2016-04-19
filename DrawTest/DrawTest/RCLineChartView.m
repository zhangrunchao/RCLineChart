//
//  RCChartView.m
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error "This source file must be compiled with ARC enabled!"
#endif

#import "RCLineChartView.h"
#import "RCLineChartContentView.h"
#import "RCLineChartCommon.h"

#define MARGIN_TOP 30
#define MARGIN_BOTTOM 20

@interface RCLineChartView ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *xTitleLabel;
@property(nonatomic,strong) UILabel *yTitleLabel;
@property(nonatomic,strong) RCLineChartContentView *contentView;
@property(nonatomic)        CGFloat lastScale;
@end

@implementation RCLineChartView

-(id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource title:(NSString *)title xTitle:(NSString*)xTitle yTitle:(NSString*)yTitle xCount:(NSInteger)xCount yCount:(NSInteger)yCount isNeedGrid:(BOOL)needGrid{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lastScale = 1;
        
        if (title) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, MARGIN_TOP)];
            _titleLabel.text = title;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = [UIColor blackColor];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:_titleLabel];
            
        }
        
        if(xTitle){
            _xTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-MARGIN_BOTTOM, frame.size.width, MARGIN_BOTTOM)];
            _xTitleLabel.text = xTitle;
            _xTitleLabel.textAlignment = NSTextAlignmentCenter;
            _xTitleLabel.textColor = [UIColor blackColor];
            _xTitleLabel.font = [UIFont systemFontOfSize:9];
            [self addSubview:_xTitleLabel];
        }
        
        _contentView = [[RCLineChartContentView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, frame.size.width, frame.size.height-MARGIN_TOP-MARGIN_BOTTOM) dataSource:dataSource xCount:xCount yCount:yCount isNeedGrid:needGrid];
        [_contentView setNeedsDisplay];
        _contentView.layer.masksToBounds = YES;
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_contentView addGestureRecognizer:pinchGesture];
        [self addSubview:_contentView];
        
        
    }
    return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setWidthInterval:(CGFloat)widthInterval{
    
    [_contentView setWidthInterval:widthInterval];
    
}


-(void)refreshData:(NSArray *)dataSource{
    
    [_contentView refreshData:dataSource];
    
}

#pragma mark 缩放执行的方法
-(void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch
{


    if([(UIPinchGestureRecognizer*)pinch state] == UIGestureRecognizerStateEnded)
    {
        //缩放结束  设置当前缩放为1
        _lastScale = 1;
        //设置contentView的缩放等级
        [self.contentView stopZoom];
        
        return;
    }
    

    if([(UIPinchGestureRecognizer*)pinch state] == UIGestureRecognizerStateChanged)
    {
        if ([pinch numberOfTouches] >= 2) {
            //两个手指缩放  获取两个点，计算中心
            CGPoint c = [pinch locationOfTouch:0 inView:_contentView];
            CGPoint d = [pinch locationOfTouch:1 inView:_contentView];
            //得到中心点
            CGPoint center = [RCLineChartCommon centerPointByPointA:c pointB:d];
            //放大等级超过0.2通知contentView更新
            if ([pinch scale] - _lastScale > 0.2 ||  [pinch scale] - _lastScale < 0.2) {
                [self.contentView zoomByPoint:center scale:[pinch scale]];
                _lastScale = [pinch scale];
            }


        }

        return;
    }
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}
@end
