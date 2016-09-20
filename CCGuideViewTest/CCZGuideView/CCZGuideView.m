//
//  CCZGuideView.m
//  CCGuideViewTest
//
//  Created by 金峰 on 16/9/20.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import "CCZGuideView.h"

/* 背景颜色深度*/
static CGFloat const backgroundDepth = .6f;
/* 遮盖层默认半径*/
static CGFloat const maskRadiusDefault = 20.f;
static CGFloat const lineWidth = 3.f;
static CGFloat const textFont = 14;
static CGFloat const space = 5;
/* 指引线的宽高*/
static CGFloat const x_space = 70, y_space = 86;
/* 画线动画时间*/
static NSTimeInterval duration = .5f;
static NSTimeInterval dismissTime = .3f;

typedef void(^clickComplication)(CGPoint targetPoint);

#define CJFScreenBounds [UIScreen mainScreen].bounds
#define DefaultColor    [UIColor whiteColor]
#define DefaultDotLine  (@[@10,@5])

@interface CCZGuideView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIImage *descImage;
@property (nonatomic, strong) CAShapeLayer *guideLayer;
@property (nonatomic, assign) CGFloat maskR;
@property (nonatomic, assign) CGFloat max_width;
@property (nonatomic, assign) CGPoint transferPosition;
@property (nonatomic, assign) CCZGuideViewShowType type;
@property (nonatomic, copy)   NSString *desc;
@property (nonatomic, copy)   clickComplication comp;
@end

@implementation CCZGuideView

- (instancetype)initWithPosition:(CGPoint)position desc:(NSString *)desc image:(UIImage *)image showType:(CCZGuideViewShowType)type clickBackgroundComplication:(void(^)(CGPoint targetPoint))complication {
    if (self = [super initWithFrame:CJFScreenBounds]) {
        // basic setting
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:backgroundDepth];
        
        // 保存变量
        self.autoClickDismiss = YES;
        self.maskR = self.maskRadius ? self.maskRadius : maskRadiusDefault;
        self.max_width = (CJFScreenBounds.size.width / 2 - x_space  - 10);
        self.transferPosition = position;
        self.desc = desc;
        self.descImage = image;
        self.type = type;
        self.lineWidth = self.lineWidth ? self.lineWidth : lineWidth;
        self.lineColor = self.lineColor ? self.lineColor : DefaultColor;
        self.descColor = self.descColor ? self.descColor : DefaultColor;
        self.descFont  = self.descFont  ? self.descFont  : [UIFont systemFontOfSize:textFont];
        
        // 限制position的位置
        if ((position.y - self.maskR - space) <= 0) {
            position.y = self.maskR + space;
        }
        if ((position.y + self.maskR + space) >= CJFScreenBounds.size.height) {
            position.y = CJFScreenBounds.size.height - self.maskR - space;
        }
        if ((position.x - self.maskR - space) <= 0) {
            position.x = self.maskR + space;
        }
        if ((position.x + self.maskR + space) >= CJFScreenBounds.size.width) {
            position.x = CJFScreenBounds.size.width - self.maskR - space;
        }
        
        // 添加遮罩
        [self addMaskInPosition:position];
        
        // 添加引导线
        self.guideLayer = [self guideLine];
        
        // 确定引线的位置
        self.guideLayer.position = [self giveOriginPointForLineWithPosition:position];
        
        [self.layer addSublayer:self.guideLayer];
        
        if (complication) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundFunc:)];
            [self addGestureRecognizer:tap];
            
            self.comp = complication;
        }
    }
    return self;
}

+ (CCZGuideView *)guideViewWithPosition:(CGPoint)position desc:(NSString *)desc image:(UIImage *)image showType:(CCZGuideViewShowType)type clickBackgroundComplication:(void (^)(CGPoint))complication {
    return [[CCZGuideView alloc] initWithPosition:position desc:desc image:image showType:type clickBackgroundComplication:complication];
}

- (void)addMaskInPosition:(CGPoint)position {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:position radius:self.maskR startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [maskPath appendPath:roundPath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer setMask:maskLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = roundPath.CGPath;
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineDashPattern = DefaultDotLine;
    shapeLayer.lineDashPhase = 0;
    [self.layer addSublayer:shapeLayer];
    
}

- (CAShapeLayer *)guideLine {
    
    UIBezierPath *guidePath = [UIBezierPath bezierPath];
    [guidePath moveToPoint:CGPointMake(0, 0)];
    [guidePath addCurveToPoint: CGPointMake(34.21, 51.21) controlPoint1: CGPointMake(-0.75, 0) controlPoint2: CGPointMake(4.24, 51.21)];
    [guidePath addCurveToPoint: CGPointMake(50.02, 35.75) controlPoint1: CGPointMake(64.17, 51.21) controlPoint2: CGPointMake(50.02, 35.75)];
    [guidePath addCurveToPoint: CGPointMake(34.21, 35.75) controlPoint1: CGPointMake(50.02, 35.75) controlPoint2: CGPointMake(39.2, 28.99)];
    [guidePath addCurveToPoint: CGPointMake(40.87, 64.74) controlPoint1: CGPointMake(29.22, 42.52) controlPoint2: CGPointMake(31.71, 47.35)];
    [guidePath addCurveToPoint: CGPointMake(70, 86) controlPoint1: CGPointMake(50.02, 82.13) controlPoint2: CGPointMake(70, 86)];
    
    CAShapeLayer *guideLayer = [CAShapeLayer layer];
    guideLayer.path = guidePath.CGPath;
    guideLayer.lineWidth = self.lineWidth;
    guideLayer.lineCap = kCALineCapRound;
    guideLayer.strokeColor = self.lineColor.CGColor;
    guideLayer.fillColor = [UIColor clearColor].CGColor;
    guideLayer.anchorPoint = CGPointMake(0, 0);
    guideLayer.lineDashPattern = DefaultDotLine;
    return guideLayer;
    
}

#pragma mark -- 点击手势

- (void)tapBackgroundFunc:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    self.comp(point);
    if (self.autoClickDismiss) {
        [self dismiss];
    }
}

#pragma mark - return line position and text position

- (CGPoint)giveOriginPointForLineWithPosition:(CGPoint)position {
    CGFloat x = position.x, y = position.y;
    if (y > CJFScreenBounds.size.height / 2) {
        y -= (self.maskR + space);
        self.guideLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        if (x <= (CJFScreenBounds.size.width / 2)) {
            self.guideLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        }
    } else {
        y += (self.maskR + space);
        if (x > (CJFScreenBounds.size.width / 2)) {
            self.guideLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }
    }
    position = CGPointMake(x, y);
    return position;
}

- (CGPoint)giveOriginPointForTextWithPosition:(CGPoint)position {
    CGFloat x = self.transferPosition.x, y = self.transferPosition.y;
    CGFloat label_x = position.x, label_y = position.y;
    CGPoint textPoisition = CGPointZero;
    if (y <= CJFScreenBounds.size.height / 2) {
        if (x <= (CJFScreenBounds.size.width / 2)) {
            label_x += x_space + space;
            label_y += y_space;
            self.showView.layer.anchorPoint = CGPointMake(0, 0.5);
        } else {
            label_x -= x_space + space;
            label_y += y_space;
            self.showView.layer.anchorPoint = CGPointMake(1, 0.5);
        }
    } else {
        if (x > (CJFScreenBounds.size.width / 2)) {
            label_x -= x_space + space;
            label_y -= y_space;
            self.showView.layer.anchorPoint = CGPointMake(1, 0.5);
        } else {
            label_x += x_space + space;
            label_y -= y_space;
            self.showView.layer.anchorPoint = CGPointMake(0, 0.5);
        }
    }
    textPoisition = CGPointMake(label_x, label_y);
    return textPoisition;
}

#pragma mark - custom show view

- (void)addShowView {
    UIImageView *descImageView;
    UILabel *textLabel;
    UIView *showView = [[UIView alloc] init];
    self.showView = showView;
    showView.backgroundColor = [UIColor clearColor];
    
    CGSize labelSize;
    if (self.desc) {
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = self.descFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.desc;
        textLabel.textColor = self.descColor;
        textLabel.numberOfLines = 0;
        labelSize = [self.desc boundingRectWithSize:CGSizeMake(self.max_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : textLabel.font} context:nil].size;
    }
    
    if (self.descImage) {
        descImageView = [[UIImageView alloc] initWithImage:self.descImage];
    }
    if (self.type == CCZGuideViewShowTypeDescAboveImage) {
        showView.frame = CGRectMake(0, 0, self.max_width, MAX(self.max_width, labelSize.height));
        if (descImageView) {
            descImageView.frame = CGRectMake(0, 0, self.max_width, MAX(self.max_width, labelSize.height));
            [showView addSubview:descImageView];
        }
        if (textLabel) {
            textLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
            [showView addSubview:textLabel];
        }
        [self addSubview:showView];
    } else if (self.type == CCZGuideViewShowTypeDescBottom) {
        if (descImageView) {
            descImageView.frame = CGRectMake(0, 0, self.max_width, self.max_width);
        }
        if (textLabel) {
            textLabel.frame = CGRectMake(0, CGRectGetMaxY(descImageView.frame) + (descImageView ? space : 0), labelSize.width, labelSize.height);
        }
        showView.frame = CGRectMake(0, 0, self.max_width, CGRectGetHeight(descImageView.frame) + CGRectGetHeight(textLabel.frame) + (descImageView ? space : 0));
        if (descImageView) {
            [showView addSubview:descImageView];
        }
        if (textLabel) {
            [showView addSubview:textLabel];
        }
        [self addSubview:showView];
    } else {
        if (textLabel) {
            textLabel.frame = CGRectMake(0, 0, self.max_width, labelSize.height);
        }
        if (descImageView) {
            descImageView.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame) + (textLabel ? space : 0), self.max_width, self.max_width);
        }
        showView.frame = CGRectMake(0, 0, self.max_width, CGRectGetHeight(textLabel.frame) + CGRectGetHeight(descImageView.frame) + (textLabel ? space : 0));
        if (textLabel) {
            [showView addSubview:textLabel];
        }
        if (descImageView) {
            [showView addSubview:descImageView];
        }
        [self addSubview:showView];
    }
    CGPoint showViewOriPosition = [self giveOriginPointForTextWithPosition:[self giveOriginPointForLineWithPosition:self.transferPosition]];
    showView.layer.position = showViewOriPosition;
}

#pragma mark - Anim

- (void)addStrokeAnimWithAnimation:(BOOL)animated {
    CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnim.duration = animated ? duration : 0;
    strokeAnim.fromValue = @0;
    strokeAnim.toValue = @1;
    strokeAnim.delegate = self;
    strokeAnim.removedOnCompletion = NO;
    [self.guideLayer addAnimation:strokeAnim forKey:@"guideLineAnim"];
}

#pragma mark - Core Anim Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.guideLayer animationForKey:@"guideLineAnim"]) {
        [self.guideLayer removeAllAnimations];
        [self addShowView];
    }
    if ([self.layer animationForKey:@"dismissAnim"]) {
        [self.guideLayer removeFromSuperlayer];
        [self.layer removeAllAnimations];
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark -- Basic Func

- (void)show {
    NSEnumerator *windowEnnumtor = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
    for (UIWindow *window in windowEnnumtor) {
        BOOL isOnMainScreen = window.screen == [UIScreen mainScreen];
        BOOL isVisible      = !window.hidden && window.alpha > 0;
        BOOL isLevelNormal  = window.windowLevel == UIWindowLevelNormal;
        
        if (isOnMainScreen && isVisible && isLevelNormal) {
            [window addSubview:self];
            [self addStrokeAnimWithAnimation:YES];
        }
    }
}

- (void)dismiss {
    if (self) {
        CABasicAnimation *dismissAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        dismissAnim.duration = dismissTime;
        dismissAnim.delegate = self;
        dismissAnim.toValue = @0;
        dismissAnim.removedOnCompletion = NO;
        dismissAnim.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:dismissAnim forKey:@"dismissAnim"];
    }
}

@end
