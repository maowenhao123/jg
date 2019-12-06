//
//  YZ11x5ChartHeader.h
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#ifndef YZ11x5ChartHeader_h
#define YZ11x5ChartHeader_h

#import "YZChartStatus.h"

#define topBtnH 35
#define LeftLabelW 60
#define CellH (screenWidth - LeftLabelW) / 11

typedef enum {
    KChartCellTagAll = 1,
    KChartCellTagWan = 2,
    KChartCellTagQian = 3,
    KChartCellTagBai = 4,
}KChartCellTag;

typedef enum {
    KChartCellTagAvgMiss = 1,
    KChartCellTagCount = 2,
    KChartCellTagMaxMiss = 3,
    KChartCellTagMaxSeries = 4,
}KChartStatisticsTag;

#endif /* YZ11x5ChartHeader_h */
