//
//  YHBrowserAnimateDelegate.h
//  
//
//  Created by Cui yuhe on 16/10/9.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YHBrowserPresentDelegate;

@protocol YHBrowserAnimateDelegateProtocol <NSObject>

/**
 *  获取一个和被点击的imageView一模一样(相同大小,图片相同)的UIImageView
 *
 *  @return 放大动画使用的UIImageView
 */
- (UIImageView *)browserAnimateFirstShowImageView;

///获取被点击cell相对于keywindow的frame
- (CGRect)browserAnimationFromRect;

/// 获取被点击cell中的图片, 将来在图片浏览器中显示的尺寸
- (CGRect)browserAnimationToRect;

/**
 *  获得结束时显示的UIImageView,缩小动画使用的UIImageView
 */
- (UIImageView *)browserAnimateEndShowImageView;
/**
 *  消失时位置,最终动画在这个rect区域消失.
 */
- (CGRect)browserAnimateEndRect;


@end

@interface YHBrowserAnimateDelegate : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
/** delegate */
@property (nonatomic, weak) id<YHBrowserAnimateDelegateProtocol> delegate;

@end
