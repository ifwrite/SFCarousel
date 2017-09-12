//
//  SFCarouselView.h
//  SFCarouselExampleObjc
//
//  Created by swifterfit on 2017/9/12.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCarouselView : UIView

@property (assign, nonatomic) BOOL infiniteLoop;
@property (assign, nonatomic) BOOL autoScroll;
@property (assign, nonatomic) CGFloat autoScrollTimeInterval;

+ (instancetype)carouselViewWithFrame:(CGRect)frame infiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup;

@end
