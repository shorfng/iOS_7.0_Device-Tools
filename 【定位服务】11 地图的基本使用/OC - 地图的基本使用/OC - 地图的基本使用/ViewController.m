//
//  ViewController.m
//  OC - 地图的基本使用
//
//  Created by 蓝田 on 16/9/7.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()
@property(weak, nonatomic) IBOutlet MKMapView *mapView;    // 地图view
@property(nonatomic, strong) CLLocationManager *locationM; // 位置管理器
@end

@implementation ViewController

#pragma mark - 懒加载
- (CLLocationManager *)locationM {
  if (!_locationM) {
    // 创建位置管理者
    _locationM = [[CLLocationManager alloc] init];

    // 请求用户授权
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      //    if ([_locationM
      //    respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      [_locationM requestAlwaysAuthorization];
    }
  }
  return _locationM;
}

- (void)viewDidLoad {
  [super viewDidLoad];
#pragma mark - 设置地图显示类型
  self.mapView.mapType = MKMapTypeStandard;

#pragma mark - 设置地图的控制项
  // 注意：设置对应的属性时，注意该属性是从哪个系统版本开始引入的，做好不同系统版本的适配
  self.mapView.zoomEnabled = true;   // 是否可以缩放
  self.mapView.scrollEnabled = true; // 是否可以滚动
  self.mapView.rotateEnabled = true; // 是否可以旋转
  self.mapView.pitchEnabled = true;  // 是否显示3D

#pragma mark - 设置地图显示项
  self.mapView.showsCompass = true;          // 是否显示指南针
  self.mapView.showsScale = true;            // 是否显示比例尺
  self.mapView.showsPointsOfInterest = true; // 是否显示兴趣点（POI）
  self.mapView.showsBuildings = true;        // 是否显示建筑物
  self.mapView.showsTraffic = true;          // 是否显示交通

#pragma mark - 地图显示用户位置

  [self locationM]; //调用懒加载，请求用户授权

  // 显示用户位置方案1：（需要请求用户授权）
  // 效果：显示一个蓝点,在地图上面标示用户的位置信息
  // 缺点：不会自动放大地图,当用户位置移动时,地图不会自动跟着跑
  self.mapView.showsUserLocation = true;

  // 显示用户位置方案2：设置地图的跟随模式（需要请求用户授权）
  // 效果：显示一个蓝点,在地图上面标示用户的位置信息，会自动放大地图,当用户位置移动时，地图会自动跟着跑
  // 缺点：拖动地图后，地图不会再随着用户位置移动而移动
  /*
   MKUserTrackingModeNone = 0, // 不跟随
   MKUserTrackingModeFollow, // 跟随用户位置
   MKUserTrackingModeFollowWithHeading, // 跟随用户位置，并跟随用户方向
   */
  self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
