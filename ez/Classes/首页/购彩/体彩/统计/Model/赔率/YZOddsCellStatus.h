//
//  YZOddsCellStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZOddsCellStatus : NSObject

@property (nonatomic, copy) NSString *companyId;//公司Id
@property (nonatomic, copy) NSString *companyName;//公司名

@property (nonatomic, assign, getter = isSelected) BOOL selected;//是否被选中的
@property (nonatomic, assign) int oddsType;//赔率类型 0.欧赔 1.亚盘 2.大小盘

@end
