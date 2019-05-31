//
//  ViewController.m
//  canvas-animation
//
//  Created by 快游 on 2019/5/30.
//  Copyright © 2019 zhengcong. All rights reserved.
//

#import "ViewController.h"
#import "StarView.h"
#import "ContentView.h"

#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, weak) ContentView *bgView;
@property(nonatomic,strong)UIDynamicAnimator * animator;
@property(nonatomic,strong)NSMutableArray * stars;
@property(nonatomic,strong)CAEmitterLayer * emitterLayer;

@end

@implementation ViewController

//懒加载
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.bgView];
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置星空背景
    UIImageView* bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg3"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.layer.frame = self.view.bounds;
    [self.view addSubview:bgImage];
 
    //添加画板View
    ContentView* bgView = [[ContentView alloc]initWithFrame:self.view.bounds];
    [bgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
    _bgView = bgView;
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    //雪花效果
    [self snowflake];
    
    //星空效果
    self.stars = [NSMutableArray array];
    [self buildStars];
    
    //实时更新位置并重绘画板
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self observerStarsLocation];
    });
    
    //添加流星效果
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self addMoveStars];
    }];
}

//手势滑动添加吸附效果
- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint currentPosition = [panGesture locationInView:self.bgView];
    CGRect coverRect = CGRectMake(currentPosition.x-50, currentPosition.y-50, 100, 100);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
   
        for (StarView* aroundView in self.stars) {
            
            UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:aroundView attachedToAnchor:currentPosition];
            if (CGRectContainsPoint(coverRect, aroundView.center)) {
                [self.animator addBehavior:attach];
                aroundView.attachBehavior = attach;
            }
        }

    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        for (StarView* view in self.stars) {
            view.attachBehavior.anchorPoint = currentPosition;
        }
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        for (StarView* view in self.stars) {
            [self.animator removeBehavior:view.attachBehavior];
            [self.animator removeBehavior:view.collisionBehavior];
            [self.animator removeBehavior:view.dynamicBehavior];
            [self addAnimtionWithView:view];
        }
    }
}

//随机创建星空
- (void)buildStars{
    
    CGFloat maxX = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxY = [UIScreen mainScreen].bounds.size.height-200;
    
    for (int i = 0; i < 100; i ++) {
        
        CGPoint randomPoint = CGPointMake(arc4random_uniform(maxX), arc4random_uniform(maxY));
        StarView* starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        starView.center = randomPoint;
        [self.stars addObject:starView];
        [self.bgView addSubview:starView];
        
        [self addAnimtionWithView:starView];
    }
}

//添加基础行为
- (void)addAnimtionWithView:(StarView *)view{
    
    NSArray* directions = @[@-0.9, @0.9, @-0.8, @0.8, @-0.7, @0.7, @-0.6, @0.6, @-0.5, @0.5, @-0.4, @0.4, @-0.3, @0.3, @-0.2, @0.2, @-0.1, @0.1];
    int speed = arc4random_uniform(5)+10;

    //添加碰撞行为
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[view]];
    collisionBehavior.collisionDelegate = self;
    collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    
    //设置碰撞边缘
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200)];
    CAShapeLayer * shapeLayer =[CAShapeLayer layer];
    shapeLayer.path =path.CGPath;
    shapeLayer.strokeColor =[UIColor clearColor].CGColor;//画笔颜色
    shapeLayer.lineWidth = 1;
    shapeLayer.fillColor = nil;//填充颜色
    [self.bgView.layer addSublayer:shapeLayer];
    [collisionBehavior addBoundaryWithIdentifier:@"circle" forPath:path];
    view.collisionBehavior = collisionBehavior;
    
    //设置初始动力
    UIDynamicItemBehavior* dynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[view]];
    dynamicBehavior.elasticity = 1;
    dynamicBehavior.friction = 0;
    dynamicBehavior.resistance = 0;
    dynamicBehavior.allowsRotation = NO;
    dynamicBehavior.density = 100;
    [dynamicBehavior addLinearVelocity:CGPointMake([directions[arc4random_uniform(18)] floatValue]*speed, [directions[arc4random_uniform(18)] floatValue]*speed) forItem:view];
    view.dynamicBehavior = dynamicBehavior;
   
    
    [self.animator addBehavior:dynamicBehavior];
    [self.animator addBehavior:collisionBehavior];
}

//星星触碰到边缘
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p;{

    StarView* starView = (StarView*)item;
    [self.animator removeBehavior:starView.dynamicBehavior];
    [self.animator removeBehavior:starView.collisionBehavior];

    [self addAnimtionWithView:starView];
}

//实时重绘
- (void)observerStarsLocation{
    
    while (1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray* groups = [NSMutableArray array];
            for (StarView* view in self.stars) {
                
                CGRect viewCenter = CGRectMake(view.center.x+1, view.center.y+1, 1, 1);
                CGRect coverRect = CGRectMake(viewCenter.origin.x-50, viewCenter.origin.y-50, 100, 100);
                
                BOOL containOther = NO;
                NSMutableArray* group = [NSMutableArray array];
                for (StarView* aroundView in self.stars) {
                    
                    if (aroundView != view && CGRectContainsPoint(coverRect, aroundView.center)) {
                        containOther = YES;
                        
                        [group addObject:view];
                        [group addObject:aroundView];
                    }
                }
                if (containOther) {
                    [groups addObject:group];
                }
            }
            
            self.bgView.groups = groups;
            [self.bgView setNeedsDisplay];
        });
        
        usleep(30000);
    }
}


//雪花效果
-(void)snowflake{
        
    //设置layer的frame
    CAEmitterLayer *emitter = [CAEmitterLayer new];
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50);
    emitter.frame = frame;
    [self.view.layer addSublayer:emitter];
    
    //发射体的形状通常会影响到新粒子的产生，但也会影响到它们的z位置，在你创造3d粒子系统的情况下。
    emitter.emitterShape = kCAEmitterLayerRectangle;
  
    emitter.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
    emitter.emitterSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-50);
    
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
    emitterCell.contents = (__bridge id)[UIImage imageNamed:@"snowflake1"].CGImage;
    emitterCell.birthRate = 3;  //每秒创建20个雪花
    emitterCell.lifetime = 12.0;  //在屏幕上保持3.5秒
    emitterCell.lifetimeRange = 3.0; //2.5-5
    //添加颗粒模板到发射器
    emitter.emitterCells = @[emitterCell];
    
    emitterCell.yAcceleration = 0.001;
    emitterCell.xAcceleration = 0.001;
    emitterCell.velocity = 0.01;
    emitterCell.emissionLongitude = (CGFloat)-M_PI;
    emitterCell.velocityRange = 20.0; //带有负初始速度的粒子根本不会飞起来，而是浮起来
    emitterCell.emissionRange = -(CGFloat)M_PI_2;
    emitterCell.color = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
  
    emitterCell.redRange = 0.5;
    emitterCell.greenRange = 0.5;
    emitterCell.blueRange = 0.5;
    
    emitterCell.scale = 0.8;
    emitterCell.scaleRange = 0.8;
    emitterCell.scaleSpeed = -0.15;
    
    emitterCell.alphaRange = 0.75; // 0.25-1.0
    emitterCell.alphaSpeed = -0.15; //逐渐消逝
}

//流星效果
- (void)addMoveStars{
    
    UIView* moveStar = [[UIView alloc]initWithFrame:CGRectMake(-100, arc4random_uniform(self.view.bounds.size.height*0.8), 40, 2)];
    moveStar.transform = CGAffineTransformRotate(moveStar.transform, M_PI_4*0.5);
    moveStar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.bgView addSubview:moveStar];
    
    //自由落体行为
    UIGravityBehavior * gravity = [[UIGravityBehavior alloc]initWithItems:@[moveStar]];
    //重力行为有一个属性是重力加速度，设置越大速度增长越快。默认是1
    gravity.magnitude = 0.01;
    gravity.gravityDirection = CGVectorMake(0.2, 0.1);
    //添加到容器
    [self.animator addBehavior:gravity];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [moveStar removeFromSuperview];
    });
}

@end
