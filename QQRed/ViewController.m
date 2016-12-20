//
//  ViewController.m
//  QQRed
//
//  Created by Jion on 2016/12/12.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DragBlast.h"
#import "TableViewController.h"

//设置最大偏移距离为当前空间的倍数
#define MAXDistance 4

@interface ViewController ()
{
    UIView *circle2;
}
@property(nonatomic,assign)CGPoint           remindPoint;
@property(nonatomic,strong)UIView           *circle1;
@property(nonatomic,strong)CAShapeLayer     *shapeLayer;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     //self.edgesForExtendedLayout =  UIRectEdgeNone;
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"点击或拖拽1爆炸，并跳转到下个界面。";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 64, 300, 50);
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:@"点击这里重新开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(resetSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
   __block UILabel *redView = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 20, 20)];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = redView.bounds.size.height/2;
    redView.layer.masksToBounds = YES;
    redView.textAlignment = NSTextAlignmentCenter;
    redView.font = [UIFont systemFontOfSize:12];
    redView.textColor = [UIColor whiteColor];
    redView.text = @"1";
    redView.tag = 110;
    redView.tapBlast = YES;
    redView.isFragment = YES;
    [redView blastCompletion:^(BOOL finished) {
        TableViewController *table = [[TableViewController alloc] init];
        
        [self.navigationController pushViewController:table animated:YES];
        
    }];
    [self.view addSubview:redView];
    
    [self testDrag];
}

-(void)testDrag{
    
    circle2 = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 20, 20)];
    circle2.backgroundColor = [UIColor redColor];
    circle2.layer.cornerRadius = 10;
    [self.view addSubview:circle2];
    
    self.circle1 = [[UIView alloc] init];
    self.circle1.backgroundColor = circle2.backgroundColor;
    self.circle1.center = circle2.center;
    self.circle1.bounds = circle2.bounds;
    self.circle1.layer.cornerRadius = circle2.layer.cornerRadius;
    self.circle1.layer.masksToBounds = circle2.layer.masksToBounds;
    self.circle1.hidden = YES;
    [self.view insertSubview:self.circle1 belowSubview:circle2];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanAction:)];
    [circle2 addGestureRecognizer:panGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blastAction:)];
    [circle2 addGestureRecognizer:tapGR];
    
    _remindPoint = CGPointMake(0, 0);
}

-(void)resetSetting:(UIButton*)sender{
    UIView *redView = [self.view viewWithTag:110];
    redView.hidden = NO;
}

-(void)blastAction:(UITapGestureRecognizer*)tap{
    tap.view.hidden = YES;
    self.circle1.hidden = YES;
    //爆炸效果
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:tap.view.frame];
    imageView.contentMode = UIViewContentModeCenter;
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 1 ; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"unreadBomb_%d",i]];
        [imageArr addObject:image];
    }
    imageView.animationImages = imageArr;
    imageView.animationDuration = 0.5;
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];
    [self.view addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tap.view.hidden = NO;
    });
}

-(void)dragPanAction:(UIPanGestureRecognizer*)pan{
    
    if (_remindPoint.x == 0 && _remindPoint.y == 0) {
        _remindPoint = pan.view.center;
    }
    
    self.circle1.hidden = NO;
    
    //拖动
    CGPoint translation = [pan translationInView:self.view];
    CGPoint newCenter = CGPointMake(pan.view.center.x+ translation.x,
                                    pan.view.center.y + translation.y);
    newCenter.y = MAX(pan.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.view.frame.size.height - pan.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.view.frame.size.width - pan.view.frame.size.width/2,newCenter.x);
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:self.view];
    
    /*
     //拖动和上面的代码一样
    CGPoint newCenter = [pan locationInView:self.view];
    newCenter = [pan.view convertPoint:p toView:self.view];
    pan.view.center= newCenter;
    */
    
    //  设置circle1变化的值
    CGFloat cirDistance = [self distanceWithPointA:self.circle1.center andPointB:circle2.center];
    CGFloat scale = 1- cirDistance/(MAXDistance*circle2.bounds.size.height);
    if (scale < 0.2) {
        scale = 0.2;
    }
    self.circle1.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat  fx = fabs(_remindPoint.x- newCenter.x);
    CGFloat  fy = fabs(_remindPoint.y- newCenter.y);
    if (fx>MAXDistance*circle2.bounds.size.height || fy>MAXDistance*circle2.bounds.size.height) {
        self.shapeLayer.path = nil;
        self.circle1.hidden = YES;
    }else{
        self.circle1.hidden = NO;
        [self reloadBeziePath];
    }
    
    if (pan.state == UIGestureRecognizerStateRecognized) {
        CGFloat  fx = fabs(_remindPoint.x- newCenter.x);
        CGFloat  fy = fabs(_remindPoint.y- newCenter.y);
        if (fx>MAXDistance*circle2.bounds.size.height || fy>MAXDistance*circle2.bounds.size.height) {
            [self boomCells:pan.view.center];
            /*
            NSInteger k = arc4random()%2;
            if (k==1) {
                //位图移动
                [self boomCells:pan.view.center];
            }else{
                //粒子束运动
                [self boom:pan.view];
            }
            */
        }else{
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                circle2.center = self.circle1.center;
            } completion:^(BOOL finished) {
                self.circle1.hidden = NO;
            }];
            
        }
        
    }
   
}
#pragma mark - 获取圆心距离
- (CGFloat)distanceWithPointA:(CGPoint)pointA  andPointB:(CGPoint)pointB{
    CGFloat offSetX = pointA.x - pointB.x;
    CGFloat offSetY = pointA.y - pointB.y;
    return sqrt(offSetX*offSetX + offSetY*offSetY);
}

#pragma mark - 绘制贝塞尔图形
- (void) reloadBeziePath {
    CGFloat r1 = self.circle1.frame.size.width / 2.0f;
    CGFloat r2 = circle2.frame.size.width / 2.0f;
    
    CGFloat x1 = self.circle1.center.x;
    CGFloat y1 = self.circle1.center.y;
    CGFloat x2 = circle2.center.x;
    CGFloat y2 = circle2.center.y;
    
    CGFloat distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    CGPoint pointP = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    CGPoint pointO = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: pointA];
    [path addLineToPoint: pointB];
    [path addQuadCurveToPoint: pointC controlPoint: pointP];
    [path addLineToPoint: pointD];
    [path addQuadCurveToPoint: pointA controlPoint: pointO];
    
    self.shapeLayer.path = path.CGPath;
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = circle2.backgroundColor.CGColor;
        [self.view.layer insertSublayer:shapeLayer below:self.circle1.layer];
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;
}

#pragma mark - 粒子添加及动画
-(void)boomCells:(CGPoint)point{
    NSInteger rowClocn = 3;
    NSMutableArray *boomCells = [NSMutableArray array];
    for (int i = 0; i < rowClocn*rowClocn; ++ i) {
        CGFloat pw = MIN(circle2.frame.size.width, circle2.frame.size.height);
        CALayer *shape = [CALayer layer];
        shape.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
        shape.cornerRadius = pw / 2;
        //shape.frame = CGRectMake((i/rowClocn) * pw, (i%rowClocn) * pw, pw, pw);
        shape.frame = CGRectMake(0, 0, pw, pw);
        [circle2.layer.superlayer addSublayer: shape];
        [boomCells addObject: shape];
    }
    circle2.hidden = YES;
    [self cellAnimation:boomCells];
}
- (void) cellAnimation:(NSArray*)cells {
    
    for (NSInteger j=0; j<cells.count;j++) {
        CALayer *shape = cells[j];
        shape.position = circle2.center;
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = @0.5;
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        pathAnimation.path = [self makeRandomPath: shape AngleTransformation:j].CGPath;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        animationGroup.animations = @[scaleAnimation,pathAnimation,];
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.duration = 0.5;
        animationGroup.removedOnCompletion = NO;
        animationGroup.repeatCount = 1;
        
        [shape addAnimation: animationGroup forKey: @"animationGroup"];
        [self performSelector:@selector(removeLayer:) withObject:shape afterDelay:animationGroup.duration];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        circle2.hidden = NO;
    });
    
}
-(void)removeLayer:(CALayer*)layer{
    [layer removeFromSuperlayer];
}
#pragma mark - 设置碎片路径
- (UIBezierPath *) makeRandomPath: (CALayer *) alayer AngleTransformation:(CGFloat)index{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:circle2.center];
    CGFloat dia = circle2.frame.size.width;
    if (index>0) {
        CGFloat angle = index*45*M_PI*2/360;
        CGFloat x = dia*cosf(angle);
        CGFloat y = dia*sinf(angle);
        [path addLineToPoint:CGPointMake(circle2.center.x + x, circle2.center.y+y)];
    }else{
        [path addLineToPoint:CGPointMake(circle2.center.x, circle2.center.y)];
    }
    
    return path;
}

#pragma mark -- 粒子发射
-(void)boom:(UIView*)view{
    //生成粒子发射器
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = view.bounds;
    [view.layer addSublayer:emitter];
    
    //配置发射器
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterMode = kCAEmitterLayerSurface;
    //发射位置
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);

    
    CALayer *shape = [CALayer layer];
    shape.bounds = view.bounds;
    shape.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    shape.cornerRadius = view.bounds.size.height / 2;
    //生成粒子资源
    CGSize size = CGSizeMake(view.bounds.size.width, view.bounds.size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shape renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //创建粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    //设置粒子资源内容是CGImageRef格式
    cell.contents = (__bridge id)img.CGImage;
    //每秒生产的离子数
    cell.birthRate = 150;
    //离子的生命周期
    cell.lifetime = 0.3;
    cell.color = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    //速度和范围
    cell.velocity = 50;
    cell.velocityRange = img.size.height*2;
    //粒子的辐射范围
    cell.emissionRange = M_PI * 2.0;
    
    //添加粒子
    emitter.emitterCells = @[cell];
    [self performSelector:@selector(removeLayer:) withObject:emitter afterDelay:cell.lifetime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
