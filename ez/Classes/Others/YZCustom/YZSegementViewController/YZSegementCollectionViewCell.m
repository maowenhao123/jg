//
//  YZSegementCollectionViewCell.m
//  ez
//
//  Created by dahe on 2019/6/21.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZSegementCollectionViewCell.h"

@interface YZSegementCollectionViewCell ()

@property (nonatomic, weak) UILabel * titleLabel;

@end

@implementation YZSegementCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel = titleLabel;
        titleLabel.backgroundColor = YZWhiteLineColor;
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.cornerRadius = titleLabel.height / 2;
        [self.contentView addSubview:titleLabel];
    }
    return self;
}

- (void)setIsCurrentItem:(BOOL)isCurrentItem
{
    _isCurrentItem = isCurrentItem;
    if (_isCurrentItem) {
        self.titleLabel.textColor = YZRedTextColor;
    }else
    {
        self.titleLabel.textColor = YZBlackTextColor;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.titleLabel.text = _text;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}


@end
