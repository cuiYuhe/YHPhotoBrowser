//
//  YHPhotoBrowserCell.m
//
//  Created by Cui yuhe on 16/10/8.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "YHPhotoBrowserCell.h"

@interface YHPhotoBrowserCell()<UIScrollViewDelegate>
/** 最下面的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 双击的标志 */
@property (nonatomic, assign, getter=isDoubleTap) BOOL doubleTap;

@end

@implementation YHPhotoBrowserCell

+ (NSString *)identifier{
    return NSStringFromClass(self);
}

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
    
    UIScrollView *sc = [[UIScrollView alloc] init];
    sc.frame = self.bounds;
    [self.contentView addSubview:sc];
    self.scrollView = sc;
    sc.delegate = self;
    
    UIImageView *iconImgView = [UIImageView new];
    iconImgView.frame = self.bounds;
    iconImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    iconImgView.contentMode = UIViewContentModeScaleToFill;
    [sc addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    // 监听点击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    [self addObserver:self forKeyPath:@"iconImgView.image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - KVO的监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id new = change[NSKeyValueChangeNewKey];
    
    if (new) {
        [self setIconImageViewPosition];
    }
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"iconImgView.image"];
}

///设置iconImageView的位置
- (void)setIconImageViewPosition{
    // Reset,防止循环使用放大
    self.scrollView.maximumZoomScale = 1;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.zoomScale = 1;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    
    //使image占据全部宽度
    UIImage *iconImg = self.iconImgView.image;
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat scale = iconImg.size.height / iconImg.size.width;
    CGFloat showH = width * scale;
    
    CGFloat y = 0;
    if (showH < height) {
        y = (height - showH) / 2;
    }
    
    //设置frame在缩放时,上下位置不正确,所以设置size与scrollView的contentInset.与下面的缩放的代理方法一致:用contentInset来控制imageView的位置
    //    self.iconImgView.frame = CGRectMake(0, y, width, showH);
    
    CGRect iconImgViewFrame = self.iconImgView.frame;
    iconImgViewFrame.size = CGSizeMake(width, showH);
    self.iconImgView.frame = iconImgViewFrame;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, y, 0);
    self.scrollView.contentSize = CGSizeMake(width, showH);
    
    // 设置伸缩比例
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.minimumZoomScale = 0.5;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    _doubleTap = NO;
    
    //delay执行,目的是执行过 handleDoubleTap 之后,再执行.如果是双击,则不hide
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)hide{
    
    if (self.isDoubleTap) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowserCellDidClickCell:)]) {
        [self.delegate photoBrowserCellDidClickCell:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self.scrollView];
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:1 animated:YES];
    } else {
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.iconImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat screenWidth = self.bounds.size.width;
    CGFloat screenHeight = self.bounds.size.height;
    
    /*
     被缩放的图片本质上是通过transform缩放图片
     在整个缩放的过程中contentSize的值和frame值是一样的, 会随着图片大小的变化而变化
     而bounds从始至终都不会改变
     */
    
    // 1.计算边距
    CGFloat h = self.iconImgView.frame.size.height;
    CGFloat w = self.iconImgView.frame.size.width;
    CGFloat offsetY = (screenHeight - h) * 0.5;
    CGFloat offsetX = (screenWidth - w) * 0.5;
    
    // 2.调整边距
    offsetY = (offsetY < 0) ? 0 : offsetY;
    offsetX = (offsetX < 0) ? 0 : offsetX;
    
    // 3.设置边距
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
}

@end
