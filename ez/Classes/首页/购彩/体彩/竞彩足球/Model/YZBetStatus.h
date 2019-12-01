//
//  YZBetStatus.h
//  ez
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZBetStatus : NSObject<NSCoding>

@property (nonatomic, copy) NSMutableAttributedString *labelText;//显示的文字

@property (nonatomic, assign) CGFloat cellH;//cell的高度

@property (nonatomic, assign) int betCount;//注数

@property (nonatomic, copy) NSString *playType;

@property (nonatomic, copy) NSString *betType;

@end
