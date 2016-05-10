//
//  OndemandViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IptvCategoryModel.h"



@interface OndemandViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    BOOL _reloadingForChannel;
    int pageForChannel;
    
    UIScrollView *mainCategoryScrollview;
    UIScrollView *subCategoryScrollview;
    
    NSString *userId;
    NSString *session;
    NSMutableArray *mChannelDataSourceArray;//包括所有的channel以及子channel的数据
    UIView *topViewforChannel;
    IptvCategoryModel *currentSelectedModel;
    NSMutableArray *selectButtonArray;//选择的button 0是根目录，1是子目录
    UIView *errorView;//错误提示view
    UILabel *errorLabel;//错误提示label
    CGFloat widthFlex;
    CGFloat heightFlex;
    CGFloat heightItem;
    CGFloat widethItem;
    
    UIView *mChannelbgView;
    UICollectionView *mChannelCollectionView;
    NSMutableArray *mCollectionViewDataSource;
    NSMutableArray *mainCategoryArray;
    NSMutableArray *subCategoryArray;
}
@end
