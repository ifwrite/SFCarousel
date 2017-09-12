//
//  SFCarouselCell.m
//  SFCarouselExampleObjc
//
//  Created by swifterfit on 2017/9/12.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "SFCarouselCell.h"

@interface SFCarouselCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SFCarouselCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        _imageView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);

        [self.contentView addSubview:_imageView];

    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _imageView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
//}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
