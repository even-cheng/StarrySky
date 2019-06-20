//
//  StarView.h
//  canvas-animation
//
//  Created by even-cheng on 2019/5/30.
//  Copyright © 2019 even-cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarView : UIImageView <UIDynamicItem>

@property (nonatomic, weak) UIDynamicItemBehavior* dynamicBehavior;
@property (nonatomic, weak) UICollisionBehavior* collisionBehavior;
@property (nonatomic, weak) UIAttachmentBehavior* attachBehavior;
@property (nonatomic, weak) UIPushBehavior *pushBehavior;

@property (nonatomic, strong) NSArray<StarView*> *connectStars;

@end

NS_ASSUME_NONNULL_END
