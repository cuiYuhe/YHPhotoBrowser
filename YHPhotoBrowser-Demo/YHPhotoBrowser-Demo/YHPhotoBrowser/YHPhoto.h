//
//  YHPhoto.h
//
//  Created by Cui yuhe on 16/10/10.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YHPhoto : NSObject


@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片

/** 来源imageView */
@property (nonatomic, weak) UIImageView *srcImageView;




@end
