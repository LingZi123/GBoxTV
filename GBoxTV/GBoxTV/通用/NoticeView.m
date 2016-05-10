//
//  NoticeView.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}
-(void)makeView{
    self.backgroundColor=[UIColor whiteColor];
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2-10, self.frame.size.width-20, 21)];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=DE_FONT_14;
    [self addSubview:noticeLabel];
}
-(void)showWithText:(NSString *)text{
    noticeLabel.text=text;
}

@end
