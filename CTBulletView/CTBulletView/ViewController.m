//
//  ViewController.m
//  CTBulletView
//
//  Created by Admin on 2017/1/3.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ViewController.h"
#import "CTBulletView.h"

@interface ViewController ()

@property (nonatomic, strong)CTBulletView * bulletView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configStopBtn];
}


- (void)configStopBtn
{
    UIButton * (^buttonInit)(NSString * text, CGRect frame, SEL sel) = ^(NSString * text, CGRect frame, SEL sel) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        return btn;
    };
    
    CGFloat width = CGRectGetWidth(self.view.frame)/3;
    UIButton * startBtn = buttonInit(@"Start", CGRectMake(10, 100, width-20, 35), @selector(clickStart));
    [self.view addSubview:startBtn];

    
    UIButton * stopBtn = buttonInit(@"Stop", CGRectMake(width+10, 100, width-20, 35), @selector(clickStop));
    [self.view addSubview:stopBtn];

    UIButton * addBtn = buttonInit(@"Add", CGRectMake(2*width+10, 100, width-20, 35), @selector(clickAdd));
    [self.view addSubview:addBtn];
}

- (void)clickAdd
{
    NSArray * ary = @[@"😀😙😈👾😩👾🐎",
                      @"🐧🐒🦀哈哈哈",
                      @"份额凤飞飞.........",
                      @"🌳🐗🐹🙉🐵"];
    [self.bulletView addBullet:ary[arc4random_uniform((uint32_t)(ary.count))]];
}


- (void)clickStart
{
    [self.bulletView start];
}

- (void)clickStop
{
    [self.bulletView stop];
}


- (CTBulletView *)bulletView {
    if (!_bulletView)
    {
        _bulletView = [[CTBulletView alloc] init];
        _bulletView.frame = CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 150);
        _bulletView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bulletView.channelCount = 5;
        [_bulletView addBulletFromArray:@[@"😀😙😈👾😩👾🐎",
                                          @"🐧🐒🦀哈哈哈",
                                          @"份额凤飞飞.........",
                                          @"再看, 再看, 再看就把你吃掉",
                                          @"别说话了, 赶紧洗洗睡吧",
                                          @"🌳🐗🐹🙉🐵",
                                          @"呵呵, 呵呵, 呵呵......................",
                                          @"今天风真大"]];
        [self.view addSubview:_bulletView];
    }
    return _bulletView;
}
@end
