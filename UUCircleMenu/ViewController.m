//
//  ViewController.m
//  UUCircleMenu
//
//  Created by Zhuochenming on 2017/1/22.
//  Copyright © 2017年 Zhuochenming. All rights reserved.
//

#import "ViewController.h"
#import "UUCircleMenu.h"

#define kKYICircleMenuButtonImageNameFormat  @"KYICircleMenuButton%.2d.png" // %.2d: 1 - 6

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UUCircleMenu * circleMenu = [[UUCircleMenu alloc] initWithTop:100 buttonCount:6 menuSize:280 buttonSize:64 buttonImageNameFormat:@"KYICircleMenuButton0" centerButtonSize:64 centerButtonImageName:@"KYICircleMenuCenterButton" callBack:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
    [circleMenu openAnimation];
    circleMenu.backgroundColor = [UIColor grayColor];
    [self.view addSubview:circleMenu];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
