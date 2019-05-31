//
//  ContentView.m
//  canvas-animation
//
//  Created by 快游 on 2019/5/30.
//  Copyright © 2019 zhengcong. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

-(void)drawRect:(CGRect)rect{
    
    for (NSArray* group in self.groups) {
        
        UIView* firstView = group.firstObject;
        for (UIView* view in group) {
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            //起点
            [path moveToPoint:firstView.center];
            
            //终点
            [path addLineToPoint:view.center];
            
            path.lineWidth = 0.5;
            
            // 设置画笔颜色
            UIColor *strokeColor = [UIColor whiteColor];
            [strokeColor set];
            
            [path strokeWithBlendMode:kCGBlendModeHardLight alpha:0.1];
        }
    }
}

@end
