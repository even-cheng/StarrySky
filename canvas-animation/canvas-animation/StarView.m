//
//  StarView.m
//  canvas-animation
//
//  Created by even-cheng on 2019/5/30.
//  Copyright © 2019 even-cheng. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        if (arc4random_uniform(2) == 1) {
            [self addOpacityAcimation];
        }
        if (arc4random_uniform(5) == 1) {
            [self addScaleAcimation];
        }
    }
    return self;
}


- (void)addOpacityAcimation{

    CAKeyframeAnimation *opacityAnimate = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimate.duration = arc4random_uniform(10)+1;
    opacityAnimate.values = @[@0.1,@0.3,@0.2,@0.0,@0.2,@0.3,@0.5,@0.8,@1.0,@0.7,@0.5];
    opacityAnimate.repeatCount = MAXFLOAT;

    [self.layer addAnimation:opacityAnimate forKey:nil];
}


- (void)addScaleAcimation{

    //关键帧动画 改变大小
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.values = @[@0.2,@0.5,@1.0,@2.0,@1.8,@1.5,@1.2,@1.0];
    anim.duration = arc4random_uniform(15)+1;
    anim.repeatCount = MAXFLOAT;
    [self.layer addAnimation:anim forKey:nil];
}

- (void)drawRect:(CGRect)rect {
    [self draw];
}

- (void)draw {
    
    // 创建色彩空间对象
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    // 创建起点和终点颜色分量的数组
    CGFloat colors[] =
    {
        255, 255, 255, 1.00,//start color(r,g,b,alpha)
        255, 255, 255, 0.00,//end color
    };
    
    //形成梯形，渐变的效果
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
        
    // 起点颜色起始圆心
    CGPoint start = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    // 终点颜色起始圆心
    CGPoint end = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    // 起点颜色圆形半径
    CGFloat startRadius = 0.0f;
    // 终点颜色圆形半径
    CGFloat endRadius = self.frame.size.width/2;
    // 获取上下文
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    // 创建一个径向渐变
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);
 
    //releas
    CGGradientRelease(gradient);
    gradient=NULL;
    CGColorSpaceRelease(rgb);
}

@end


