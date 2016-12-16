//
//  SearchResurltView.h
//  AutomobileAccessories
//
//  Created by z on 2016/12/15.
//  Copyright © 2016年 sensu_nikun. All rights reserved.
/*
 #import "SearchResurltView.h"
 
 SearchResurltView *search = [[SearchResurltView alloc] initWithFrame:CGRectMake(0, 364, 375, 300)];
 [self.view addSubview:search];

 */

#import <UIKit/UIKit.h>
typedef void(^dimissSelf)();
@interface SearchResurltView : UIView
@property (nonatomic,copy)dimissSelf dimiss;
- (void)dimiss:(dimissSelf)dimiss;
@end
