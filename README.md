# QQRed
 demo环境Xcode8.0以上
## demo讲解地址 
<a href = "http://www.jianshu.com/p/8d142fb7b983"> 简书：ios仿QQ消息拖拽效果</a>
## demo效果展示
![image](https://github.com/873391579/QQRed/blob/master/%E5%BD%95%E5%B1%8F1.gif)


## 使用：
在文件里找到DragBlast文件夹，然后把该文件夹拖到你的工程中
### 然后导入 <#import "UIView+DragBlast.h"> 给对应View设置定义的属性或方法就可以了！
例如：<br>
###
    //设置点击就能爆炸，如果不需要可以不设置，这个点击事件没有设置回调方法  
      view.tapBlast = YES; 
     //设置使用绘制的爆炸效果，但是这个效果并不理想，建议不要设置这个属性 
     // view.isFragment = YES;
    /*
      设置拖拽爆炸，如果爆炸后不需要做操作
      则可使用view.dragBlast = YES;
      若爆炸后需要做一些处理，则可使用下面的block方法。
    */
     [view blastCompletion:^(BOOL finished) {
        //do something  
    }];


