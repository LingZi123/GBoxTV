//
//  LiveTitleView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LiveTitleView.h"

@implementation LiveTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        if (btnTitleArray==nil) {
            btnTitleArray=[[NSArray alloc]initWithObjects:@"重庆",@"中央",@"卫视",@"IPTV",@"其它", nil];
        }
        [self makeBodyView];
       
    }
    return self;
}

-(void)makeBodyView{
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-5, self.frame.size.height)];
    scrollView.contentSize=CGSizeMake(320, self.frame.size.height);
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:scrollView];
    
    int x=0;
    for (int i=0; i<btnTitleArray.count; i++) {
        
        x=i*54+2;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(x, 2, 54, 30)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"直播标题按钮背景"] forState:UIControlStateSelected];
        btn.tag=100+i;
        btn.titleLabel.font=DE_FONT_BOLD_16;
        btn.titleLabel.textColor=[UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        switch (i) {
            case 0:
                cqbtn=btn;
                break;
            case 1:
                zybtn=btn;
                break;
            case 2:
                wsbtn=btn;
                break;
            case 3:
                iptvbtn=btn;
                break;
            case 4:
                otherbtn=btn;
                break;
            default:
                break;
        }
        if (_items==nil) {
            _items=[[NSMutableArray alloc]init];
        }
        [_items addObject:btn];
    }
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(scrollView.frame), 0, 5, self.frame.size.height)];
    [image setImage:[UIImage imageNamed:@"直播头分割"]];
    [self addSubview:image];
   
}

-(void)defaultSelectIndex:(NSInteger )index{
    //选中第一个
    cqbtn.selected=YES;
    [self btnClick:cqbtn];
}

-(void)btnClick:(UIButton *)sender{
    //选中的是同一个
    if (sender==selectedBtn) {
        return;
    }
    sender.selected=YES;
    selectedBtn.selected=NO;
    selectedBtn=sender;
    [self.liveTitleDelegate LiveTitleViewClickWithIndex:sender.tag-100];
}
@end
