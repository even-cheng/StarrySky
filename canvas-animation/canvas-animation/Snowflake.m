//
//  SnowflakeView.m
//  canvas-animation
//
//  Created by 快游 on 2020/7/31.
//  Copyright © 2020 even_cheng. All rights reserved.
//

#import "Snowflake.h"

@implementation Snowflake

- (instancetype)init{
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
    emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"snow"].CGImage);
    emitterCell.birthRate = 3;  //每秒创建3个雪花
    emitterCell.lifetime = 12.0;  //在屏幕上保持12秒
    emitterCell.lifetimeRange = 3.0; //2.5-5
    
    emitterCell.yAcceleration = 0.01;
    emitterCell.xAcceleration = 0.01;
    emitterCell.velocity = 30;
    emitterCell.emissionLongitude = (CGFloat)M_PI_2;
    emitterCell.velocityRange = 20.0; //带有负初始速度的粒子根本不会飞起来，而是浮起来
    emitterCell.emissionRange = (CGFloat)M_PI_2;
    emitterCell.color = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    
    emitterCell.redRange = 0.5;
    emitterCell.greenRange = 0.5;
    emitterCell.blueRange = 0.5;
    
    emitterCell.scale = 0.8;
    emitterCell.scaleRange = 0.8;
    emitterCell.scaleSpeed = -0.15;
    
    emitterCell.spin = 0.5;
    emitterCell.spinRange = 0.5;
    
    emitterCell.alphaRange = 0.75; // 0.25-1.0
    emitterCell.alphaSpeed = -0.15; //逐渐消逝
    
    //发射体的形状通常会影响到新粒子的产生，但也会影响到它们的z位置，在你创造3d粒子系统的情况下。
    self.emitterShape = kCAEmitterLayerCircle;
    //添加颗粒模板到发射器
    self.emitterCells = @[emitterCell];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.emitterSize = CGSizeMake(frame.size.width, frame.size.height);
    self.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
}


@end
