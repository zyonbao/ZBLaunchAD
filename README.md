# ZBLaunchAD
ZBLaunchAD 是一个便捷的启动屏广告类
--------------------
使用时，仅需要执行

> [ZBLaunchAD adImageConfigWithADImgURL:imgURL
                            handlerBlock:handlerBlock];

或
> [ZBLaunchAD adImageConfigWithADImgURL: imgURL
                               logoImage:logoImage
                            handlerBlock:handlerBlock];
 
 即可进行初始化。
 
 使用
 
 > \-(void)showADView;
 
 来展示广告。
 
 > \-(void)removeADView;                           
 
来移除广告

可以在回调方法 `handlerBlock` 中处理点击回调。

PS: 该代码依赖于 `SDWebImage`