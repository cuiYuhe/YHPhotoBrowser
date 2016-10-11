//
//  YHCircleView.m
//
//  Created by Cui yuhe on 16/10/10.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "YHProgressCircleView.h"

@implementation YHProgressCircleView

//- (id)init
//{
////    return [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
//}

- (void)awakeFromNib{
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
}

- (UILabel *)progressLabel{
    if (!_progressLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.frame = self.bounds;
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:label];
        _progressLabel = label;
    }
    return _progressLabel;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat width = 8;
    CGContextSetLineWidth(ctx, width);
    CGFloat radius = MIN(rect.size.height, rect.size.width)/2 - width/2;
    
    //1.底面的全圆
    [self.trackTintColor set];
    
    //描述路径
    CGPoint center1 = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat startA1 = -M_PI_2;
    CGFloat endA1 = - M_PI_2 + M_PI * 2;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center1 radius:radius startAngle:startA1 endAngle:endA1 clockwise:YES];
    
    //把路径添加到上下文当中.
    CGContextAddPath(ctx, path1.CGPath);
    //把上下文的内容渲染到View上.
    CGContextStrokePath(ctx);
    
    
    //2.进度圆
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [self.progressTintColor set];
    
    //2.描述路径
    //    NSLog(@"%@",NSStringFromCGPoint(self.center));
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat startA = -M_PI_2;
    CGFloat endA = - M_PI_2 +  self.progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    //3.把路径添加到上下文当中.
    CGContextAddPath(ctx, path.CGPath);
    //4.把上下文的内容渲染到View上.
    CGContextStrokePath(ctx);
    
}

#pragma mark ------------------------------------------
#pragma mark Property Methods
- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        _progressTintColor = [UIColor whiteColor];
    }
    return _progressTintColor;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self setNeedsDisplay];
}

@end
