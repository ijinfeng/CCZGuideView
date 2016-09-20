//
//  ViewController.m
//  CCGuideViewTest
//
//  Created by 金峰 on 16/9/20.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "ViewController.h"
#import "CCZGuideView.h"

@interface ViewController ()
@property (nonatomic, strong) CCZGuideView *guideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    __weak typeof(self) weakSelf = self;
    _guideView = [CCZGuideView guideViewWithPosition:point desc:@"雷姆～。～雷姆～" image:[UIImage imageNamed:@"rem_effect"] showType:CCZGuideViewShowTypeDescBottom clickBackgroundComplication:^(CGPoint targetPoint) {
        [weakSelf.guideView dismiss];
    }];
    [_guideView show];
}



@end
