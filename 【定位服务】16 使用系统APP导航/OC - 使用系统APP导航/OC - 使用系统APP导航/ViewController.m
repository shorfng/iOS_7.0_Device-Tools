//
//  ViewController.m
//  OC - 使用系统APP导航
//
//  Created by 蓝田 on 2016/10/9.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()
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
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 导航包括:起点和终点  数据由苹果处理
    [self.geoCoder geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // 1. 拿到广州地标对象
        CLPlacemark *gzP = [placemarks firstObject];
        
        [self.geoCoder geocodeAddressString:@"上海" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            // 2. 拿到上海地标对象
            CLPlacemark *shP = [placemarks firstObject];
            
            // 3. 调用开始导航的方法（从广州到上海）
            [self directionsWithBeginPlackmark:gzP andEndPlacemark:shP];
        }];
    }];
}

#pragma mark - 开始导航
// 根据两个地标，向苹果服务器请求对应的行走路线信息
- (void)directionsWithBeginPlackmark:(CLPlacemark *)startPLCL andEndPlacemark:(CLPlacemark *)endPLCL{
    
    // 创建起点:根据 CLPlacemark 地标对象创建 MKPlacemark 地标对象
    MKPlacemark *startplMK = [[MKPlacemark alloc] initWithPlacemark:startPLCL];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startplMK];
    
    // 创建终点:根据 CLPlacemark 地标对象创建 MKPlacemark 地标对象
    MKPlacemark *endplMK = [[MKPlacemark alloc] initWithPlacemark:endPLCL];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endplMK];
    
    // 设置导航地图启动项参数字典
    NSDictionary *launchDic = @{
          // 导航模式:驾驶
          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
          // 地图样式：标准样式
          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
          // 显示交通：显示
          MKLaunchOptionsShowsTrafficKey : @(YES),
    };
    
    // 根据 MKMapItem 的起点和终点组成数组, 通过导航地图启动项参数字典, 调用系统的地图APP进行导航
    [MKMapItem openMapsWithItems:@[startItem, endItem] launchOptions:launchDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
