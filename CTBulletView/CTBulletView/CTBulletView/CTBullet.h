//
//  CTBullet.h
//  CTBulletView
//
//  Created by Admin on 2017/1/3.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BulletStatus)
{
    start, // 开始
    enter, // 完全进入
    end,   // 结束
};

@interface CTBullet : UILabel

@property (nonatomic, assign) NSInteger  channel;

@property (nonatomic, assign) CGFloat    padding;

@property (nonatomic, assign) CGFloat    duration;

@property (nonatomic, copy) void (^enterBlock)(CTBullet * bullet, BulletStatus status);

- (instancetype)initWithContent:(NSString *)content;

- (void)readyToFire;

@end
