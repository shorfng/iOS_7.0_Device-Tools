//
//  ViewController.m
//  OC-地理定位（iOS8-）
//
//  Created by 蓝田 on 16/9/3.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>   // 代理
@property(nonatomic, strong) CLLocationManager *locationM; // 位置管理者
@end

@implementation ViewController

#pragma mark - 懒加载对象，并在懒加载方法中进行部分初始化操作
- (CLLocationManager *)locationM {
    if (!_locationM) {
        // 1. 创建位置管理者
        _locationM = [[CLLocationManager alloc] init];
        
        // 2. 设置代理, 接收位置数据（其他方式：block、通知）
        _locationM.delegate = self;
        
        // 3.前台定位，后台定位（在info.plist文件中配置对应的key）
        
        // 4. 设置定位的过滤距离(单位:米), 表示用户位置移动了x米时调用对应的代理方法
        _locationM.distanceFilter = 500; //在用户位置改变500米时调用一次代理方法
        
        // 5. 设置定位的精确度 (单位:米),（定位精确度越高, 越耗电, 定位的速度越慢）
        _locationM.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationM;
}

#pragma mark - 点击屏幕，开始更新用户位置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 判断定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"已经开启定位服务，即将开始定位...");
        
#pragma mark - 开始定位
        [self.locationM startUpdatingLocation];
    } else {
        NSLog(@"没有开启定位服务");
    }
}

#pragma mark - 代理方法：当位置管理器获取到用户位置后，就会调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"位置信息:%@", locations);
    
    // 停止定位(代理方法一直调用,会非常耗电，除非特殊需求，如导航）
    [manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
