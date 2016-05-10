//
//  LiveSupperViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/10.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveSupperViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *livecollectionview;
    NSArray *supperArray;//一级目录
    
    NSMutableArray *liveArray;//直播频道数组 分台显示 重庆、中央、卫视、IPTV、其他
    NSMutableArray *cqmArray;//重庆台
    NSMutableArray *zymArray;//中央台
    NSMutableArray *wsmArray;//卫视台
    NSMutableArray *iptvmArray;//iptv台
    NSMutableArray *srmArray;//少儿
    NSMutableArray *vamArray;//综艺
    NSMutableArray *tymArray;//体育
    NSMutableArray *othermArray;//其它频道
}
@end
