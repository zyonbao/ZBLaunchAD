//
//  ZBLaunchAD.h
//  zb_launch_img_ad
//
//  Created by zyon on 08/04/2017.
//  Copyright © 2017 zyonbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBLaunchADType) {
    ZBLaunchADTypeFullScreen = 0,//全屏广告
    ZBLaunchADTypeWithLogo//底部带logo的广告
};

typedef NS_ENUM(NSInteger, ZBLaunchADCallBackType) {
    ZBLaunchADCallBackTypeBtnSkip = 0,//点击跳过按钮
    ZBLaunchADCallBackTypeADClick,//点击广告
    ZBLaunchADCallBackTypeEndShow//广告展示结束
};

typedef void (^ZBLaunchADHandlerBlock)(ZBLaunchADCallBackType callBackType);

@interface ZBLaunchAD : NSObject

@property (nonatomic, strong) NSURL *adImageURL;//广告图片的url
@property (nonatomic, strong) UIImage *logoImage;//logo的image
@property (nonatomic, assign) ZBLaunchADType adShowType;//广告展示类型
@property (nonatomic, assign) NSInteger preferAdTime;//预期展示时间
@property (nonatomic, assign) CGFloat logoHeight;//logo的高度，仅当展示类型为logo时生效
@property (nonatomic, copy) UIView *launchView;//用来设置启动图的背景 1.launchImage 2.launchScreen.xib 3.launchSreen.storyboard
@property (nonatomic, copy) ZBLaunchADHandlerBlock handlerBlock;

+(instancetype)adImageConfigWithADImgURL:(NSURL *)imgUrl
                            handlerBlock:(ZBLaunchADHandlerBlock)handler;

+(instancetype)adImageConfigWithADImgURL:(NSURL *)imgUrl
                               logoImage:(UIImage*)logo
                            handlerBlock:(ZBLaunchADHandlerBlock)handler;
- (void)showADView;
- (void)removeADView;

@end
