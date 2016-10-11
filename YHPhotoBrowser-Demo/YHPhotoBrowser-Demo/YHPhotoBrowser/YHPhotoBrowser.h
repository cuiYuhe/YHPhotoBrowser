//
//  YHPhotoBrowser.h
//  
//  Created by Cui yuhe on 16/10/8.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPhoto.h"
@class YHPhotoBrowser;

@protocol YHPhotoBrowserDelegate <NSObject>

/**
 *  点击图片时调用
 */
- (void)photoBrowserDidClickImageForIndexPath:(NSIndexPath *)indexPath;

@end

@interface YHPhotoBrowser : UIViewController

/** 图片数组 */
@property (nonatomic, strong) NSArray<YHPhoto *> *photos;
/** delegate */
@property (nonatomic, weak) id<YHPhotoBrowserDelegate> delegate;
/** 被点击配图的索引 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 *  modal出图片浏览器
 *
 *  @param presentingVc modal出来当前图片浏览器的vc
 */
- (void)showWithPresentingVc:(UIViewController *)presentingVc;

@end
