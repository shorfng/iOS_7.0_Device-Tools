//
//  ViewController.m
//  OC - 区域监听
//
//  Created by 蓝田 on 2016/9/28.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationM;
@end

@implementation ViewController

#pragma mark - 懒加载
- (CLLocationManager *)locationM {
    if (!_locationM) {
        // 创建CLLocationManager对象并设置代理
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
        // 请求前后台定位, 或前台定位授权, 并在Info.Plist文件中配置相应的Key
        if ([_locationM respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationM requestAlwaysAuthorization];
        }
    }
    return _locationM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]])
    {
    
    // 0.判断区域监听服务是否可用(定位服务是否关闭, 定位是否授权,是否开启飞行模式)
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
      
        // 1.创建区域中心
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(21.123, 124.345);
        // 指定区域半径
        CLLocationDistance radius = 100;
        
        // 区域半径如果大于最大区域监听半径，则无法监听成功
        if (radius > self.locationM.maximumRegionMonitoringDistance) {
            radius = self.locationM.maximumRegionMonitoringDistance;
        }
        
        // 根据区域中心和区域半径创建一个区域
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center
                                                                     radius:radius
                                                                 identifier:@"TD"];
        
        // 2. 开始监听指定区域 (这个方法, 只会当进入或者离开区域这个动作触发时, 才会调用对应的代理方法)
        [self.locationM startMonitoringForRegion:region];
        
        // 请求获取某个区域的当前状态
        [self.locationM requestStateForRegion:region];
    } else {
        NSLog(@"区域监听不可用");
    }
 }
}

#pragma mark - CLLocationManagerDelegate
#pragma mark - 进入监听区域后调用（调用一次）
- (void)locationManager:(nonnull CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region {
    
    NSLog(@"进入区域---%@", region.identifier);
}

#pragma mark - 进入监听区域后调用（调用一次）
- (void)locationManager:(nonnull CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region {
    
    NSLog(@"离开区域---%@", region.identifier);
}

#pragma mark - 当监听区域失败时调用
// 监听区域个数是有上限的,如果大于上限,再注册区域就会失败,就会执行此方法)
- (void)locationManager:(nonnull CLLocationManager *)manager
monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(nonnull NSError *)error {
    
    // 经验: 一般都是在此处把比较远的区域给移除
//    [manager stopMonitoringForRegion:region];
}

#pragma mark - 请求某个区域状态时, 回调的代理方法
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    
    switch (state) {
        case CLRegionStateUnknown:
            NSLog(@"未知状态");
            break;
        case CLRegionStateInside:
            NSLog(@"在区域内部");
            break;
        case CLRegionStateOutside:
            NSLog(@"在区域外部");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
