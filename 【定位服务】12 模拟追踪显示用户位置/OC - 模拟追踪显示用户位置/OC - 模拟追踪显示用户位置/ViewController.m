//
//  ViewController.m
//  OC - 模拟追踪显示用户位置
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;   // 地图view
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
            [_locationM requestAlwaysAuthorization];
        }
    }
    return _locationM;
}

#pragma mark - 地图显示用户位置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locationM]; //调用懒加载，请求用户授权
    
    // 显示用户位置：跟踪模式
    // 缺点：iOS8.0之前，地图不会自动滚到用户所在位置
    // 解决方案：设置地图代理，在地图获取用户位置代理方法中操作；设置地图显示中心/设置地图显示区域
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    // 设置地图代理, 监听地图各个事件
    self.mapView.delegate = self;
}

#pragma mark - 当地图更新用户位置信息时, 调用的方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // 方案1：根据用户当前位置的经纬度，设置地图的中心,显示在当前用户所在的位置
    // 效果：地图会自动移动到指定的位置坐标,并显示在地图中心
    // 缺点：地图显示比例过大，无法调整，不会自动放大地图
    // 解决：直接使用对应的调整地图“显示区域”的API
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    
    /* 地图视图显示，不会更改地图的比例，会以地图视图高度或宽度较小的那个为基准，按比例调整
     MKCoordinateSpan 跨度解释
     latitudeDelta：纬度跨度，因为南北纬各90度，所以此值的范围是（0-180）；此值表示整个地图视图宽度，显示多大跨度
     longitudeDelta：经度跨度，因为东西经各180度，所以此值范围是（0-360）：此值表示整个地图视图高度，显示多大跨度
     */
    
    // 方案2：设置地图显示区域
    
    // ①使用地图的经纬度设置地图显示的中心
    // 中国地图全貌（纬度范围：3°51′N至53°33′N）（经度范围：73°33′E至135°05′E）
    CLLocationCoordinate2D center =CLLocationCoordinate2DMake(28, 104); // 使用地图的经纬度设置地图显示的中心
    MKCoordinateSpan span = MKCoordinateSpanMake(50, 64); // 设置跨度
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span); //设置区域
    [self.mapView setRegion:region animated:YES];
    
    // ②使用区域中心设置地图显示的中心
    CLLocationCoordinate2D center =self.mapView.region.center; // 使用区域中心设置地图显示的中心
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0219952102009202, 0.0160932558432023); //     设置跨度
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span); // 设置区域
    [self.mapView setRegion:region animated:YES];
    
    // ③使用当前用户的位置设置地图显示的中心
    CLLocationCoordinate2D center = userLocation.coordinate;
    MKCoordinateSpan span =MKCoordinateSpanMake(0.0219952102009202, 0.0160932558432023); // 设置跨度
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span); // 设置区域
    [mapView setRegion:region animated:YES];
}

#pragma mark - 区域改变的时候调用
// 应用场景：在不知道经纬度跨度的合适值的时候，将地图放大到自己想要的跨度，然后再控制台复制打印出来的跨度
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // 打印经度和纬度的跨度
    NSLog(@"%f-%f", mapView.region.span.latitudeDelta,
          mapView.region.span.longitudeDelta);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
