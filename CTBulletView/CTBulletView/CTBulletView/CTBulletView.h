//
//  VJBulletView.h
//  CTBulletView
//
//  Created by Admin on 2017/1/3.
//  Copyright © 2017年 Arvin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CTBulletView : UIView

// 通道数量
@property (nonatomic, assign)CGFloat channelCount;

@property (nonatomic, assign)CGFloat bulletPadding;

- (void)addBulletFromArray:(NSArray *)bulletAry;

- (void)addBullet:(NSString *)bullet;

- (void)start;

- (void)stop;

- (void)reloadDataAndStart;

@end
