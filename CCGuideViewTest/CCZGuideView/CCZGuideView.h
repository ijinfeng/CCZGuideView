//
//  CCZGuideView.h
//  CCGuideViewTest
//
//  Created by 金峰 on 16/9/20.
//  Copyright © 2016年 金峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CCZGuideViewShowType) {
    CCZGuideViewShowTypeDescTop,        ///< 文字在图片上方
    CCZGuideViewShowTypeDescBottom,     ///< 文字在图片下方
    CCZGuideViewShowTypeDescAboveImage, ///< 文字浮于图片上面
};

@interface CCZGuideView : UIView
@property (nonatomic, assign) CGFloat maskRadius;       ///< 遮盖层的半径
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *descColor;
@property (nonatomic, strong) UIFont  *descFont;
@property (nonatomic, assign) BOOL autoClickDismiss;    ///< 点击自动释放

+ (CCZGuideView *)guideViewWithPosition:(CGPoint)position desc:(NSString *)desc image:(UIImage *)image showType:(CCZGuideViewShowType)type clickBackgroundComplication:(void(^)(CGPoint targetPoint))complication;
- (void)show;
- (void)dismiss;
@end

