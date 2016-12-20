//
//  UIView+DragBlast.h
//  QQRed
//
//  Created by Jion on 2016/12/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DragBlast)
//是否使用粒子动画 
@property(nonatomic,assign)BOOL  isFragment;
//点击爆炸  默认为NO
@property(nonatomic,assign)BOOL  tapBlast;
//拖拽爆炸  默认为NO
@property(nonatomic,assign)BOOL  dragBlast;

//拖动爆炸或点击爆炸后的回调
-(void)blastCompletion:(void (^)(BOOL finished))completion;

@end
