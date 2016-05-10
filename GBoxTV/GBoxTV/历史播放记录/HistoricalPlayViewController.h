//
//  HistoricalPlayViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSupperViewController.h"

@interface HistoricalPlayViewController : MainSupperViewController<UITableViewDelegate,UITableViewDataSource>
{
    UISegmentedControl *titleSegCon;
    NSMutableArray *boxmArray;
    NSMutableArray *phonemArray;
    NSMutableArray *tableviewArray;
    
    __weak IBOutlet UITableView *historyTableview;
}
@end
