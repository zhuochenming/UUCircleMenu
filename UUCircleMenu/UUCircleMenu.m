//
//  UUCircleMenu.m
//  UUCircleMenu
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UUCircleMenu.h"

//按钮个数
static NSInteger kButtonCount;
//按钮大小
static CGFloat kMenuSize, kCenterButtonSize;
//按钮frame
static CGRect kButtonOriginRect;

static CGFloat kDefaultTriangleHypotenuse, kMaxTriangleHypotenuse;



@interface UUCircleMenu ()

@property (nonatomic, copy) void(^CallBackBlock)(NSInteger index);

@end



@implementation UUCircleMenu

- (instancetype)initWithTop:(CGFloat)top
                buttonCount:(NSInteger)buttonCount
                   menuSize:(CGFloat)menuSize
                 buttonSize:(CGFloat)buttonSize
      buttonImageNameFormat:(NSString *)buttonImageNameFormat
           centerButtonSize:(CGFloat)centerButtonSize
      centerButtonImageName:(NSString *)centerButtonImageName
                   callBack:(void(^)(NSInteger index))block {
    if (self = [super init]) {
        CGRect allFrame = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, top, CGRectGetWidth(allFrame), CGRectGetHeight(allFrame) - top);
        CGFloat viewWidth  = CGRectGetWidth(self.frame);
        CGFloat viewHeight = CGRectGetHeight(self.frame);
        
        
        kButtonCount = buttonCount;
        kMenuSize = menuSize;
        kCenterButtonSize = centerButtonSize;
        
        kDefaultTriangleHypotenuse = (menuSize - buttonSize) * 0.5;
        kMaxTriangleHypotenuse = CGRectGetHeight(allFrame) * 0.5;
        
        CGFloat originX = (menuSize - centerButtonSize) * 0.5;
        kButtonOriginRect = CGRectMake(originX, originX, centerButtonSize, centerButtonSize);
        
        self.isOpening = NO;

        // Center Menu View
        CGRect centerMenuFrame = CGRectMake((viewWidth - menuSize) * 0.5, (viewHeight - menuSize) * 0.5, menuSize, menuSize);
        self.menuView = [[UIView alloc] initWithFrame:centerMenuFrame];
        self.menuView.alpha = 0;
        [self addSubview:_menuView];
        
        //围绕按钮
        NSString * imageName = nil;
        for (int i = 1; i <= buttonCount; ++i) {
            UIButton * button = [[UIButton alloc] initWithFrame:kButtonOriginRect];
            button.opaque = NO;
            button.tag = 500 + i;
            imageName = [NSString stringWithFormat:@"%@%d", buttonImageNameFormat, i];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(otherButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self.menuView addSubview:button];
        }
        
        //中心按钮
        CGRect mainButtonFrame = CGRectMake((CGRectGetWidth(self.frame) - centerButtonSize) * 0.5, (CGRectGetHeight(self.frame) - centerButtonSize) * 0.5, centerButtonSize, centerButtonSize);
        self.centerButton = [[UIButton alloc] initWithFrame:mainButtonFrame];
        [self.centerButton setImage:[UIImage imageNamed:centerButtonImageName] forState:UIControlStateNormal];
        [self.centerButton addTarget:self action:@selector(centerButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerButton];
        
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAnimation:) name:kUUCircleMenuClose object:nil];
        
        self.CallBackBlock = block;
    }
    return self;
}

#pragma mark - 更新按钮位置
- (void)updateButtonsLayoutWithHypotenuse:(CGFloat)hypotenuse {
    CGFloat centerBallMenuHalfSize = kMenuSize * 0.5;
    CGFloat buttonRadius = kCenterButtonSize * 0.5;
    if (!hypotenuse) {
        hypotenuse = kDefaultTriangleHypotenuse;
    }
    
    switch (kButtonCount) {
        case 1:
            [self rotateButtonWithTag:501 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius, centerBallMenuHalfSize - hypotenuse - buttonRadius)];
            break;
        case 2: {
            CGFloat degree = M_PI / 4.0;
            CGFloat triangleB = hypotenuse * sinf(degree);
            CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
            CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
            [self rotateButtonWithTag:501 origin:CGPointMake(negativeValue, negativeValue)];
            [self rotateButtonWithTag:502 origin:CGPointMake(positiveValue, negativeValue)];
            break;
        }
            
        case 3: {
            CGFloat degree = M_PI / 3.0;
            CGFloat triangleA = hypotenuse * cosf(degree);
            CGFloat triangleB = hypotenuse * sinf(degree);
            [self rotateButtonWithTag:501 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            [self rotateButtonWithTag:502 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            [self rotateButtonWithTag:503 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius, centerBallMenuHalfSize + hypotenuse - buttonRadius)];
            break;
        }
            
        case 4: {
            CGFloat degree = M_PI / 4.0;
            CGFloat triangleB = hypotenuse * sinf(degree);
            CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
            CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
            [self rotateButtonWithTag:501 origin:CGPointMake(negativeValue, negativeValue)];
            [self rotateButtonWithTag:502 origin:CGPointMake(positiveValue, negativeValue)];
            [self rotateButtonWithTag:503 origin:CGPointMake(negativeValue, positiveValue)];
            [self rotateButtonWithTag:504 origin:CGPointMake(positiveValue, positiveValue)];
            break;
        }
            
        case 5: {
            CGFloat degree = M_PI / 2.5;
            CGFloat triangleA = hypotenuse * cosf(degree);
            CGFloat triangleB = hypotenuse * sinf(degree);
            [self rotateButtonWithTag:501 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            [self rotateButtonWithTag:502 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius, centerBallMenuHalfSize - hypotenuse - buttonRadius)];
            [self rotateButtonWithTag:503 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            
            degree = M_PI / 5.0;
            triangleA = hypotenuse * cosf(degree);
            triangleB = hypotenuse * sinf(degree);
            [self rotateButtonWithTag:504 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius, centerBallMenuHalfSize + triangleA - buttonRadius)];
            [self rotateButtonWithTag:505 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius, centerBallMenuHalfSize + triangleA - buttonRadius)];
            break;
        }
            
        case 6: {
            CGFloat degree = M_PI / 3.0;
            CGFloat triangleA = hypotenuse * cosf(degree);
            CGFloat triangleB = hypotenuse * sinf(degree);
            [self rotateButtonWithTag:501 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            [self rotateButtonWithTag:502 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius, centerBallMenuHalfSize - hypotenuse - buttonRadius)];
            [self rotateButtonWithTag:503 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius, centerBallMenuHalfSize - triangleA - buttonRadius)];
            [self rotateButtonWithTag:504 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius, centerBallMenuHalfSize + triangleA - buttonRadius)];
            [self rotateButtonWithTag:505 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius, centerBallMenuHalfSize + hypotenuse - buttonRadius)];
            [self rotateButtonWithTag:506 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius, centerBallMenuHalfSize + triangleA - buttonRadius)];
            break;
        }
            
        default:
            break;
    }
}
- (void)rotateButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin {
    UIButton *button = (UIButton *)[self.menuView viewWithTag:buttonTag];
    button.frame = CGRectMake(origin.x, origin.y, kCenterButtonSize, kCenterButtonSize);
    button = nil;
}

#pragma mark - 打开按钮动画
- (void)openAnimation {
    if (_isOpening) {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuView.alpha = 1.0;
        [self updateButtonsLayoutWithHypotenuse:kDefaultTriangleHypotenuse + 12.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateButtonsLayoutWithHypotenuse:kDefaultTriangleHypotenuse];
        } completion:^(BOOL finished) {
            self.isOpening = YES;
        }];
    }];
}

#pragma mark - 关闭动画
- (void)closeAnimation:(NSNotification *)notification {
    if (!_isOpening) {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIButton * button in self.menuView.subviews) {
            button.frame = kButtonOriginRect;
        }
        self.menuView.alpha = 0;
    } completion:^(BOOL finished) {
        self.isOpening = NO;
    }];
}

#pragma mark - 恢复原状
- (void)recoverToNormalStatus {
    [self updateButtonsLayoutWithHypotenuse:kMaxTriangleHypotenuse];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuView.alpha = 0;
        [self updateButtonsLayoutWithHypotenuse:kDefaultTriangleHypotenuse - 12.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateButtonsLayoutWithHypotenuse:kDefaultTriangleHypotenuse];
        } completion:nil];
    }];
}

#pragma mark - 按钮的点击事件
- (void)centerButtonTouch:(UIButton *)sender {
//    if (_isOpening) {
//        [self closeAnimation:nil];
//    } else {
//        [self openAnimation];
//    }
    if (_CallBackBlock) {
        _CallBackBlock(0);
    }
}

- (void)otherButtonTouch:(UIButton *)sender {
    NSInteger index = sender.tag - 500;
    if (_CallBackBlock) {
        _CallBackBlock(index);
    }
}

#pragma mark - 强制竖屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 释放
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUUCircleMenuClose object:nil];
}

@end
