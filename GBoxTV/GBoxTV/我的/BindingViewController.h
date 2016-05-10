//
//  BindingViewController.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MainSupperViewController.h"

@interface BindingViewController : MainSupperViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    
    __weak IBOutlet UIView *scanview;
    AVCaptureSession *session;
}
@end
