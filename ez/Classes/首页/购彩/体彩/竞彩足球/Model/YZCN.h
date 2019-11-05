//
//  YZCN.h
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZCN : NSObject

@property (nonatomic, copy) NSString *concedePoints;
@property (nonatomic, copy) NSString *oddsCode;
@property (nonatomic, copy) NSString *oddsInfo;
@property (nonatomic, copy) NSString *oddsName;
@property (nonatomic, assign) int single;

//@property (nonatomic, strong) NSMutableArray *btnStateArray;//返回数据中没有，自定义，一排三个按钮的状态数组
//@property (nonatomic, assign) int btnSelectedCount;//表示该CN有赔率按钮被选中,多少个按钮选中
//- (NSMutableArray *)getSelectedOddsInfoArray;
@end
