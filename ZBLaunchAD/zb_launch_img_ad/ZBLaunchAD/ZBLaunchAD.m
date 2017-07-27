//
//  ZBLaunchAD.m
//  zb_launch_img_ad
//
//  Created by zyon on 08/04/2017.
//  Copyright © 2017 zyonbao. All rights reserved.
//

#import "ZBLaunchAD.h"
#import "UIImageView+WebCache.h"

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width
#define kDefaultADTime 5

@interface ZBLaunchViewController : UIViewController

@property (nonatomic, strong) UIView *containerView;

@end

@implementation ZBLaunchViewController

- (void)setContainerView:(UIView *)containerView{
    if (_containerView != containerView) {
        _containerView = containerView;
        if (_containerView) {
            [self.view addSubview:_containerView];
        }
    }
}

- (void)viewDidLoad{
    if (_containerView) {
        [self.view addSubview:_containerView];
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_containerView) {
        [_containerView setFrame:self.view.bounds];
    }
}

@end


@protocol ZBLaunchWindowDataSource <NSObject>

@required
@property (nonatomic, assign) ZBLaunchADType adShowType;
@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, assign) CGFloat logoHeight;//logo的高度，仅当展示类型为logo时生效

- (void)adViewShouldDismissWithType:(ZBLaunchADCallBackType)callBackType sender:(id)sender;

@end

@interface ZBLaunchADWindow : UIWindow

@property (nonatomic, weak) id <ZBLaunchWindowDataSource> dataSource;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *skipBtn;

@end

@implementation ZBLaunchADWindow

#pragma mark - 点击广告
- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(adViewShouldDismissWithType:sender:)]) {
        [self.dataSource adViewShouldDismissWithType:ZBLaunchADCallBackTypeADClick sender:recognizer];
    }
}
#pragma mark - 跳过广告
- (void)skipBtnClick:(id)sender{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(adViewShouldDismissWithType:sender:)]) {
        [self.dataSource adViewShouldDismissWithType:ZBLaunchADCallBackTypeBtnSkip sender:sender];
    }
}
#pragma mark - 广告展示结束
- (void)adEndShowAction{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(adViewShouldDismissWithType:sender:)]) {
        [self.dataSource adViewShouldDismissWithType:ZBLaunchADCallBackTypeEndShow sender:nil];
    }
}
#pragma mark - 开启关闭动画
- (void)closeAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = .5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeADView)
                                   userInfo:nil
                                    repeats:NO];
}
- (void)openAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
}
#pragma mark - 关闭动画完成时处理事件
-(void)closeADView{
    self.dataSource = nil;
    self.hidden = YES;
}
#pragma mark - 计算布局
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat totoalWidth = CGRectGetWidth(self.frame);
    CGFloat totoalHeight = CGRectGetHeight(self.frame);
    self.skipBtn.frame = CGRectMake(totoalWidth - 70, 32, 60, 30);
    if (self.dataSource &&(ZBLaunchADTypeWithLogo == self.dataSource.adShowType)) {
        CGFloat logoImageViewHeight = CGFLOAT_MIN;
        @try {
            logoImageViewHeight = self.dataSource.logoHeight;
        } @catch (NSException *exception) {
            //
        } @finally {
            if (fabs(logoImageViewHeight)<0.001f) {
                logoImageViewHeight = totoalWidth/3;
            }
        }
        
        [self.adImageView setFrame:CGRectMake(0, 0, totoalWidth, totoalHeight - logoImageViewHeight)];
        if(self.logoImageView){
            [self.logoImageView setFrame:CGRectMake(0, CGRectGetHeight(self.adImageView.frame), totoalWidth, logoImageViewHeight)];
        }
    }else{
        [self.adImageView setFrame:CGRectMake(0, 0, totoalWidth, totoalHeight)];
        if(self.logoImageView){
            [self.logoImageView setFrame:CGRectZero];
        }
    }
}
#pragma mark - getters & setters
- (UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(mainWidth - 70, 20, 60, 30);
        _skipBtn.backgroundColor = [UIColor brownColor];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _skipBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _skipBtn.layer.mask = maskLayer;
        [_skipBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}
- (UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth/3)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
        // 允许用户交互
        _adImageView.userInteractionEnabled = YES;
        [_adImageView addGestureRecognizer:tap];
    }
    return _adImageView;
}
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth/3)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_logoImageView setBackgroundColor:[UIColor whiteColor]];
    }
    return _logoImageView;
}
#pragma mark - cofigSubViews
- (void)setupSubViews:(ZBLaunchADType)type{
    [self addSubview:self.adImageView];
    if(self.dataSource && (ZBLaunchADTypeWithLogo == self.dataSource.adShowType)){
        [self addSubview:self.logoImageView];
    }
    [self addSubview:self.skipBtn];
}

@end


#pragma mark - ZBLaunchAD implementation

@interface ZBLaunchAD ()<ZBLaunchWindowDataSource>

@property (nonatomic, strong) ZBLaunchADWindow *adShowWindow;
@property (nonatomic, strong) ZBLaunchViewController *launchViewController;

@end

@implementation ZBLaunchAD{
    NSInteger _ADRestTime;
    dispatch_source_t _countDownTimer;
}

#pragma mark - initializers
- (instancetype)init {
    self = [super init];
    if (self) {
        _preferAdTime = kDefaultADTime;
        _logoHeight = mainWidth/3;
        
        _launchViewController = [[ZBLaunchViewController alloc] init];
        _launchViewController.view.backgroundColor = [UIColor blackColor];
        _adShowWindow = [[ZBLaunchADWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //设置启动屏广告盖住状态栏
        [_adShowWindow setWindowLevel:UIWindowLevelStatusBar+1];
        _adShowWindow.backgroundColor = [UIColor whiteColor];
        _adShowWindow.hidden = NO;
        _adShowWindow.dataSource = self;
        [_adShowWindow setRootViewController:_launchViewController];
    }
    return self;
}

+ (instancetype)adImageConfigWithADImgURL:(NSURL *)imgUrl
                            handlerBlock:(ZBLaunchADHandlerBlock)handler{
    ZBLaunchAD *launchAD = [[ZBLaunchAD alloc] init];
    launchAD.adShowType = ZBLaunchADTypeFullScreen;
    launchAD.adImageURL = imgUrl;
    launchAD.handlerBlock = handler;
    return launchAD;
}

+ (instancetype)adImageConfigWithADImgURL:(NSURL *)imgUrl
                               logoImage:(UIImage*)logo
                            handlerBlock:(ZBLaunchADHandlerBlock)handler{
    ZBLaunchAD *launchAD = [[ZBLaunchAD alloc] init];
    launchAD.adShowType = ZBLaunchADTypeWithLogo;
    launchAD.adImageURL = imgUrl;
    launchAD.logoImage = logo;
    launchAD.handlerBlock = handler;
    return launchAD;
}

- (void)adViewShouldDismissWithType:(ZBLaunchADCallBackType)callBackType sender:(id)sender{
    if (self.handlerBlock) {
        self.handlerBlock(callBackType);
    }
    [self stopTimer];
    [self.adShowWindow closeAnimation];
}

- (void)showADView{
    _ADRestTime = _preferAdTime;
    [self.adShowWindow setupSubViews:self.adShowType];
    if (self.adShowType && self.logoImage) {
        [self.adShowWindow.logoImageView setImage:self.logoImage];
    }
    _adShowWindow.hidden = NO;
    [_adShowWindow openAnimation];
    
    if (!_countDownTimer) {
        _countDownTimer = CreateDispatchTimer(1.0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(_ADRestTime<=0){
                //倒计时结束，关闭
                dispatch_async(dispatch_get_main_queue(), ^{
                    //展示广告结束，移除广告
                    [self.adShowWindow adEndShowAction];
                });
            }else{
                //每秒设置跳过
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.adShowWindow.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_ADRestTime--)] forState:UIControlStateNormal];
                });
            }
        });
    }
    dispatch_resume(_countDownTimer);
    
    if (_adImageURL) {
        /*下载图片*/
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:_adImageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [self.adShowWindow.adImageView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
            }
        }];
    }
}

- (void)removeADView {
    [self stopTimer];
    [self.adShowWindow closeAnimation];
}

- (void)dealloc {
    self.adShowWindow = nil;
    self.launchViewController = nil;
}

#pragma mark - setters
- (void)setLaunchView:(UIView *)launchView {
    if (_launchView != launchView) {
        _launchView = launchView;
        [self.launchViewController setContainerView:launchView];
    }
}
- (void)setLogoImage:(UIImage *)logoImage {
    if (_logoImage != logoImage) {
        _logoImage = logoImage;
    }
//    if (!_logoImage) {
//        _adShowType = ZBLaunchADTypeFullScreen;
//    }else{
//        _adShowType = ZBLaunchADTypeWithLogo;
//    }
}

#pragma mark - timer methods
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval*NSEC_PER_SEC, leeway);
        dispatch_source_set_event_handler(timer, block);
    }
    return timer;
}

- (void)stopTimer {
    if (_countDownTimer) {
        dispatch_source_cancel(_countDownTimer);
    }
    _countDownTimer = nil; // OK
}

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
