//
//  OndemandViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "OndemandViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ProgramModel.h"
#import "enmuHelper.h"
#import "CommonBaseData.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonHelper.h"
#import "ProgramDetailViewController.h"
#import "CategateDetailViewController.h"
#import "SearchViewController.h"
#import "RemoteControlViewController.h"

@interface OndemandViewController ()

@end

@implementation OndemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userId=[self appdelegate].userInfo.username;
    session=[self appdelegate].userInfo.sesion;
    [self makeView];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL request=[defaults boolForKey:DE_Save_requestOndemand];
    if (request) {
        [self getCategorys:@"" andCategoryIndex:CategoryParent];
        [defaults setBool:NO forKey:DE_Save_requestOndemand];
        [defaults synchronize];
    }
    else{
        //先从本地获取一级目录
        [self getDataFromLocal];
        if (mainCategoryArray==nil||mainCategoryArray.count<=0) {
            //从服务器取一级目录
            [self getCategorys:@"" andCategoryIndex:CategoryParent];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    userId=[self appdelegate].userInfo.username;
    session=[self appdelegate].userInfo.sesion;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL request=[defaults boolForKey:DE_Save_requestOndemand];
    if (request) {
        [self getCategorys:@"" andCategoryIndex:CategoryParent];
        [defaults setBool:NO forKey:DE_Save_requestOndemand];
        [defaults synchronize];
    }
}
-(void)getDataFromLocal
{
    // 取本地数据
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[defaults objectForKey:DE_Save_movieRootCategory];
    if (data) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (array&&[array isKindOfClass:[NSArray class]]) {
            [self fullCategoryArray:mainCategoryArray andData:array];
            [self fullScrollView:mainCategoryScrollview withArray:mainCategoryArray];
        }
    }
    
}

- (void)makeView
{
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backItem;
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
//    //选择自己喜欢的颜色
//    UIColor * color = [UIColor whiteColor];
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
//    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title=@"影视点播";
    UIBarButtonItem *searchBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSearch:)];
     UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"小遥控器"] style:UIBarButtonItemStylePlain  target:self  action:@selector(remoteControlBtnClick:)];
    self.navigationItem.rightBarButtonItems=@[rightBtn,searchBtn];
    mChannelbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    mChannelbgView.hidden = NO;
    mChannelbgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    topViewforChannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mChannelbgView.bounds), 70)];
    topViewforChannel.backgroundColor =[UIColor whiteColor];
    
    //电视剧、电影、体育、娱乐、少儿、科教、综合
    
    mainCategoryScrollview =[[UIScrollView alloc] init ];
    mainCategoryScrollview.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.bounds), 35);
    mainCategoryScrollview.contentMode = UIViewContentModeScaleAspectFit;
    mainCategoryScrollview.clipsToBounds = YES;
    mainCategoryScrollview.contentSize =  CGSizeMake(2000, 0);
    mainCategoryScrollview.showsHorizontalScrollIndicator=NO;
    
    
    subCategoryScrollview = [[UIScrollView alloc] init];
    
    subCategoryScrollview.frame = CGRectMake(0,mainCategoryScrollview.frame.origin.y+mainCategoryScrollview.frame.size.height,CGRectGetWidth(self.view.bounds), 35);
    
    //    subCategoryScrollview.selectedTextColor = [UIColor colorWithRed:0x16/255.0 green:0xB3/255.0 blue:0xFF/255.0 alpha:0xFF/255.0];
    subCategoryScrollview.contentMode = UIViewContentModeScaleAspectFit;
    subCategoryScrollview.clipsToBounds = YES;
    subCategoryScrollview.contentSize =  CGSizeMake(2000, 0);
    subCategoryScrollview.showsHorizontalScrollIndicator=NO;
    
    
    UILabel *lineLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0,subCategoryScrollview.frame.origin.y+subCategoryScrollview.frame.size.height+5,self.view.bounds.size.width,0.5)];
    lineLable2.backgroundColor = [DEFAULTTEXTBlackColor colorWithAlphaComponent:0.2];
    
    [topViewforChannel addSubview:mainCategoryScrollview];
    [topViewforChannel addSubview:subCategoryScrollview];
    [topViewforChannel addSubview:lineLable2];
    
    [mChannelbgView addSubview:topViewforChannel];
    
    if (mChannelCollectionView == nil) {
        UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
        
        widethItem=ondemand_width*CGRectGetWidth(self.view.bounds)/base_device_width;
        //            heightItem=150*widethItem/93;
        heightItem=widethItem+30;
        widthFlex=(CGRectGetWidth(self.view.bounds)-3*widethItem)/6;
        heightFlex=widthFlex;
        
        grid.itemSize = CGSizeMake(widethItem, heightItem);
        grid.sectionInset = UIEdgeInsetsMake(heightFlex, widthFlex, heightFlex, widthFlex);
        grid.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
        
        mChannelCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,60, CGRectGetWidth(mChannelbgView.bounds), CGRectGetHeight(mChannelbgView.bounds)-60) collectionViewLayout:grid];
        mChannelCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mChannelCollectionView.delegate = self;
        mChannelCollectionView.dataSource = self;
        mChannelCollectionView.backgroundColor = DEFAULTVIEWBACKGROUNDCOLOR;
        mChannelCollectionView.alwaysBounceVertical = YES;
        
        [mChannelbgView addSubview:mChannelCollectionView];
        [mChannelCollectionView registerNib:[UINib nibWithNibName:@"OndemandCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ondemand"];
        
        //        [mChannelCollectionView registerClass:[ODFilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ODFilterHeaderView"];
        
        
        
//        _refreshHeaderViewForChannel= [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,  - mChannelCollectionView.bounds.size.height, CGRectGetWidth(self.view.bounds), mChannelCollectionView.bounds.size.height)];
//        _refreshHeaderViewForChannel.delegate = self;
//        _refreshHeaderViewForChannel.userInteractionEnabled = YES;
//        [mChannelCollectionView addSubview:_refreshHeaderViewForChannel];
//        
//        [_refreshHeaderViewForChannel refreshLastUpdatedDate];
        _reloadingForChannel=NO;
        
    }
    
    [self.view addSubview:mChannelbgView];
    
    errorView=[[UIView alloc]initWithFrame:CGRectMake(0,60, CGRectGetWidth(mChannelbgView.bounds), CGRectGetHeight(mChannelbgView.bounds)-60)];
    errorView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:errorView];
    errorView.hidden=YES;
    errorLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, errorView.frame.size.width, 21)];
    errorLabel.font=[UIFont systemFontOfSize:12];
    errorLabel.textAlignment=NSTextAlignmentCenter;
    errorLabel.text=@"加载失败,请检查网络";
    [errorView addSubview:errorLabel];
    ;
    
}

-(void)showErrorView:(BOOL)isSHow errormes:(NSString *)mess{
    [SVProgressHUD dismiss];
    errorView.hidden=!isSHow;
    errorLabel.text=mess;
    mChannelCollectionView.hidden=isSHow;
}

-(void)pushSearch:(id)sender{
    SearchViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)remoteControlBtnClick:(UIBarButtonItem *)sender{
    RemoteControlViewController *vc=[[self appdelegate].mainStoryboard instantiateViewControllerWithIdentifier:@"RemoteControlViewController"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (mCollectionViewDataSource) {
        return mCollectionViewDataSource.count;
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
    id dict = [mCollectionViewDataSource objectAtIndex:indexPath.row];
    if([dict isKindOfClass:[ProgramModel class]]){
        ProgramModel *theDic=dict;
        lable.text = [NSString stringWithFormat:@"%@",theDic.Name];
        imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theDic.PicUrl]]];
        
//        [NetEngine imageAtURL:theDic.PicUrl onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//            imageView.image = fetchedImage;
//        }];
    }
    else{
        IptvCategoryModel *theDic=dict;
        lable.text = [NSString stringWithFormat:@"%@",theDic.Name];
        imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theDic.PicUrl]]];
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
    if (collectionView == mChannelCollectionView)
    {
        NSString *reuseIdentifier = @"ODFilterHeaderView";
        UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        
        return view;
    }
    return nil;
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
    id dict = [mCollectionViewDataSource objectAtIndex:indexPath.row];
    if ([dict isKindOfClass:[ProgramModel class]]) {
        ProgramModel *prog=(ProgramModel *)dict;
        ProgramDetailViewController *programvc=[[ProgramDetailViewController alloc]initWithModel:prog];
        
        [self.navigationController pushViewController:programvc animated:YES];
    }
    else{
        //进入下一个页面填充
        CategateDetailViewController *vc=[[CategateDetailViewController alloc]initWithSuperModel:dict];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == mChannelCollectionView)
    {
//        [_refreshHeaderViewForChannel egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView==mChannelCollectionView) {
        
//        [_refreshHeaderViewForChannel egoRefreshScrollViewDidEndDragging:scrollView];
        if ((scrollView.contentOffset.y>(mChannelCollectionView.contentSize.height-mChannelCollectionView.frame.size.height)+40)&&scrollView.contentOffset.y>0) {
            [self loadingMoreForChannel];
        }
    }
    //    else if (<#expression#>)
}

- (void)loadingMoreForChannel
{
    pageForChannel += 1;
    
    [self SearchPrograms:currentSelectedModel.CategoryID];
}

- (void)doneLoadingTableViewDataForChannel{
    
    _reloadingForChannel = NO;
//    [_refreshHeaderViewForChannel egoRefreshScrollViewDataSourceDidFinishedLoading:self.mChannelCollectionView];
    [mChannelCollectionView reloadData];
}



#pragma mark Action

- (void)ShowFilter:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)mChannelCollectionView.collectionViewLayout;
    if (CGSizeEqualToSize(layout.headerReferenceSize, CGSizeMake(CGRectGetWidth(self.view.bounds), 0)) && sender.selected) {
        
        [UIView animateWithDuration:1 animations:^{
            layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 160);
        }];
    }
    else
    {
        [UIView animateWithDuration:1 animations:^{
            layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 0);
        }];
        
    }
}

#pragma mark-获取栏目列表

-(void)getCategorys:(NSString *)parentId andCategoryIndex:(en_Category)categoryIndex{
    
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetCategorys;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:userId forKey:@"userid"];
    [bodyData.param setObject:parentId forKey:@"parentId"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    
    
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---getCategorys----responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    [self showErrorView:NO errormes:nil];
                    NSArray *array=[responseObject objectForKey:@"datas"];
                    if (array&&[array isKindOfClass:[NSArray class]]) {
                        
                        //获取父类的数据
                        if (categoryIndex==CategoryParent) {
                            
                            //保存到本地
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[array copy]];
                            [[CommonHelper share]writeDefaultsData:data andKey:DE_Save_movieRootCategory];
                            
                            [self fullCategoryArray:mainCategoryArray andData:array];
                            [self fullScrollView:mainCategoryScrollview withArray:mainCategoryArray];
                        }
                        else if(categoryIndex==CategorySubOne){
                            
                            [self fullCategoryArray:subCategoryArray andData:array];
                            [self fullScrollView:subCategoryScrollview withArray:subCategoryArray];
                            
                        }
                        else if (categoryIndex==CategorySubTwo){
                            //填充collview了
                            if (mCollectionViewDataSource == nil) {
                                mCollectionViewDataSource = [[NSMutableArray alloc]initWithCapacity:0];
                            }
                            [mCollectionViewDataSource removeAllObjects];
                            for (NSDictionary *dic in array) {
                                IptvCategoryModel *model=[IptvCategoryModel getModelWithDictionary:dic];
                                [mCollectionViewDataSource addObject:model];
                            }
                            [self doneLoadingTableViewDataForChannel];
                        }
                        
                    }
                    
                }
                else{
                    if ([parentId isEqualToString:@""]) {
                        [self getDataFromLocal];
                    }
                    else{
                        NSLog(@"----getCategorys----error----%@",[error objectForKey:@"info"]);
                        [self showErrorView:YES errormes:@"加载失败，数据错误"];
                    }
                }
            }
        }
        else{
            [self showErrorView:YES errormes:@"加载失败，数据错误"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([parentId isEqualToString:@""]) {
            [SVProgressHUD dismiss];
            [self getDataFromLocal];
        }
        else{
            NSLog(@"---getCategorys----error:%@",error.description);
            [self showErrorView:YES errormes:@"加载失败，请检查网络"];
        }
    }];
    
}

//判断是否有子栏目
//index 栏目的级数
-(void)getSubTypeOrContent:(NSString *)categoryID categoryIndex:(en_Category)categoryIndex{
    if (categoryID==nil) {
        return;
    }
//    NSInteger states=[self appdelegate].networkStatus;
//    if (states==UnknowNetwork||states==WithoutNetwork||states==CDMA1xNetwork||
//        states==CDMAEVDORev0||states==CDMAEVDORevA||states==CDMAEVDORevB) {
//        [SVProgressHUD showErrorWithStatus:@"该网络无法访问"];
//        return;
//    }
    CommonBaseData *bodyData=[[CommonBaseData alloc]init];
    bodyData.action=DE_Action_GetSubTypeOrContent;
    [bodyData.device setObject:@"123" forKey:@"dnum"];
    [bodyData.user setObject:userId forKey:@"userid"];
    [bodyData.param setObject:categoryID forKey:@"categoryId"];
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"----GetSubTypeOrContent-----%@----",responseObject);
        id error=[responseObject objectForKey:@"error"];
        if (error) {
            int errorCode=[[error objectForKey:@"code"] intValue];
            if(errorCode==0){
                [self showErrorView:NO errormes:nil];
                //取结果
                id data=[responseObject objectForKey:@"data"];
                if (data) {
                    int result=[[data objectForKey:@"result"] intValue];
                    //无子栏目
                    if (result==0) {
                        //二级目录无子栏目开始搜索影片
                        subCategoryScrollview.hidden=NO;
                        if (categoryIndex==CategorySubTwo) {
                            [self SearchPrograms:categoryID];
                        }
                        else if (categoryIndex==CategorySubOne){
                            //一级目录无子栏目则也应该搜索影片
                            subCategoryScrollview.hidden=YES;
                            [self SearchPrograms:categoryID];
                            //并且隐藏二级目录
                        }
                    }
                    else{
                        //有子栏目获取子栏目
                        [self getCategorys:categoryID andCategoryIndex:categoryIndex];
                        
                    }
                }
            }
            else{
                [self showErrorView:YES errormes:@"加载失败，数据有误"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"--GetSubTypeOrContent----error---%@",error.description);
        [self showErrorView:YES errormes:@"加载失败，网络有误"];
        
    }];
}


//搜索影片
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
    [bodyData.user setObject:userId forKey:@"userid"];
    [bodyData.param setObject:categoryId forKey:@"categoryId"];
    [bodyData.param setObject:@"" forKey:@"keyWord"];
    [bodyData.param setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [bodyData.param setObject:[NSNumber numberWithInt:999] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:DE_mainUrl parameters:[bodyData getDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            id error=[responseObject objectForKey:@"error"];
            if (error) {
                int errorCode=[[error objectForKey:@"code"] intValue];
                if (errorCode==0) {
                    [self showErrorView:NO errormes:nil];
                    NSArray  *array= [responseObject objectForKey:@"datas"];
                    if ([array isKindOfClass:[NSArray class]]) {
                        
                        if (mCollectionViewDataSource == nil) {
                            mCollectionViewDataSource = [[NSMutableArray alloc]initWithCapacity:0];
                        }
                        [mCollectionViewDataSource removeAllObjects];
                        for (NSDictionary *dic in array) {
                            ProgramModel *model=[ProgramModel getModelWithDictionary:dic];
                            [mCollectionViewDataSource addObject:model];
                        }
                        [self doneLoadingTableViewDataForChannel];
                        
                    }
                    
                }
                else{
                    [self showErrorView:YES errormes:[error objectForKey:@"info"]];
                }
            }
            else{
                [self showErrorView:YES errormes:@"加载失败，数据有误"];
            }
        }
        else{
            [self showErrorView:YES errormes:@"加载失败，数据有误"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorView:YES errormes:@"加载失败，网络有误"];
    }];
    
}


#pragma mark-视图操作

-(void)fullCategoryArray:(NSMutableArray *)categoryArray andData:(NSArray *)sourceData{
    if (categoryArray==mainCategoryArray) {
        if (mainCategoryArray==nil) {
            mainCategoryArray=[[NSMutableArray alloc]init];
        }
        [mainCategoryArray removeAllObjects];
        
        
        for (NSDictionary *dic in sourceData) {
            IptvCategoryModel *model=[IptvCategoryModel getModelWithDictionary:dic];
            if (![model.Name containsString:@"4K专区"]) {
                [mainCategoryArray addObject:model];
            }
        }
        
    }
    else if (categoryArray==subCategoryArray){
        if (subCategoryArray==nil) {
            subCategoryArray=[[NSMutableArray alloc]init];
        }
        [subCategoryArray removeAllObjects];
        
        
        for (NSDictionary *dic in sourceData) {
            IptvCategoryModel *model=[IptvCategoryModel getModelWithDictionary:dic];
            [subCategoryArray addObject:model];
        }
    }
}
-(void)fullScrollView:(UIScrollView *)sender withArray:(NSArray *)array{
    
    //移除所有的子view
    UIFont *font=DE_FONT_16;
    int itemWith=20;
    if (sender.subviews) {
        for (id subview in sender.subviews) {
            [subview removeFromSuperview];
        }
    }
    if (array==nil||array.count<=0) {
        return;
    }
    int tag=100;//从100开始-1000是主栏目1000-2000是1级子栏目
    
    if (sender==mainCategoryScrollview) {
        tag=100;
        font=DE_FONT_BOLD_16;
        itemWith=23;
    }
    else if(sender==subCategoryScrollview){
        tag=1000;
    }
    
    int btnOrgionX=10;
    int btnWidth=0;
    for (int i=0; i<array.count; i++) {
        IptvCategoryModel *model=array[i];
        btnWidth=[model.Name length]*itemWith;
        //        char* p = (char*)[model.Name cStringUsingEncoding:NSUnicodeStringEncoding];
        //        int count=[model.Name lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
        //        btnWidth=count*15;
        
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=tag+i;
        btn.titleLabel.font=font;
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:model.Name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        if (i==0) {
            [self categorySelected:btn];
        }
        btn.frame=CGRectMake(btnOrgionX, 2, btnWidth, 25);
        btnOrgionX=btnOrgionX+btnWidth+10;//设置下一个按钮的起点位置
        [sender addSubview:btn];
        
    }
    sender.contentSize=CGSizeMake(btnOrgionX, 0);
    
}
-(void)updateButtonTitleColor:(UIButton *)sender{
    if (sender.selected) {
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    else{
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
-(void)categorySelected:(UIButton *)sender{
    UIButton *btn=sender;
    btn.selected=!btn.selected;
    [self updateButtonTitleColor:btn];
    
    if (selectButtonArray==nil||selectButtonArray==(id)[NSNull null]) {
        selectButtonArray=[[NSMutableArray alloc]init];
    }
    if (btn.tag>=1000) {
        if (selectButtonArray.count>=1&&selectButtonArray.count<2) {
            [selectButtonArray addObject:btn];//设置为当前选择的btn
        }
        else{
            UIButton *oldBtn=[selectButtonArray objectAtIndex:1];
            if (oldBtn.tag!=btn.tag) {
                oldBtn.selected=NO;
                [self updateButtonTitleColor:oldBtn];
                selectButtonArray[1]=btn;
            }
            else{
                return;//重复选择不做处理
            }
        }
    }
    else{
        if (selectButtonArray.count<1){
            [selectButtonArray addObject:btn];
        }
        else{
            UIButton *oldBtn=[selectButtonArray objectAtIndex:0];
            if (oldBtn.tag!=btn.tag) {
                oldBtn.selected=NO;
                [self updateButtonTitleColor:oldBtn];
                selectButtonArray[0]=btn;
                if (selectButtonArray.count>1) {
                    [selectButtonArray removeObjectAtIndex:1];
                }
            }
            else{
                return;//重复选择不做处理
            }
            
        }
    }
    
    
    
    //子栏目
    IptvCategoryModel *selectModel=nil;
    if (btn.tag>=1000&&btn.tag<2000) {
        selectModel=[subCategoryArray objectAtIndex:btn.tag-1000];
        currentSelectedModel=selectModel;
        [self getSubTypeOrContent:selectModel.CategoryID categoryIndex:CategorySubTwo];
        
        
    }
    else if(btn.tag>=100&&btn.tag<1000){
        selectModel=[mainCategoryArray objectAtIndex:btn.tag-100];
        [self getSubTypeOrContent:selectModel.CategoryID categoryIndex:CategorySubOne];
    }
    
    
}

-(void)relocadSubChannelSource:(IptvCategoryModel *)model{
    
    [self getSubTypeOrContent:model.CategoryID categoryIndex:CategorySubTwo];
}

#pragma  mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
