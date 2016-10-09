//
//  ViewController.m
//  OC - 自定义大头针
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
    annotation.icon = @"1";

    // 设置代理
    self.mapView.delegate = self;
    
     // 反地理编码：获取当前经纬度所在位置信息，用作大头针标注的标题和子标题
      CLGeocoder *geocoder = [[CLGeocoder alloc] init];
      CLLocation *location =[[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                    longitude:coordinate.longitude];
    
      [geocoder reverseGeocodeLocation:location
                     completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
                   
                 if (error || placemarks.count == 0) {
                   return;
                 }
                         
                 //获取地标信息
                 CLPlacemark *placemark = [placemarks firstObject];
                 annotation.title = placemark.locality;
                 annotation.subtitle = placemark.name;
        }];
    
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
// 根据传进来的 viewForAnnotation 参数创建并返回对应的大头针控件
// 当添加大头针数据模型时，会调用此方法，获取对应的大头针视图。如果返回nil，则会显示系统默认的大头针视图。
// 系统默认的大头针视图对应的类 MKPinAnnotationView，大头针视图与tableview中的cell一样, 都使用“循环利用”的机制
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(TDAnnotation *)annotation{
    NSLog(@"添加大头针数据模型时, 调用了这个方法");
    
    // 判断annotation的类型，如果返回为空,代表大头针样式是由系统管理的 (即为光标样式)
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"大头针样式是由系统管理的 (即为光标样式)");
        return nil;
    }
    
#pragma mark - 默认运行会显示案例1效果，注释案例1可以看到案例2的效果

//  ================= 自定义方法案例1（模拟系统默认的大头针视图）
    
    // 0. 从缓存池取出大头针视图
    static NSString *ID1 = @"PinAnnotationView";
    
    // 1. MKPinAnnotationView 有界面,默认不能显示图片
    // 将 MKAnnotationView 类型转换为 MKPinAnnotationView
    MKPinAnnotationView *PinAnnotationView = (MKPinAnnotationView *) [mapView  dequeueReusableAnnotationViewWithIdentifier:ID1];
    
    // 2. 如果为空，则创建
    if (!PinAnnotationView) {
        PinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:ID1];
    }
    
    // 3. 传递模型数据，重新赋值, 防止循环利用时, 产生的数据错乱
    PinAnnotationView.annotation = annotation;
    
    // 4. 设置大头针可以弹框
    PinAnnotationView.canShowCallout = YES;
    
    // 5. 设置大头针的颜色
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        // iOS9.0以后, 可以设置任意颜色 (MKAnnotationView没有此方法)
        PinAnnotationView.pinTintColor = [UIColor blueColor] ;
    }else{
        // iOS 8.0的方法,只有3种颜色(MKAnnotationView没有此方法)
        PinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    
    // 6. 设置大头针下落动画(MKAnnotationView没有此方法)
    PinAnnotationView.animatesDrop = YES;

    // 7. 设置大头针可以被拖拽(父类中的属性)
    PinAnnotationView.draggable = YES;

    return PinAnnotationView;
    
//  ================= 自定义方法案例1（模拟系统默认的大头针视图）
    

//  ================= 自定义方法案例2（自定义大头针）
  
    // 0. 从缓存池取出大头针视图
    static NSString *ID2 = @"annotationView";
    
    // 1. MKAnnotationView 默认没有界面,可以显示图片
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID2];
    
    // 2. 如果为空，则创建
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:ID2];
    }
    
    // 4. 设置大头针图片
    // 方法1：直接使用 MKAnnotationView 的 image 属性
    annotationView.image = [UIImage imageNamed:@"2"];
    
    // 方法2：使用自定义大头针属性
    // annotationView.image = [UIImage imageNamed:annotation.icon];

    // 5. 设置大头针可以弹出标注
    annotationView.canShowCallout = YES;
    
    // 5.1 设置标注左侧视图
    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftIV.image = [UIImage imageNamed:@"huba.jpeg"];
    annotationView.leftCalloutAccessoryView = leftIV;
    
    // 5.2 设置标注右侧视图
    UIImageView *rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightIV.image = [UIImage imageNamed:@"htl.jpg"];
    annotationView.rightCalloutAccessoryView = rightIV;
    
    // 6. 设置下部弹框（详情视图）,会把子标题覆盖
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        annotationView.detailCalloutAccessoryView = [[UISwitch alloc] init];
    }
    
    return annotationView;
    
//  ================= 自定义方法案例2（自定义大头针）
    
}


// 当大头针马上添加到 mapView 时调用
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    NSLog(@"下面将改变大头针下落的速度");
    
    for (MKAnnotationView *view in views) {
        
        // if 条件的使用是为了不让光标类型的大头针有动画效果
        // MKModernUserLocationView 是一个私有类； NSClassFromString 把字符串转换成一个 class 类型
        if ([view isKindOfClass:NSClassFromString(@"MKModernUserLocationView")]) {
            continue;
        }
        
        // 1.保存大头针的最终位置
        CGRect viewFrame = view.frame;
        
        // 2.改变大头针的位置
        view.frame = CGRectMake(viewFrame.origin.x, 0, viewFrame.size.width,viewFrame.size.height);
        
        // 3.动画回归最终的位置
        [UIView animateWithDuration:0.25 animations:^{
                view.frame = viewFrame;
        }];
    }
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title = @"当前位置的标题";
    userLocation.subtitle = @"当前位置的子标题";
}

// 选中一个大头针时调用
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"选中%@", [view.annotation title]);
}

// 取消选中大头针时调用
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"取消选中%@", [view.annotation title]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
