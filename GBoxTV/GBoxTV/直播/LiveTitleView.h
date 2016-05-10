//
//  LiveTitleView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveTitleViewDelegate <NSObject>

-(void)LiveTitleViewClickWithIndex:(NSInteger)index;//选中的哪一个视图

@end
@interface LiveTitleView : UIView
{
    UIScrollView *scrollView;
    NSArray *btnTitleArray;//按钮的title
    UIButton *cqbtn;
    UIButton *zybtn;
    UIButton *wsbtn;
    UIButton *iptvbtn;
    UIButton *otherbtn;
    UIButton *selectedBtn;//选中btn
}

@property(nonatomic,assign) id<LiveTitleViewDelegate> liveTitleDelegate;
-(void)defaultSelectIndex:(NSInteger )index;
-(void)btnClick:(UIButton *)sender;
@property(nonatomic,retain)NSMutableArray *items;
@end
