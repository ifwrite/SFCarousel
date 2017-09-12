//
//  ViewController.m
//  SFCarouselExampleObjc
//
//  Created by swifterfit on 2017/9/12.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "ViewController.h"
#import "SFCarouselView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *imageArr = @[@"1.jpg",
                          @"2.jpg",
                          @"3.jpg",
                          ];
    SFCarouselView *cycleView = [SFCarouselView carouselViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 180) infiniteLoop:YES imageNamesGroup:imageArr];
    [self.view addSubview:cycleView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
