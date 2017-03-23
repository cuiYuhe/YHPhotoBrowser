//
//  YHBrowserAnimateDelegate.m
//  
//
//  Created by Cui yuhe on 16/10/9.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "YHBrowserAnimateDelegate.h"


static CGFloat YHAnimationDuration = 0.5f;

@interface YHBrowserAnimateDelegate()

/** 记录当前是否是弹出 */
@property (nonatomic, assign, getter=isPresented) BOOL presented;
/** modal时的黑色背景 */
@property (nonatomic, weak) UIView *cover;

@end


@implementation YHBrowserAnimateDelegate

#pragma mark ------------------------------------------
#pragma mark UIViewControllerTransitioningDelegate
///该代理方法用于返回负责转场的控制器对象
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    /**
     创建一个负责管理自定义转场动画的控制器
     
     - parameter presentedViewController:  被弹出的控制(菜单)
     - parameter presentingViewController: 发起modal的 源控制器
     Xocde7以前系统传递给我们的是nil, Xcode7开始传递给我们的是一个野指针
     
     - returns: 负责管理自定义转场动画的控制器
     */
    return [[UIPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


/// 该代理方法用于告诉系统谁来负责控制器如何弹出
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.presented = YES;
    return self;
}

/// 该代理方法用于告诉系统谁来负责控制器如何消失
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    self.presented = NO;
    return self;
}


#pragma mark ------------------------------------------
#pragma mark UIViewControllerAnimatedTransitioning
/// 用于返回动画的时长, 默认用不上
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


/// 该方法用于负责控制器如何弹出和如何消失
// 只要是自定义转场, 控制器弹出和消失都会调用该方法
// 需要在该方法中告诉系统控制器如何弹出和如何消失

// 注意点: 但凡告诉系统我们需要自己来控制控制器的弹出和消失
// 也就是实现了代理UIViewControllerAnimatedTransitioning的方法之后, 那么系统就不会再控制我们控制器的动画了, 所有的操作都需要我们自己完成

// 系统调用该方法时会传递一个transitionContext参数, 该参数中包含了我们所有需要的值
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    // 1.判断当前是弹出还是消失
    if (self.isPresented) { //弹出
        [self animatePresentedController:transitionContext];
    }else{
        [self animateDismissedController:transitionContext];
    }
}

#pragma mark ------------------------------------------
#pragma mark private method
/// 弹出动画
- (void)animatePresentedController:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    NSAssert(self.delegate != nil, @"必须有代理对象才能执行动画");
    [self addCover];
    
    //1.得到当前点击的imageView
    UIImageView *imgView = [self.delegate browserAnimateFirstShowImageView];
    imgView.layer.masksToBounds = YES;
    
    //2.设置frame
    imgView.frame = [self.delegate browserAnimationFromRect];
    
    
    //3.将新建的UIImageView添加到容器视图上
    [[transitionContext containerView] addSubview:imgView];
    
    //4.执行动画,使imageView放大到最大
    CGRect toRect = [self.delegate browserAnimationToRect];
    
    
    [UIView animateWithDuration:YHAnimationDuration animations:^{
        imgView.frame = toRect;
    } completion:^(BOOL finished) {
        
        //移除imageView(新添加的imageView的使命就是让用户看到这个动画过程),不然遮挡browser,collectionView不能滑动
        [imgView removeFromSuperview];
        
        //5.添加原来的图片浏览器
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        
        // 6.通知系统,动画执行完毕
        //注意点: 但凡是自定义转场, 一定要在自定义动画完成之后告诉系统动画已经完成了, 否则会出现一些未知异常
        [transitionContext completeTransition:YES];
    }];
}

/// 隐藏动画
- (void)animateDismissedController:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //1.得到当前点击的imageView
    UIImageView *imageView = [self.delegate browserAnimateEndShowImageView];
    imageView.layer.masksToBounds = YES;
    
    //2.设置frame,此时初始值为全屏时的frame
    imageView.frame = [self.delegate browserAnimationToRect];
    
    //3.将新建的UIImageView添加到容器视图上
    [[transitionContext containerView] addSubview:imageView];
    
    //4.imgView最终的frame,
    CGRect endRect = [self.delegate browserAnimateEndRect];
    
    //5.移除图片浏览器控制器的view
    UIView *browserVcView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [browserVcView removeFromSuperview];
    
    //移除遮盖
    [self dismissCover];
    
    [UIView animateWithDuration:YHAnimationDuration animations:^{
        imageView.frame = endRect;
    } completion:^(BOOL finished) {
        
        //移除imageView(新添加的imageView的使命就是让用户看到这个动画过程)
        [imageView removeFromSuperview];
        
        // 6.通知系统,动画执行完毕
        //注意点: 但凡是自定义转场, 一定要在自定义动画完成之后告诉系统动画已经完成了, 否则会出现一些未知异常
        [transitionContext completeTransition:YES];
    }];
}

- (void)addCover{
    
    UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:cover];
    self.cover = cover;
}

- (void)dismissCover{
    [self.cover removeFromSuperview];
    self.cover = nil;
}

@end
