//
//  TableViewCell.h
//  QQRed
//
//  Created by Jion on 2016/12/15.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end
