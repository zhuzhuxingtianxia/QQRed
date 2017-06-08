//
//  TableViewCell.m
//  QQRed
//
//  Created by Jion on 2016/12/15.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "TableViewCell.h"
#import "UIView+DragBlast.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.messageBtn.layer.cornerRadius = self.messageBtn.bounds.size.height/2;
    self.messageBtn.layer.masksToBounds = YES;
    self.messageBtn.tapBlast = YES;
    self.messageBtn.dragBlast = YES;
    
    [self.messageBtn addTarget:self action:@selector(transformScal:) forControlEvents:UIControlEventTouchDown];
    
    self.messageLable.layer.cornerRadius = self.messageLable.bounds.size.height/2;
    self.messageLable.layer.masksToBounds = YES;
    self.messageLable.tapBlast = YES;
    self.messageLable.dragBlast = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)transformScal:(UIButton*)sender{
    sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    //做阻尼震动
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = [UIColor clearColor];
        } completion:nil];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(62, rect.size.height - 0.5, rect.size.width, 0.5));
}

@end
