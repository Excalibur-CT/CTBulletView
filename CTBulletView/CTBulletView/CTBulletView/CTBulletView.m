//
//  VJBulletView.m
//  CTBulletView
//
//  Created by Admin on 2017/1/3.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "CTBulletView.h"
#import "CTBullet.h"

#define W(__VIEW__) CGRectGetWidth(__VIEW__.frame)
#define H(__VIEW__) CGRectGetHeight(__VIEW__.frame)

static CGFloat padding = 50;
static CGFloat bullet_Height = 25.0f;

struct Status
{
    BOOL isStop;
    BOOL isFire;
} ;

@interface CTBulletView()

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray * tmpComments;

@property (nonatomic, strong) NSMutableArray * resueQueue;

@property (nonatomic, strong) NSLock * lock;

@property (nonatomic, assign) CGFloat spaceH;

@property (nonatomic, assign) struct Status  status;

@end

@implementation CTBulletView

- (instancetype)init
{
    self = [super init];
    if (self) {
        struct Status stu;
        stu.isStop = YES;
        stu.isFire = NO;
        self.status = stu;
    }
    return self;
}

- (void)start
{
    if (self.tmpComments.count == 0 || _status.isFire)
    {
        return;
    }
    _status.isFire = YES;
    _status.isStop = NO;
    [self initBulletCommentView];
}

- (void)stop
{
    _status.isStop = YES;
    _status.isFire = NO;
}

- (void)reloadDataAndStart
{
    _status.isFire = YES;
    _status.isStop = NO;
    [self initBulletCommentView];
}

#pragma mark - Private
/**
 *  创建弹幕
 *  @param channel    弹道位置
 */
- (void)createBulletWithChannel:(NSInteger)channel
{
    if (_status.isStop)
    {
        [self.resueQueue removeAllObjects];
        return;
    }

    NSString * comment = [self bulletReadyShowText];
    CGFloat pad = self.bulletPadding>0?self.bulletPadding:padding;
    CTBullet * bullet;
    if (self.resueQueue.count != 0)
    {
        [self.lock lock];
        bullet = [self.resueQueue lastObject];
        [self.resueQueue removeLastObject];
        [self.lock unlock];
        bullet.text = comment;
    }
    else
    {
        bullet = [[CTBullet alloc] initWithContent:comment];
    }
    float width = [bullet sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    bullet.padding = pad;
    bullet.channel = channel;
    bullet.frame = CGRectMake(W(self) + pad, channel * self.spaceH, width, bullet_Height);
    __weak typeof(self) weakSelf = self;
    bullet.enterBlock = ^(CTBullet * bullet, BulletStatus status) {
        switch (status) {
            case enter:
            {
                [weakSelf createBulletWithChannel:bullet.channel];
            }
                break;
            case end:
            {
                [weakSelf.lock lock];
                [weakSelf.resueQueue addObject:bullet];
                [weakSelf.lock unlock];
            }
                break;
            default:
                break;
        }
    };
    [self addSubview:bullet];
    [bullet readyToFire];
}

/**
 *  初始化弹幕
 */
- (void)initBulletCommentView
{
    self.channelCount = self.channelCount == 0?3:self.channelCount;
    self.spaceH = (H(self)- bullet_Height)/(self.channelCount-1);
    //初始化三条弹幕轨迹
    for (int i = 0; i < self.channelCount; i++) {
        NSString * comment = [self bulletReadyShowText];
        if (comment)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createBulletWithChannel:i];
            });
        }
    }
}

- (NSString *)bulletReadyShowText
{
    if (self.tmpComments.count == 0)
    {
        return @"";
    }
    self.index++;
    if (self.index > self.tmpComments.count-1)
    {
        self.index = 0;
    }
    return [self.tmpComments objectAtIndex:self.index];
}

- (void)addBulletFromArray:(NSArray *)bulletAry
{
    if (bulletAry.count != 0)
    {
        [bulletAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tmpComments insertObject:obj atIndex:self.index+idx];
        }];
        if (self.index != 0)
        {
            self.index--;
        }
        [self start];
    }
}

- (void)addBullet:(NSString *)bullet
{
    if (bullet.length != 0)
    {
        [self.tmpComments insertObject:bullet atIndex:self.index];
        if (self.index != 0)
        {
            self.index--;
        }
        [self start];
    }
}

- (NSMutableArray *)tmpComments
{
    if (_tmpComments == nil) {
        _tmpComments = @[].mutableCopy;
    }
    return _tmpComments;
}

- (NSMutableArray *)resueQueue
{
    if (_resueQueue == nil) {
        _resueQueue = @[].mutableCopy;
    }
    return _resueQueue;
}

@end
