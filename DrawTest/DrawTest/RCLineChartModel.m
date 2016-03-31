//
//  RCLineChartModel.m
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "RCLineChartModel.h"

@implementation RCLineChartModel

-(id)initWithX:(NSString*)valueX Y:(NSArray*)valuesY{
    
    self = [super init];
    
    if (self) {
        
        _valueX    = valueX;
        _valuesY   = valuesY;
        
    }
    return self;
}


@end
