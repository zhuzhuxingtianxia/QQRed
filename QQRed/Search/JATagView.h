//
//  JATagView.h
//  StudyDemo
//
//  Created by z on 2016/12/14.
//  Copyright © 2016年 ja. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    JATagViewDefault =0,//默认是不带有删除按钮
    JATagViewDelete,//有删除按钮
    //...以后再补充
};
typedef NSUInteger JATagViewType;
typedef void(^deleteTagBlock)(void);
@interface JATagView : UIView
@property (nonatomic,strong)NSString *tagString;
@property (nonatomic,strong)deleteTagBlock deleteTag;
- (instancetype)initWithFrame:(CGRect)frame withTagType:(JATagViewType)type;
- (void)deleteTagBlock:(deleteTagBlock)deleteTag;
@end
