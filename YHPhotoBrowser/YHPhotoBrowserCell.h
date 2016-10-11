//
//  YHPhotoBrowserCell.h
//  
//
//  Created by Cui yuhe on 16/10/8.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHPhotoBrowserCell;

@protocol YHPhotoBrowserCellDelegate <NSObject>

@optional
/**
 *  点击了cell
 */
- (void)photoBrowserCellDidClickCell:(YHPhotoBrowserCell *)cell;

@end

@interface YHPhotoBrowserCell : UICollectionViewCell

/** delegate */
@property (nonatomic, weak) id<YHPhotoBrowserCellDelegate> delegate;
/** 图片imageView */
@property (nonatomic, weak) UIImageView *iconImgView;


+ (NSString *)identifier;

@end
