//
//  ContentView.m
//  canvas-animation
//
//  Created by even-cheng on 2019/5/30.
//  Copyright © 2019 even-cheng. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

-(void)drawRect:(CGRect)rect{
    
    for (NSArray* group in self.groups) {
        if (group.count < 2) {
            continue;
        }
        UIView* firstView = group.firstObject;
        for (int i = 0; i < MIN(group.count,20); i ++) {
            
            UIView* view = group[i];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            //起点
            [path moveToPoint:firstView.center];
            
            //终点
            [path addLineToPoint:view.center];
            
            path.lineWidth = 0.5;
            
            // 设置画笔颜色
            UIColor *strokeColor = [UIColor whiteColor];
            [strokeColor set];
            
            [path strokeWithBlendMode:kCGBlendModeHardLight alpha:0.15];
        }
    }
}

@end
