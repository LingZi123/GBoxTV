//
//  LiveViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSupperViewController.h"
#import "LiveTitleView.h"

@interface LiveViewController : MainSupperViewController<UITableViewDataSource,UITableViewDelegate,LiveTitleViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UITableView *mytableview;
    __weak IBOutlet UITableView *otherTablevew;
    
//    UITableView *selectedTableview;//选中的tableview
    
    LiveTitleView *livetitleview;
//    UIPageControl *pagecon;
    NSMutableArray *liveArray;//直播频道数组 分台显示 重庆、中央、卫视、IPTV、其他
    NSMutableArray *cqmArray;//重庆台
    NSMutableArray *zymArray;//中央台
    NSMutableArray *wsmArray;//卫视台
    NSMutableArray *iptvmArray;//iptv台
    NSMutableArray *srmArray;//少儿
    NSMutableArray *vamArray;//综艺
    NSMutableArray *tymArray;//体育
    NSMutableArray *othermArray;//其它频道
    NSMutableArray *tablemArray;//数据
    
    NSArray *suppermArray;//一级目录数据
    
    
    NSString *userId;//用户ID，
    NSString *session;//唯一签名
    
    NSInteger seletedIndex;
    
    
//    UICollectionView *collectionview;//
}
@end
