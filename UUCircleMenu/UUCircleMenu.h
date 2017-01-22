//
//  UUCircleMenu.h
//  UUCircleMenu
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUUCircleMenuNavigationBarHeight 44.f

static NSString * const kUUCircleMenuClose = @"kUUCircleMenuClose";

@interface UUCircleMenu : UIView

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *centerButton;

@property (nonatomic, assign) BOOL isOpening;

- (instancetype)initWithTop:(CGFloat)top
                buttonCount:(NSInteger)buttonCount
                   menuSize:(CGFloat)menuSize
                 buttonSize:(CGFloat)buttonSize
      buttonImageNameFormat:(NSString *)buttonImageNameFormat
           centerButtonSize:(CGFloat)centerButtonSize
      centerButtonImageName:(NSString *)centerButtonImageName
                   callBack:(void(^)(NSInteger index))block;

- (void)openAnimation;

- (void)recoverToNormalStatus;

@end
