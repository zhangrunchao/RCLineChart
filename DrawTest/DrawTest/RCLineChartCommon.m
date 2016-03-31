//
//  RCLineChartCommon.m
//  DrawTest
//
//  Created by ZRC on 16/3/28.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "RCLineChartCommon.h"

@implementation RCLineChartCommon
+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Pointcolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Pointcolorspace1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, point.x,point.y);
    CGContextAddArc(context, point.x, point.y, 2, 0, 360, 0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGColorSpaceRelease(Pointcolorspace1);
}
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment
{
    //    UIFont *font = [UIFont systemFontOfSize: fontSize];
    [color set];
    CGSize title1Size = [text sizeWithFont:font];
    CGRect titleRect1 = CGRectMake(point.x,
                                   point.y,
                                   title1Size.width,
                                   title1Size.height);
    [text drawInRect:titleRect1 withFont:font lineBreakMode:NSLineBreakByClipping alignment:textAlignment];
    
}

+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont systemFontOfSize: fontSize];
    //    CGContextSelectFont(context, "Helvetica", 24.0, kCGEncodingMacRoman);
    CGContextSelectFont(context, font.fontName.UTF8String, fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    //    CGContextSetRGBFillColor(context, 0, 255, 255, 1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGAffineTransform xform = CGAffineTransformMake(
                                                    1.0,  0.0,
                                                    0.0, -1.0,
                                                    0.0,  0.0);
    CGContextSetTextMatrix(context, xform);
    const char* ctext = text.UTF8String;
    CGContextShowTextAtPoint(context, 10, 100, ctext, strlen(ctext));
}

+(CGPoint)centerPointByPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    
    CGPoint center = CGPointMake((pointA.x+pointB.x)/2,( pointA.y + pointB.y)/2);
    
    return center;
}



@end
