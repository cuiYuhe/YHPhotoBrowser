//
//  HomeCollectionViewCell.m
//  testPicBrowser
//
//  Created by Cui yuhe on 16/10/9.
//  Copyright © 2016年 Cui yuhe. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
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
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.frame = self.bounds;
    [self.contentView addSubview:imageView];
}

+ (NSString *)identifier{
    return NSStringFromClass(self);
}
@end
