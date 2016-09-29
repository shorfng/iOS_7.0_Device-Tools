//
//  ViewController.m
//  OC - 指南针效果
//
//  Created by 蓝田 on 2016/9/29.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationM;
@property (weak, nonatomic) IBOutlet UIImageView *compassView;
@end

@implementation ViewController

#pragma mark - 懒加载
-(CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
    }
    return _locationM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断"磁力计是否可用"
    if ([CLLocationManager headingAvailable]) {
        // 开始监听设备朝向
        [self.locationM startUpdatingHeading];
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    // 1.判断当前的角度是否有效(如果此值小于0,代表角度无效)
    if(newHeading.headingAccuracy < 0)
        return;
    
    NSLog(@"%f", newHeading.magneticHeading);

    // 2.获取当前设备朝向(磁北方向)
    CGFloat angle = newHeading.magneticHeading;
    
    // 3.转换成为弧度
    CGFloat radian = angle / 180.0 * M_PI;
    
    // 4.带动画反向旋转指南针
    [UIView animateWithDuration:0.5 animations:^{
        self.compassView.transform = CGAffineTransformMakeRotation(-radian);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
