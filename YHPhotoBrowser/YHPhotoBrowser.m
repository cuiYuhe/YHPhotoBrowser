//
//  YHPhotoBrowser.m
//
//  Created by Cui yuhe on 16/10/8.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "YHPhotoBrowser.h"
#import "YHPhotoBrowserCell.h"
#import "YHBrowserAnimateDelegate.h"
#import <UIImageView+WebCache.h>
#import "YHProgressCircleView.h"
#import <SDWebImageManager.h>

@interface YHPhotoBrowser ()<UICollectionViewDataSource, UICollectionViewDelegate, YHPhotoBrowserCellDelegate, YHBrowserAnimateDelegateProtocol>
/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** YHBrowserAnimateDelegate */
@property (nonatomic, strong) YHBrowserAnimateDelegate *browserAnimateDelegate;
/** 当前页数的标记 */
@property (nonatomic, weak) UILabel *pageLabel;
/** 下载图片进度条 */
@property (nonatomic, weak) YHProgressCircleView *progressView;

/** 初始时显示的配图的索引 */
@property (nonatomic, strong) NSIndexPath *startIndexPath;

/** 结束的imageView */
@property (nonatomic, weak) UIImageView *endImageView;
@end

@implementation YHPhotoBrowser

#pragma mark ------------------------------------------
#pragma mark lazy
- (YHBrowserAnimateDelegate *)browserAnimateDelegate{
    if (!_browserAnimateDelegate) {
        self.browserAnimateDelegate = [[YHBrowserAnimateDelegate alloc] init];
        self.browserAnimateDelegate.delegate = self;
    }
    return _browserAnimateDelegate;
}

- (YHProgressCircleView *)progressView{
    if (!_progressView) {
        
        //进度条
        YHProgressCircleView *progressView = [[YHProgressCircleView alloc] init];
        self.progressView = progressView;
        
        //加在view中,不知为何collectionView切换item有问题.如有知道原因的朋友,请赐教.
        UIWindow *w = [UIApplication sharedApplication].windows.lastObject;
        [w addSubview:progressView];
//        [self.view addSubview:progressView];
        
        CGFloat WH = 60;
        CGRect rect = self.progressView.frame;
        rect.size = CGSizeMake(WH, WH);
        self.progressView.frame = rect;
        self.progressView.center = self.view.center;
        
        _progressView = progressView;
    }
    return _progressView;
}

#pragma mark ------------------------------------------
#pragma mark life cycle
- (instancetype)init{
    if (self = [super init]) {
        
        //设置转场代理
        self.transitioningDelegate = self.browserAnimateDelegate;
        //设置转场样式
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[YHPhotoBrowserCell class] forCellWithReuseIdentifier:[YHPhotoBrowserCell identifier]];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //添加当前页数的标记
    UILabel *lb = [[UILabel alloc] init];
    self.pageLabel = lb;
    lb.textColor = [UIColor whiteColor];
    [self.view addSubview:lb];
    CGFloat lbW = 100;
    CGFloat lbH = 30;
    CGFloat lbX = 10;
    CGFloat lbY = self.view.frame.size.height - lbH - 10;
    lb.frame = CGRectMake(lbX, lbY, lbW, lbH);
    lb.text = [NSString stringWithFormat:@"1/%zd", self.photos.count];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.collectionView scrollToItemAtIndexPath:self.startIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    YHPhotoBrowserCell *cell = (YHPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //stop downloading
    [cell.iconImgView sd_cancelCurrentImageLoad];
    [self.progressView removeFromSuperview];
}

#pragma mark ------------------------------------------
#pragma mark property set method
- (void)setPhotos:(NSArray<YHPhoto *> *)photos{
    _photos = photos;
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.startIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
}

#pragma mark ------------------------------------------
#pragma mark public method
- (void)showWithPresentingVc:(UIViewController *)presentingVc{
    [presentingVc presentViewController:self animated:YES completion:nil];
}

#pragma mark ------------------------------------------
#pragma mark UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消之前的下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    YHPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YHPhotoBrowserCell identifier] forIndexPath:indexPath];
    cell.delegate = self;
    YHPhoto *photo = self.photos[indexPath.item];
    
    if (!photo.url) { //没有设置url
        if (photo.image) {//设置了image,
            cell.iconImgView.image = photo.image;
        }else{//没有设置image,
            cell.iconImgView.image = photo.srcImageView.image;
        }
        return cell;
    }
    
    //设置了url,没有image
    [cell.iconImgView sd_setImageWithPreviousCachedImageWithURL:photo.url placeholderImage:photo.srcImageView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        //进度条
        self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f", progress];
        self.progressView.progress = progress;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.progressView.hidden = YES;
        [self.progressView removeFromSuperview];
        
        if (error) {
//            [MBProgressHUD showError:@"加载图片失败."];
            NSLog(@"error = %@", error);
        }
    }];
    return cell;
}

#pragma mark ------------------------------------------
#pragma mark UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(photoBrowserDidClickImageForIndexPath:)]) {
        [self.delegate photoBrowserDidClickImageForIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.currentIndex = index;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", index+1, self.photos.count];
}



#pragma mark ------------------------------------------
#pragma mark YHPhotoBrowserCellDelegate
- (void)photoBrowserCellDidClickCell:(YHPhotoBrowserCell *)cell{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------------------------------------------
#pragma mark YHBrowserAnimateDelegateProtocol的3个必须实现的方法
- (UIImageView *)browserAnimateFirstShowImageView{
    
    return [self createCurrentImage];
}

- (CGRect)browserAnimationFromRect{
    
    UIImageView *imageView = self.photos[self.currentIndex].srcImageView;
    CGRect frame = [imageView.superview convertRect:imageView.frame toView:nil];
    return frame;
}

- (CGRect)browserAnimationToRect{
    UIImage *image = self.photos[self.currentIndex].srcImageView.image;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = screenWidth * image.size.height / image.size.width;
    
    CGRect frame = CGRectZero;
    //如果图片height > 屏幕height
    if (height > screenHeight) {
        frame = CGRectMake(0, 0, screenWidth, height);
    }else{
        CGFloat offsetY = (screenHeight - height) * 0.5;
        frame = CGRectMake(0, offsetY, screenWidth, height);
    }
    return frame;
}

/**
 *  获得结束时显示的UIImageView
 */
- (UIImageView *)browserAnimateEndShowImageView{
    return [self createCurrentImage];
}

- (CGRect)browserAnimateEndRect{
    
    self.endImageView = self.photos[self.currentIndex].srcImageView;
    CGRect rect = [self.endImageView.superview convertRect:self.endImageView.frame toView:nil];
    return rect;
}

#pragma mark ------------------------------------------
#pragma mark private method
///创建一个与当前显示的源imageView相同的imageView
- (UIImageView *)createCurrentImage{
    //拿到显示的图片
    UIImage *image = self.photos[self.currentIndex].srcImageView.image;
    
    //创建一个新的imageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

@end
