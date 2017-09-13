//
//  SFCarouselCell.m
//  SFCarouselExampleObjc
//
//  Created by swifterfit on 2017/9/12.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "SFCarouselCell.h"
#import "SFConst.h"

@interface SFCarouselCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SFCarouselCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kItemMargin / 2, 0, 200, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:28];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame) + 30, self.bounds.size.width - kItemMargin, self.bounds.size.height)];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _imageView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
//}

- (void)setImage:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.titleLabel.text = title;
}

@end
