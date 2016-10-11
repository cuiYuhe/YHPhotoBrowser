//
//  ViewController.m
//
//
//  Created by Cui yuhe on 16/10/8.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "ViewController.h"
#import "YHPhotoBrowser.h"

#import "HomeCollectionViewCell.h"

//http://icgdb.oss-cn-shanghai.aliyuncs.com/testByCui/yh02.jpg

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 当前点击的cell的indexPath */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation ViewController

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        self.imageViews = [@[] mutableCopy];;
    }
    return _imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:[HomeCollectionViewCell identifier]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HomeCollectionViewCell identifier] forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"yh0%zd", indexPath.item+1]];
    [self.imageViews addObject:cell.imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndexPath = indexPath;
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i<9; i++) {
        
        //创建 YHPhoto 对象
        YHPhoto *photo = [[YHPhoto alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://icgdb.oss-cn-shanghai.aliyuncs.com/testByCui/yh%02zd.jpg", i+1]];
        photo.url = url;
        photo.srcImageView = self.imageViews[i];
        [images addObject:photo];
    }
    
    //设置图片浏览器
    YHPhotoBrowser *browser = [[YHPhotoBrowser alloc] init];
    
    browser.photos = images;
    browser.currentIndex = indexPath.item;
    
    //弹出browser
    [browser showWithPresentingVc:self];
}


@end
