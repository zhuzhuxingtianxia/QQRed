//
//  JATagView.m
//  StudyDemo
//
//  Created by z on 2016/12/14.
//  Copyright © 2016年 ja. All rights reserved.
//

#import "JATagView.h"
@interface JATagView()
{

}
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,assign)JATagViewType currentType;
@end
@implementation JATagView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBaseView:JATagViewDefault];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withTagType:(JATagViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBaseView:type];
    }
    return self;
}
- (void)createBaseView:(JATagViewType)type
{
    self.currentType = type;
    [self addSubview:self.label];
    if (type == JATagViewDefault) {
        
    }else if (type == JATagViewDelete){
        [self addSubview:self.deleteBtn];
    }
    
    
    
    [self reinstallFrme];

}
- (void)setTagString:(NSString *)tagString
{
    _tagString = tagString;
    self.label.text = tagString;
    [self reinstallFrme];
    
}
- (void)reinstallFrme
{

    /*设置圆角*/
    CGRect rect = self.frame;
    CGFloat cornerRadius = rect.size.height / 2.0;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = YES;
    
  
    CGFloat lableW = rect.size.width - 2*cornerRadius;
    CGFloat deleteW = 15;
    self.deleteBtn.frame = CGRectMake(rect.size.width - deleteW - cornerRadius, (rect.size.height - deleteW)/2, deleteW, deleteW);
    
    if (self.currentType == JATagViewDelete) {
        lableW -= deleteW;
    }
    self.label.frame = CGRectMake(cornerRadius, 0, lableW, rect.size.height);
}
#pragma mark - 创建视图
- (UILabel *)label
{
    if (!_label) {
        CGRect rect = self.frame;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.height/2, 0, rect.size.width - (rect.size.height/2)*2, rect.size.height)];
        _label.numberOfLines = 1;
        _label.textAlignment = 1;
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:14.f];
        
    }
    return _label;
}
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
//删除
- (void)deleteBtnAction
{
    self.deleteTag();
    [self removeFromSuperview];
   
}
- (void)deleteTagBlock:(deleteTagBlock)deleteTag
{
    _deleteTag = deleteTag;
}
//- (CGFloat)getLabelHeight:(NSString *)content labelWidth:(CGFloat)contentW font:(UIFont *)fnt
//{
//    // 宽度W
//    // label的字体 HelveticaNeue  Courier
//    
//    // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
//    if (!content) {
//        content = @"";
//    }
//    CGRect tmpRect = [content boundingRectWithSize:CGSizeMake(contentW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
//    
//    // 高度H
//    CGFloat contentH = tmpRect.size.height;
//    return contentH;
//}
@end
