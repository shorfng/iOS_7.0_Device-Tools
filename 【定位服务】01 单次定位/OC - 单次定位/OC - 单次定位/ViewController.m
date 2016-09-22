//
//  ViewController.m
//  OC - 单次定位
//
//  Created by 蓝田 on 16/9/21.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> // 代理
@property(nonatomic, strong) CLLocationManager *locationM; // 位置管理者
@end

@implementation ViewController

#pragma mark - 懒加载对象，并在懒加载方法中进行部分初始化操作
- (CLLocationManager *)locationM {
    if (!_locationM) {
        // 1. 创建位置管理者（需要强引用，否则一出现就会消失）强引用后，UI控件创建时会添加到subviews数组里,作用域结束时也不会释放
        _locationM = [[CLLocationManager alloc] init];
        
        // 2. 设置代理, 接收位置数据（其他方式：block、通知）
        _locationM.delegate = self;
        
        // 3. 请求用户授权 --- ios8之后才有(配置info.plist文件)
        
        //方法1:判断系统版本
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
            
            [_locationM requestAlwaysAuthorization];    // 前后台定位授权
            //[_locationM requestWhenInUseAuthorization];      // 前台定位授权
        }
        
        //方法2:
        /*
         if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
         
         [_locationM requestAlwaysAuthorization];//持续授权
         [_locationM requestWhenInUseAuthorization];//使用期间授权
         }
         */
        
        // 4. 设置定位的过滤距离(单位:米), 表示用户位置移动了x米时调用对应的代理方法
        // 本次定位 与 上次定位 位置之间的物理距离 > 下面设置的数值时,就会通过代理,将当前位置告诉外界
        _locationM.distanceFilter = 500; //在用户位置改变500米时调用一次代理方法
        
        // 5. 设置定位的精确度 (单位:米),（定位精确度越高, 越耗电, 定位的速度越慢）
        // _locationM.desiredAccuracy = 100; // 当用户在100米范围内，系统会默认将100米范围内都当作一个位置
        _locationM.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 点击屏幕，开始更新用户位置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self compareDistance]; //比较两点间的距离
    
    // 判断定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"已经开启定位服务，即将开始定位...");
        
#pragma mark - 开始定位
        // 方法1：标准定位服务（使用位置管理器进行定位）
        // 开始更新位置信息（一旦调用了这个方法, 就会不断的刷新用户位置,然后告诉外界）
        // 以下代码默认只能在前台获取用户的位置信息,如果想要在后台获取用户的位置信息, 那么需要勾选后台模式 location updates
        // 小经验: 如果以后使用位置管理者这个对象, 实现某个服务,可以用startXX开始某个服务，stopXX停止某个服务
        // [self.locationM startUpdatingLocation];
        
        // 方法2：监听重大位置变化的服务(基于基站进行定位)（显著位置变化定位服务）
        //  [self.locationM startMonitoringSignificantLocationChanges];
        
        // 单次定位请求
        // 必须实现代理的定位失败方法
        // 不能与startUpdatingLocation方法同时使用
        [self.locationM requestLocation];
    } else {
        NSLog(@"没有开启定位服务");
    }
}

#pragma mark - 比较两点间的距离(直线距离)
- (void)compareDistance {
    // 北京位置
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:39.26 longitude:115.25];
    // 上海位置
    CLLocation *location2 =[[CLLocation alloc] initWithLatitude:30.4 longitude:120.51];
    
    // 两个地方的距离(单位:米)
    CGFloat distance = [location2 distanceFromLocation:location1];
    
    NSLog(@"比较两个点的距离：%f", distance / 1000);
}

#pragma mark - 代理方法：当位置管理器获取到用户位置后，就会调用此方法
// 参数: (manager:位置管理者) (locations: 位置对象数组)
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"位置信息:%@", locations);
    
    // 停止定位(代理方法一直调用,会非常耗电，除非特殊需求，如导航）
    // 只想获取一次用户位置信息,那么在获取到位置信息之后,停止更新用户的位置信息
    // 应用场景: 获取用户所在城市
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}

#pragma mark - 代理方法：当用户授权状态发生变化时调用
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"1.用户还未决定");
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"2.访问受限(苹果预留选项,暂时没用)");
            break;
        }
        // 定位关闭时 and 对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:{
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]){
                NSLog(@"3.定位服务是开启状态，需要手动授权，即将跳转设置界面");
                // 在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权在iOS8.0之后跳转到"设置"界面代码
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:settingURL]){
                    
                    //  [[UIApplication sharedApplication] openURL:settingURL]; // 方法过期
                    
                    [[UIApplication sharedApplication]openURL:settingURL options:nil completionHandler:^(BOOL success) {
                        NSLog(@"已经成功跳转到设置界面");
                    }];
                }
                else{
                    NSLog(@"定位关闭，不可用");
                }
                break;
            }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"4.获取前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"5.获得前台定位授权");
            break;
        }
        default:
            break;
        }
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
