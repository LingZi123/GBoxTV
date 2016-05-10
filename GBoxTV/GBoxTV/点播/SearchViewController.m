//
//  SearchViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "SearchViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonBaseData.h"
#import "ProgramModel.h"
#import "IptvCategoryModel.h"
#import "ProgramDetailViewController.h"
#import "CategateDetailViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    widethItem=ondemand_width*CGRectGetWidth(self.view.bounds)/base_device_width;
    //            heightItem=150*widethItem/93;
    heightItem=widethItem+30;
    widthFlex=(CGRectGetWidth(self.view.bounds)-3*widethItem)/6;
    heightFlex=widthFlex;
    [searchCollectionview registerNib:[UINib nibWithNibName:@"OndemandCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ondemand"];

    self.navigationItem.title=@"影视搜索";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTextfield resignFirstResponder];
}

- (IBAction)searchBtnClick:(id)sender {
    [searchTextfield resignFirstResponder];
    if (searchTextfield.text.length<=0) {
        return;
    }
    [self SearchPrograms:searchTextfield.text];
}

#pragma mark CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (searchmArray) {
        return searchmArray.count;
    }
    else{
        return 0;
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *identifier = @"ondemand";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:301];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:300];
    imageView.image=nil;
    id dict = [searchmArray objectAtIndex:indexPath.row];
    if([dict isKindOfClass:[ProgramModel class]]){
        ProgramModel *theDic=dict;
        lable.text = [NSString stringWithFormat:@"%@",theDic.Name];
        
//        [NetEngine imageAtURL:theDic.PicUrl onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//            imageView.image = fetchedImage;
//        }];
        imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theDic.PicUrl]]];
    }
    else{
        IptvCategoryModel *theDic=dict;
        lable.text = [NSString stringWithFormat:@"%@",theDic.Name];
//        [NetEngine imageAtURL:theDic.PicUrl onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//            imageView.image=fetchedImage;
//        }];
    }
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"ODFilterHeaderView";
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    return view;
}

#pragma mark CollectionViewDelegate



- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    
    UICollectionViewTransitionLayout *myCustomTransitionLayout =
    [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return myCustomTransitionLayout;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id dict = [searchmArray objectAtIndex:indexPath.row];
    if ([dict isKindOfClass:[ProgramModel class]]) {
        ProgramModel *prog=(ProgramModel *)dict;
        ProgramDetailViewController *programvc=[[ProgramDetailViewController alloc]initWithModel:prog];
        [self.navigationController pushViewController:programvc animated:YES];

    }
    else{
        //进入下一个页面填充
        CategateDetailViewController *vc=[[CategateDetailViewController alloc]initWithSuperModel:dict];
        [self.navigationController pushViewController:vc animated:YES];    }
    
}

#pragma mark-layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(widethItem, heightItem);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(heightFlex, widthFlex, heightFlex, widthFlex);
}

#pragma mark-网络数据交互

-(void)SearchPrograms:(NSString *)categoryId{
    if (categoryId==nil) {
        return;
    }
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeNone];
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_SearchPrograms;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:[self appdelegate].userInfo.username forKey:@"userid"];
    [bodyData.param setObject:@"" forKey:@"categoryId"];
    [bodyData.param setObject:searchTextfield.text forKey:@"keyWord"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
//                    [self showErrorView:NO errormes:nil];
                    NSArray  *array= [responseObject objectForKey:@"datas"];
                    if ([array isKindOfClass:[NSArray class]]) {
                        
                        if (searchmArray == nil) {
                            searchmArray = [[NSMutableArray alloc]initWithCapacity:0];
                        }
                        [searchmArray removeAllObjects];
                        for (NSDictionary *dic in array) {
                            ProgramModel *model=[ProgramModel getModelWithDictionary:dic];
                            [searchmArray addObject:model];
                        }
                        [searchCollectionview reloadData];
                    }
                    if (array==nil||array.count==0) {
//                        [self showErrorView:YES errormes:@"无搜索结果"];
                    }
                    
                }
                else{
//                    [self showErrorView:YES errormes:[error objectForKey:@"info"]];
                }
            }
            else{
//                [self showErrorView:YES errormes:@"加载失败，数据有误"];
            }
        }
        else{
//            [self showErrorView:YES errormes:@"加载失败，数据有误"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorView:YES errormes:@"加载失败，网络有误"];
        [SVProgressHUD dismiss];
    }];
    
}
#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}



@end
