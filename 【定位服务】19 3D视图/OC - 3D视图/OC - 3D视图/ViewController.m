//
//  ViewController.m
//  OC - 3D视图
//
//  Created by 蓝田 on 2016/10/10.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 设置需要看的位置的中心点
    CLLocationCoordinate2D center =CLLocationCoordinate2DMake(23.132931, 113.375924);
    
    // 创建3D视图的对象
    // 参数1: 需要看的位置的中心点   参数2: 从哪个地方看   参数3: 站多高看（眼睛的海拔，单位：米）
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:center
                                                     fromEyeCoordinate:CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
                                                           eyeAltitude:1];
    
    // 设置到地图上显示,方法1
    [self.mapView setCamera:camera animated:YES];
    
    // 设置到地图上显示,方法2
    // self.mapView.camera = camera;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
