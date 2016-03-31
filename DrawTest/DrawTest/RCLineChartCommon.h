//
//  RCLineChartCommon.h
//  DrawTest
//
//  Created by ZRC on 16/3/28.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCLineChartCommon : NSObject
+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor;
+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;
+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize;

+(CGPoint)centerPointByPointA:(CGPoint)pointA pointB:(CGPoint)pointB;
@end
