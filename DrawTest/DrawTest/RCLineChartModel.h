//
//  RCLineChartModel.h
//  DrawTest
//
//  Created by 张润潮 on 16/3/22.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCLineChartModel : NSObject
@property(nonatomic,retain) NSString  *valueX;
@property(nonatomic,retain) NSArray  *valuesY;


-(id)initWithX:(NSString*)valueX Y:(NSArray*)valuesY;


@end
