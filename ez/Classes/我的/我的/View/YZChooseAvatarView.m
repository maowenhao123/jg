//
//  YZChooseAvatarView.m
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZChooseAvatarView.h"

@interface YZChooseAvatarView ()

@property (nonatomic, weak) UIView *photoView;

@end

@implementation YZChooseAvatarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = YZColor(0, 0, 0, 0.4);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(25, 163, 290, 290*3/4)];
        self.photoView = photoView;
        photoView.center = self.center;
        photoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:photoView];
        
        for(int i = 0;i < 12;i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectIcon:)];
            [imageView addGestureRecognizer:tap];
            imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"icon%d",i]];
            int maxColums = 4;
            CGFloat margin = 15;
            CGFloat imageViewW = (photoView.frame.size.width - (maxColums+1) * margin) / maxColums;
            CGFloat imageViewH =imageViewW;
            CGFloat imageViewX = margin + (i % maxColums) * (margin + imageViewW);
            CGFloat imageViewY = margin + (i / maxColums) * (margin + imageViewH);
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
            [photoView addSubview:imageView];
        }
    }
    return self;
}
- (void)show{
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    self.photoView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
       self.photoView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)hide{
    [self removeFromSuperview];
}
- (void)selectIcon:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.block) {
        //保存被选中的image
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%ld",(long)imageView.tag] forKey:@"selectedIconTag"];
        [defaults synchronize];
        self.block(imageView.tag);
    }
    [self hide];
}
@end
