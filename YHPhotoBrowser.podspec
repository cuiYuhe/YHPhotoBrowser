Pod::Spec.new do |s|
    s.name      = 'YHPhotoBrowser'
    s.version   = '1.0.1'
    s.summary   = '类似于qq,微信,微博的图片浏览器:9宫格的图片,点击任何一张放大至全屏,并可以左右滑动查看所有图片.简易框架,易懂.'
    s.homepage  = 'https://github.com/RusselYHCui/YHPhotoBrowser'
    s.license   = 'MIT'
    s.author    = { 'Russel_yh_Cui' => '960743995@qq.com' }
    s.platform  = :ios,'8.0'
    s.source    = {
                    :git =>'https://github.com/RusselYHCui/YHPhotoBrowser.git',
                    :tag => s.version.to_s
    }
    s.requires_arc = true
    s.source_files = 'YHPhotoBrowser/*.{h,m}'
    s.dependency 'SDWebImage'
    s.framework  = 'UIKit', 'QuartzCore'
    s.xcconfig = {'HEADER_SEARCH_PATHS' =>'(SDKROOT)/usr/include/libxml2'}

end