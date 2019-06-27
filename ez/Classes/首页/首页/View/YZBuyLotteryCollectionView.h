//
//  YZBuyLotteryCollectionView.h
//  ez
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZBuyLotteryCollectionViewDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface YZBuyLotteryCollectionView : UICollectionView

//刷新
- (void)headerRefreshViewBeginRefreshingWith:(MJRefreshGifHeader *)header;

@property (nonatomic, weak) id <YZBuyLotteryCollectionViewDelegate> buyLotteryDelegate;

@end
