//
//  ViewController.m
//  OC - 使用手动画线导航
//
//  Created by 蓝田 on 2016/10/9.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation ViewController

-(CLGeocoder *)geoCoder{
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 导航包括:起点和终点  数据由苹果处理
    [self.geoCoder geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // 1. 拿到广州地标对象
        CLPlacemark *gzP = [placemarks firstObject];
        // 1.2 创建圆形的覆盖层数据模型
        MKCircle *circle1 = [MKCircle circleWithCenterCoordinate:gzP.location.coordinate
                                                          radius:100000];
        // 1.3 添加覆盖层数据模型到地图上
        [self.mapView addOverlay:circle1];
        
        [self.geoCoder geocodeAddressString:@"上海" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            // 2. 拿到上海地标对象
            CLPlacemark *shP = [placemarks firstObject];
            // 2.2 创建圆形的覆盖层数据模型
            MKCircle *circle2 = [MKCircle circleWithCenterCoordinate:shP.location.coordinate
                                                              radius:100000];
            // 2.3 添加覆盖层数据模型到地图上
            [self.mapView addOverlay:circle2];
            
            // 3. 调用开始导航的方法（从广州到上海）
            [self directionsWithBeginPlackmark:gzP andEndPlacemark:shP];
        }];
    }];
}

#pragma mark - 开始导航
// ① 根据两个地标，发送网络请求给苹果服务器获取导航数据，请求对应的行走路线信息
- (void)directionsWithBeginPlackmark:(CLPlacemark *)startPLCL andEndPlacemark:(CLPlacemark *)endPLCL{
    
    // 创建请求导航路线数据信息
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    // 创建起点:根据 CLPlacemark 地标对象创建 MKPlacemark 地标对象
    MKPlacemark *startplMK = [[MKPlacemark alloc] initWithPlacemark:startPLCL];
    request.source = [[MKMapItem alloc] initWithPlacemark:startplMK];
    
    // 创建终点:根据 CLPlacemark 地标对象创建 MKPlacemark 地标对象
    MKPlacemark *endplMK = [[MKPlacemark alloc] initWithPlacemark:endPLCL];
    request.destination = [[MKMapItem alloc] initWithPlacemark:endplMK];
    
    // 1. 创建导航对象，根据请求，获取实际路线信息
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 2. 调用方法, 开始发送请求,计算路线信息
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        // ② 解析导航数据
        // block遍历所有的路线方案routes （MKRoute对象）
        [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"%@",obj.advisoryNotices);
            NSLog(@"%@,%f,%f",obj.name,obj.distance,obj.expectedTravelTime);
            
            // 添加覆盖层数据模型,路线对应的几何线路模型（由很多点组成）
            // 当我们添加一个覆盖层数据模型时, 系统绘自动查找对应的代理方法, 找到对应的覆盖层"视图"
            [self.mapView addOverlay:obj.polyline];  // 添加折线
            
            // block 遍历每一种路线的每一个步骤（MKRouteStep对象）
            [obj.steps enumerateObjectsUsingBlock:^(MKRouteStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%@",obj.instructions);// 打印步骤说明
            }];
        }];
       
// 拓展
#pragma mark - block遍历
        [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"1打印对象的属性:%@,2索引:%lu",obj.name,(unsigned long)idx);
            
            // 实现在某个遍历某个索引处停止
            if (idx == 0) {
                NSLog(@"block停止");
                *stop = YES;
            }
        }];
        
#pragma mark - for in遍历   
        // 不知道遍历的对象的情况
        for (id obj in response.routes) {
            NSLog(@"3%@",[obj name]);
        }
        
        // 已知遍历的对象的情况
        for (MKRoute * _Nonnull obj in response.routes) {
            NSLog(@"3%@",obj.name);
        }
        
  
    }];
}

#pragma mark - MKMapViewDelegate
// ③ 添加导航路线到地图
// 当添加一个覆盖层数据模型到地图上时, 地图会调用这个方法, 查找对应的覆盖层"视图"(渲染图层)
// 参数1（mapView）：地图    参数2（overlay）：覆盖层"数据模型"   returns: 覆盖层视图
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    
    // 折线覆盖层
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 创建折线渲染对象 (不同的覆盖层数据模型, 对应不同的覆盖层视图来显示)
        MKPolylineRenderer *lineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        lineRenderer.lineWidth = 6;                     // 设置线宽
        lineRenderer.strokeColor = [UIColor redColor];  // 设置线颜色
        
        return lineRenderer;
    }
    
    // 圆形覆盖层
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        
        circleRender.fillColor = [UIColor blackColor];  // 设置填充颜色
        circleRender.alpha = 0.6;                       // 设置透明色
        
        return circleRender;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
