//
//  DetailViewController.m
//  QQRed
//
//  Created by Jion on 2016/12/21.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "DetailViewController.h"
#import "UIView+DragBlast.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"猪猪行天下";
    
    [self buildView];
}

-(void)buildView {
    NSString *title = @"200";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.center = self.view.center;
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    CGFloat aWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size.width;
    btn.bounds = CGRectMake(0, 0, aWidth+10, 20);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.tapBlast = YES;
    [btn blastCompletion:^(BOOL finished) {
        NSLog(@"拖拽事件");
    }];
    [self.view addSubview:btn];
}

-(void)btnAction:(id)sender{
    NSLog(@"点击事件");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
