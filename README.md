# CCZGuideView
APP引导视图，支持图文排布
====
-------
* 用法介绍
```Objective-C
_guideView = [CCZGuideView guideViewWithPosition:point desc:@"雷姆～。～雷姆～" image:[UIImage imageNamed:@"rem_effect"] showType:CCZGuideViewShowTypeDescBottom clickBackgroundComplication:^(CGPoint targetPoint) {
        [weakSelf.guideView dismiss];
    }];
_guideView.autoClickDismiss = NO;
[_guideView show];
// 这就是简单的创建方法，使用时只需要将需要制定的位置point传入即可。
```
* 属性及方法介绍
```Objective-C
// 这是个枚举体，对应三种显示样式
typedef NS_ENUM(NSUInteger, CCZGuideViewShowType) {
    CCZGuideViewShowTypeDescTop,        ///< 文字在图片上方
    CCZGuideViewShowTypeDescBottom,     ///< 文字在图片下方
    CCZGuideViewShowTypeDescAboveImage, ///< 文字浮于图片上面
};

// 这个属性设置指示圈的大小
@property (nonatomic, assign) CGFloat maskRadius;
// 这个属性设置是否需要主动调用dismiss方法来消失指引图，默认是YES；如果设置成NO，则需要主动在回调中dismiss掉视图
@property (nonatomic, assign) BOOL autoClickDismiss;

// 公开的方法就三个，创建－显示－消失，不需要做其他操作。
+ (CCZGuideView *)guideViewWithPosition:(CGPoint)position desc:(NSString *)desc image:(UIImage *)image showType:(CCZGuideViewShowType)type clickBackgroundComplication:(void(^)(CGPoint targetPoint))complication;
- (void)show;
- (void)dismiss;
