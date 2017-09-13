//
//  SFCarouselView.m
//  SFCarouselExampleObjc
//
//  Created by swifterfit on 2017/9/12.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "SFCarouselView.h"
#import "SFCarouselCell.h"
#import "SFConst.h"

@interface SFCarouselView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *imageGroup;
@property (strong, nonatomic) NSArray *titleGroup;
@property (assign, nonatomic) NSInteger totalItems;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation SFCarouselView

+ (instancetype)carouselViewWithFrame:(CGRect)frame infiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup titleGroup:(NSArray *)titleGroup {
    SFCarouselView *carouselView = [[SFCarouselView alloc] initWithFrame:frame];
    carouselView.infiniteLoop = infiniteLoop;
    carouselView.imageGroup = [imageNamesGroup copy];
    carouselView.titleGroup = [titleGroup copy];

    return carouselView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.infiniteLoop = YES;
        self.autoScroll = YES;//默认自动滑动
        self.autoScrollTimeInterval = 2; //默认间隔两秒

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width + kItemMargin, self.bounds.size.height);
    self.flowLayout = flowLayout;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin / 2, 0, self.bounds.size.width + kItemMargin, self.bounds.size.height) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[SFCarouselCell class] forCellWithReuseIdentifier:NSStringFromClass([SFCarouselCell class])];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.collectionView.contentOffset.x == 0 && self.totalItems > 0) {
        NSInteger targeIndex = 0;
        if (self.infiniteLoop) {//无限循环
            // 如果是无限循环，应该默认把 collection 的 item 滑动到 中间位置。
            // 注意：此处 totalItems 的数值，其实是图片数组数量的 100 倍。
            // 乘以 0.5 ，正好是取得中间位置的 item 。图片也恰好是图片数组里面的第 0 个。
            targeIndex = _totalItems * 0.5;
        }else {
            targeIndex = 0;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

}

- (void)setImageGroup:(NSArray *)imageGroup {
    _imageGroup = imageGroup;
    self.collectionView.contentSize = CGSizeMake((self.bounds.size.width + kItemMargin) * imageGroup.count, 0);

    _totalItems = self.infiniteLoop ? imageGroup.count * 100 : imageGroup.count;

    if (_imageGroup.count > 1) {
        self.collectionView.scrollEnabled = YES;
        //处理是否自动滑动，定时器问题
        [self setAutoScroll:self.autoScroll];
    }else{
        self.collectionView.scrollEnabled = NO;
        [self setAutoScroll:NO];
    }
    [self.collectionView reloadData];

}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    //创建之前，停止定时器
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误

    NSTimer *timer  = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    _timer = timer;
}

- (void)automaticScroll {
    if (0 == _totalItems) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;

    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex{
    if (targetIndex >= _totalItems) {//调到中间的任意一组里面的 第0个图片
        if (self.infiniteLoop) {//无限循环
            targetIndex = _totalItems * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        return;
    }

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}

- (NSInteger)currentIndex {

    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size
        .height == 0) {
        return 0;
    }

    NSInteger index = 0;

    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    }else{
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5)/ self.flowLayout.itemSize.height;
    }
    return MAX(0,index);
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SFCarouselCell class]) forIndexPath:indexPath];

    // 利用取余运算，使得图片数组里面的图片，是一组一组的排列的。
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    [cell setImage:[UIImage imageNamed:self.imageGroup[itemIndex]] title:self.titleGroup[itemIndex]];

    return cell;

}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imageGroup.count;
}

#pragma - mark UICollectionViewDelegate

@end
