//
//  BindingViewController.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"账号绑定";
    [self startScan];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startScan{
    //获取摄像机
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output=[[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    session=[[AVCaptureSession alloc]init];
    //高质量采集
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=scanview.layer.bounds;
    [scanview.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
}

#pragma mrak-AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
        UIAlertController *alter=[UIAlertController alertControllerWithTitle:@"扫描结果" message:@"您即将绑定用户名为gf001的IPTV账户" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alter addAction:cancel];
        [alter addAction:ok];
        
        [self presentViewController:alter animated:YES completion:^{
            
        }];
    }
}

@end
