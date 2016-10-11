//
//  YHCircleView.h
//
//  Created by Cui yuhe on 16/10/10.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHProgressCircleView : UIView

@property (nonatomic, assign) CGFloat progress;
/** 进度提示label */
@property (nonatomic, assign) UILabel *progressLabel;

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;



@end
