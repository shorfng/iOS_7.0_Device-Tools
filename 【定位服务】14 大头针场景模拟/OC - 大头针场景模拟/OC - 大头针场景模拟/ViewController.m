//
//  ViewController.m
//  OC - 大头针场景模拟
//
//  Created by 蓝田 on 2016/10/8.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TDAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationM;
@end

@implementation ViewController

#pragma mark - 懒加载
-(CLLocationManager *)locationM{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationM requestAlwaysAuthorization];
        }
    }
    return _locationM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self locationM];
    
    // 设置用户位置跟踪模式
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

#pragma mark - 添加大头针
- (void)addAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate{
    // 1、创建一个大头针数据模型
    TDAnnotation *annotation = [[TDAnnotation alloc] init];
    
    // 2、大头针数据模型的属性
    annotation.coordinate = coordinate; //根据经纬度坐标添加大头针
    //  annotation.coordinate = self.customMapView.centerCoordinate;// 当前地图中心点对应的经纬度
    
    annotation.title = @"大头针弹框的标题";
    annotation.subtitle = @"大头针弹框的子标题";
    
    // 3、添加大头针数据模型, 到地图上
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 移除地图上所有大头针
- (void)removeAllAnnotation{
    // 1. 获取所有的大头针数据模型
    NSArray *annotations = self.mapView.annotations;
    // 2. 移除大头针
    [self.mapView removeAnnotations:annotations];
}

#pragma mark - 触摸屏幕
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取当前触摸点在地图上的坐标
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.mapView];
    
    // 将坐标转换为经纬度
    CLLocationCoordinate2D center = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    [self addAnnotationWithCoordinate:center];
}

#pragma mark - 触摸移动时，移除地图上所有大头针
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeAllAnnotation];
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title = @"用户位置的标题";
    userLocation.subtitle = @"用户位置的标题";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
