//
//  ViewController.m
//  download_animation
//
//  Created by ximdefangzh on 16/8/7.
//  Copyright © 2016年 ximdefangzh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak,nonatomic) UIView *roundView;
@end

@implementation ViewController{
    CGRect originframe;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:64.0/255.0 alpha:1];
    UIView *roundView = [[UIView alloc] init];
    roundView.bounds = CGRectMake(0, 0, 100, 100);
    roundView.center = self.view.center;
    roundView.backgroundColor = [UIColor greenColor];
    roundView.layer.cornerRadius = 50;
    roundView.layer.masksToBounds = YES;
    [self.view addSubview:roundView];
    _roundView = roundView;
    
    originframe = _roundView.frame;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapAction:(UITapGestureRecognizer *)recognizer{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    _roundView.layer.cornerRadius = 20;
    anim.duration = 1;
    anim.delegate = self;
    anim.fromValue = @(_roundView.bounds.size.width/2);
    anim.toValue = @(20);
    [_roundView.layer addAnimation:anim forKey:@"corner"];
}
-(void)animationDidStart:(CAAnimation *)anim{
    if([anim isEqual:[_roundView.layer animationForKey:@"corner"]]){
//        [UIView animateWithDuration:0.6 animations:^{
//            _roundView.bounds = CGRectMake(0, 0, 300, 40);
//        }];
        //弹性效果
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
             _roundView.bounds = CGRectMake(0, 0, 300, 40);
        } completion:^(BOOL finished) {
            [_roundView.layer removeAllAnimations];
            [self progressBarAnimation];
        }];
    }
    if([anim isEqual:[_roundView.layer animationForKey:@"corner_back"]]){
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _roundView.bounds = CGRectMake(0, 0, originframe.size.width, originframe.size.height);
            _roundView.layer.backgroundColor = [UIColor colorWithRed:116.0/255.0 green:255.0/255.0 blue:207.0/255.0 alpha:1].CGColor;
        } completion:^(BOOL finished) {
            [_roundView.layer removeAllAnimations];
            [self setCheckAnimation];
        }];
    }
//    if([[anim valueForKey:@"animationName"] isEqualToString:@"checkAnimation"]){
//        UIView animateWithDuration:<#(NSTimeInterval)#> animations:<#^(void)animations#>
//    }
}
-(void)setCheckAnimation{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [_roundView.layer addSublayer:shapeLayer];
    //画一个内切于当前圆的正方形
    CGRect rect = CGRectInset(_roundView.bounds, _roundView.bounds.size.width/2*(1-1/sqrt(2)), _roundView.bounds.size.width/2*(1-1/sqrt(2)));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width/5, rect.origin.y + rect.size.height/5*3)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/9*8)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/6*5, rect.origin.y + rect.size.height/3)];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 10;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 1;
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.delegate = self;
    [anim setValue:@"checkAnimation" forKey:@"animationName"];
    [shapeLayer addAnimation:anim forKey:nil];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([[anim valueForKey:@"animationName"] isEqualToString:@"progressBar"]){
        [UIView animateWithDuration:0.3 animations:^{
           [_roundView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               obj.opacity = 0;
           }];
        }completion:^(BOOL finished) {
            [_roundView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperlayer];
            }];
        }];
        _roundView.layer.cornerRadius = originframe.size.width/2;
//        _roundView.layer.backgroundColor = [UIColor greenColor].CGColor;
        CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerAnim.fromValue = @(20);
        cornerAnim.duration = 1;
        cornerAnim.delegate = self;
        [_roundView.layer addAnimation:cornerAnim forKey:@"corner_back"];
        
    }
    if([[anim valueForKey:@"animationName"] isEqualToString:@"checkAnimation"]){
        
        [UIView animateWithDuration:4 animations:^{
            _roundView.layer.backgroundColor = [UIColor greenColor].CGColor;
        } completion:^(BOOL finished) {
            [_roundView.layer removeAllAnimations];
            [UIView animateWithDuration:0.5 animations:^{
                [_roundView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.opacity = 0;
                }];
            }completion:^(BOOL finished) {
                [_roundView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperlayer];
                }];
            }];
        }];
    }
}
- (void)progressBarAnimation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
//    CGPoint frameP = _roundView.frame.origin;
    CGSize size = _roundView.bounds.size;
    [path moveToPoint:CGPointMake(size.height/2, size.height/2)];
    [path addLineToPoint:CGPointMake(size.width - size.height/2, size.height/2)];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = size.height-10;
    shapeLayer.lineCap = kCALineCapRound;
    [_roundView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 2;
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.delegate = self;
    [anim setValue:@"progressBar" forKey:@"animationName"];
    [shapeLayer addAnimation:anim forKey:nil];
}

@end
