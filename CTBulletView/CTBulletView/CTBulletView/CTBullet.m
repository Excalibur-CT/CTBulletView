//
//  CTBullet.m
//  CTBulletView
//
//  Created by Admin on 2017/1/3.
//  Copyright © 2017年 Arvin. All rights reserved.
//


#import "CTBullet.h"

static CGFloat animationDuration = 5;

@interface CTBullet ()

@end

@implementation CTBullet

- (instancetype)initWithContent:(NSString *)content
{
    if (self == [super init])
    {
        self.text = content;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)readyToFire
{
    if (self.enterBlock) {
        self.enterBlock(self, start);
    }
    CGFloat duration = (self.duration == 0)?animationDuration:self.duration;
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat speed = (CGRectGetWidth(self.frame) + CGRectGetMaxX(self.frame))/duration;
    CGFloat enterDur = (CGRectGetWidth(self.frame) + self.padding*2)/speed;
    //弹幕完全离开屏幕
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.enterBlock) {
            self.enterBlock(self, end);
        }
        [self clearToReady];
        [self removeFromSuperview];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.enterBlock) {
            self.enterBlock(self, enter);
        }
    });
}

- (void)clearToReady
{
    self.enterBlock = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
