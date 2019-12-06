//
//  Ky481ChartHeader.h
//  ez
//
//  Created by dahe on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#ifndef Ky481ChartHeader_h
#define Ky481ChartHeader_h

#import "YZChartStatus.h"

#define topBtnH 35
#define LeftLabelW1 60
#define LeftLabelW2 80
#define CellH1 (screenWidth - LeftLabelW1 - LeftLabelW2) / 8
#define CellH2 (screenWidth - LeftLabelW2) / 8

typedef enum {
    KChartCellTagZongHe = 1,
    KChartCellTagZiyou = 2,
    KChartCellTagYang = 3,
    KChartCellTagWa = 4,
    KChartCellTagDie = 5,
}KChartCellTag;

typedef enum {
    KChartCellTagAvgMiss = 1,
    KChartCellTagCount = 2,
    KChartCellTagMaxMiss = 3,
    KChartCellTagMaxSeries = 4,
}KChartStatisticsTag;

#endif /* Ky481ChartHeader_h */
