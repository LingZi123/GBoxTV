//
//  NoticeView.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeView : UIView{
    UILabel *noticeLabel;
}

-(void)showWithText:(NSString *)text;
@end
