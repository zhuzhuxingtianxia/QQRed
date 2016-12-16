//
//  SearchResurltView.m
//  AutomobileAccessories
//
//  Created by JA on 2016/12/15.
//  Copyright © 2016年 sensu_nikun. All rights reserved.
//

#import "SearchResurltView.h"
#import "JATagView.h"
#define tagViewHeight 50.f

@interface SearchResurltView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *sureBtn;//确定按钮
@property (nonatomic,strong)UIScrollView *tagScrollView;//选择的标签所在的scroll
@property (nonatomic,strong)NSMutableArray *dataArry;//数据源
//@property (nonatomic,strong)NSMutableDictionary *selectTagDic;//选择的标签
@property (nonatomic,assign)CGSize curentContentSize;
@end
@implementation SearchResurltView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createArryAndDic];
        [self createBaseView];
    }
    return self;
}
//创建view
- (void)createBaseView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.sureBtn];
    [self.bottomView addSubview:self.tagScrollView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*
    [self removeFromSuperview];
    self.dimiss();
     */
}
#pragma mark -
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text =self.dataArry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectTagStr = self.dataArry[indexPath.row];
    [self showTagOnScrollView:selectTagStr];
}
#pragma mark -标签的显示与删除
//显示标签在scroll上
- (void)showTagOnScrollView:(NSString *)tagStr
{
    //底部确定按钮向下移动，显示出选择的标签
    __block CGRect botomRect = self.bottomView.frame;
    __block CGRect sureBtnRect = self.sureBtn.frame;
    if (botomRect.size.height == 50) {
        [UIView animateWithDuration:0.3 animations:^{
            botomRect.size.height = botomRect.size.height + tagViewHeight;
            sureBtnRect.origin.y =  sureBtnRect.origin.y + tagViewHeight;
            self.bottomView.frame = botomRect;
            self.sureBtn.frame = sureBtnRect;
        } completion:^(BOOL finished) {
            self.tagScrollView.hidden = NO;
            
            
        }];
    }
    
    //显示/删除 标签
    [self showAndDeleteTagWithTagstr:tagStr];
    
}
- (void)showAndDeleteTagWithTagstr:(NSString *)tagStr
{
    //创建要显示的标签
    CGRect scrollRect = self.tagScrollView.frame;
    CGFloat space = 8;
    CGFloat tagViewH = 30;
    CGFloat tagViewW = 130;
    //找出scroll上面最后一个tagview
    JATagView *afterView = nil;
    for (UIView *view in self.tagScrollView.subviews) {
        if ([view isKindOfClass:[JATagView class]]) {
            afterView = (JATagView *)view;
        }
    }
    CGFloat leftSpace = 12;
    CGFloat x = leftSpace;
    if (afterView) {
        x = CGRectGetMaxX(afterView.frame) + space;
    }
    JATagView *tagView = [[JATagView alloc] initWithFrame:CGRectMake(x, (scrollRect.size.height - tagViewH)/2.f, tagViewW, tagViewH) withTagType:JATagViewDelete];
    tagView.backgroundColor = [UIColor whiteColor];
    tagView.tagString = tagStr;
 
    
    //设置tagScrollView 的相关属性
    [self.tagScrollView addSubview:tagView];
    CGSize contentSize = self.tagScrollView.contentSize;
    CGFloat maxX = CGRectGetMaxX(tagView.frame) + leftSpace;//多加12（距离右边的距离）
    if (maxX > contentSize.width) {
        contentSize.width = maxX;
        self.tagScrollView.contentSize = contentSize;
        [self.tagScrollView setContentOffset:CGPointMake(contentSize.width-self.tagScrollView.frame.size.width, 0) animated:YES];
    }
    //删除标签
    
    [tagView deleteTagBlock:^{
        NSMutableArray *moveLefts = [[NSMutableArray alloc] init];
        JATagView *lastTagView = nil;
        for (int i = 0; i < self.tagScrollView.subviews.count; i ++) {
            UIView *view = self.tagScrollView.subviews[i];
            if (![view isKindOfClass:[JATagView class]]) {
                continue;
            }
            if ([view isEqual:tagView]) {//找到当前要删除的tagView，并把后面的viewX坐标向前移动
                tagView.hidden = YES;//此时tagView还没有被移除，所以先隐藏掉
                
            }
            if (tagView.isHidden) {
                [moveLefts addObject:view];
            }
            lastTagView = (JATagView *)view;
        }
       
      
       
        //把所有需要移动的view，整体向左边移动
        [UIView animateWithDuration:.3 animations:^{
            for (JATagView *view in moveLefts) {
                CGRect rect = view.frame;
                rect.origin.x -= (tagView.frame.size.width + space);
                view.frame = rect;
            }
        } completion:^(BOOL finished) {
            if (lastTagView) {
                CGSize contentSize = self.tagScrollView.contentSize;
                CGFloat maxX = CGRectGetMaxX(lastTagView.frame) + leftSpace;//多加12（距离右边的距离）
                if (maxX>375) {
                    contentSize.width = maxX;
                }else{
                    contentSize.width = 375;
                }
               
                _curentContentSize = contentSize;
                self.tagScrollView.contentSize = _curentContentSize;
//
//                [self performSelector:@selector(afterSetContentSize) withObject:nil afterDelay:1];
            
//                if (_curentContentSize.width - self.tagScrollView.frame.size.width < self.tagScrollView.contentOffset.x) {
//                    NSLog(@"a =%f 偏移量b=%f", _curentContentSize.width - self.tagScrollView.frame.size.width,self.tagScrollView.contentOffset.x);
//                    [self.tagScrollView setContentOffset:CGPointMake(self.tagScrollView.contentOffset.x -(_curentContentSize.width - self.tagScrollView.frame.size.width), 0) animated:YES];
//                    
//                }
            }
        }];
       
        
    }];
    
}
//延迟设置contentSize 使动画更加自然
- (void)afterSetContentSize{
    
         self.tagScrollView.contentSize = _curentContentSize;
        
    
    
}
#pragma mark -
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewOff =%f",scrollView.contentOffset.x);
}

#pragma mark -
#pragma mark - 按钮action
- (void)sureBtnAction
{
    
   
   
}
#pragma mark -
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.frame;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 200) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        CGRect rect = self.frame;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), rect.size.width, 50)];
        _bottomView.backgroundColor = [UIColor blueColor];
    }
    return _bottomView;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        CGFloat height = 42;
        CGRect bottomRect = self.bottomView.frame;
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(20, (bottomRect.size.height - height)/2.f, bottomRect.size.width - 20*2, height);
        [_sureBtn setTitle:@"确定" forState:0];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        _sureBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _sureBtn.layer.cornerRadius = 2.5f;
        _sureBtn.layer.borderColor = [UIColor clearColor].CGColor;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIScrollView *)tagScrollView
{
    if (!_tagScrollView) {
        _tagScrollView = [[UIScrollView alloc] init];
        _tagScrollView.showsVerticalScrollIndicator = NO;
        _tagScrollView.showsHorizontalScrollIndicator = NO;
        _tagScrollView.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, tagViewHeight);
        _tagScrollView.backgroundColor = [UIColor clearColor];
        _tagScrollView.hidden = YES;
        _tagScrollView.contentSize = CGSizeMake(_tagScrollView.frame.size.width, tagViewHeight);
        _tagScrollView.delegate = self;
    }
    return _tagScrollView;
}

- (void)createArryAndDic
{
    
    self.dataArry = [[NSMutableArray alloc] init];
    //做些假数据
    for (int i = 0; i < 10; i ++) {
        [_dataArry addObject:[NSString stringWithFormat:@"标签🏷%zd",i]];
    }
    /*创建选择的标签字典*/
//    self.selectTagDic = [[NSMutableDictionary alloc] init];
    
}
- (void)dimiss:(dimissSelf)dimiss
{
    _dimiss = dimiss;
}
@end
