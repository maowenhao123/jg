//
//  YZLoadHtmlFileController.h
//  ez
//
//  Created by apple on 14-9-24.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZLoadHtmlFileController : YZBaseViewController
/* 
 通过文件名请求数据
 */
- (instancetype)initWithFileName:(NSString *)fileName;
/*
 通过web请求数据
 */
- (instancetype)initWithWeb:(NSString *)web;
/*
 通过html请求数据
 */
- (instancetype)initWithHtmlStr:(NSString *)htmlStr;

@property (nonatomic, copy) NSString *web;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, assign) int isDismissVC;

@end
