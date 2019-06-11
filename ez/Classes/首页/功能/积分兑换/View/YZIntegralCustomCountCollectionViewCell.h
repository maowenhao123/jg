//
//  YZIntegralCustomCountCollectionViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/2/5.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZIntegralCustomCountCollectionViewCellDelegate <NSObject>

- (void)integralCustomCount:(NSInteger)count;

@end

@interface YZIntegralCustomCountCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<YZIntegralCustomCountCollectionViewCellDelegate> delegate;

@property (nonatomic,weak) UITextField *countTextField;

@end
