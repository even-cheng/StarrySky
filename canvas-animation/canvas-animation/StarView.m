//
//  StarView.m
//  canvas-animation
//
//  Created by even-cheng on 2019/5/30.
//  Copyright © 2019 even-cheng. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"snowflake1"];
        self.alpha = 0.5;
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

@end
