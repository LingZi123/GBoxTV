//
//  SearchViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    __weak IBOutlet UITextField *searchTextfield;
    __weak IBOutlet UICollectionView *searchCollectionview;
    NSMutableArray *searchmArray;
    CGFloat widthFlex;
    CGFloat heightFlex;
    CGFloat heightItem;
    CGFloat widethItem;
}
- (IBAction)searchBtnClick:(id)sender;
@end
