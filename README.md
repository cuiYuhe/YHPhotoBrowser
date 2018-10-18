# YHPhotoBrowser

## 一.说明:类似于qq,微信,微博的图片浏览器:9宫格的图片,点击任何一张放大至全屏,并可以左右滑动查看所有图片.

## 二.使用步骤:

### 1.导入:
```
#import "YHPhotoBrowser.h"
```

### 2.给图片浏览器对象,传入相关属性:_photos, _currentIndex, _fromImageView,具体如下:

```
 NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i<9; i++) {
        
        //创建 YHPhoto 对象
        YHPhoto *photo = [[YHPhoto alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://icgdb.oss-cn-shanghai.aliyuncs.com/testByCui/yh%02zd.jpg", i+1]];
        
        //大图的url
        photo.url = url;
        //起始的imageView数组
        photo.srcImageView = self.imageViews[i];
        [images addObject:photo];
    }
    
    //设置图片浏览器
    YHPhotoBrowser *browser = [[YHPhotoBrowser alloc] init];
    
    browser.photos = images;
    //当前点击的imageView的索引,即第几个imageView
    browser.currentIndex = indexPath.item;
    
    //弹出browser
    [browser showWithPresentingVc:self];

```

