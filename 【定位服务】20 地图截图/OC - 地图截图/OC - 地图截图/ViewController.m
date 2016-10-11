//
//  ViewController.m
//  OC - 地图截图
//
//  Created by 蓝田 on 2016/10/10.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 1. 创建截图附加选项 - option
    MKMapSnapshotOptions *option = [[MKMapSnapshotOptions alloc] init];
    
    // 2. 设置截图附加选项 - option
    option.mapRect = self.mapView.visibleMapRect; // 设置地图区域
    option.region = self.mapView.region;  // 设置截图区域(在地图上的区域,作用在地图)
    option.mapType = MKMapTypeStandard;   // 截图的地图类型
    option.showsPointsOfInterest = YES;   // 是否显示POI
    option.showsBuildings = YES;          // 是否显示建筑物
    option.size = self.mapView.frame.size;         // 设置截图后的图片大小(作用在输出图像)
    option.scale = [[UIScreen mainScreen] scale];  // 设置截图后的图片比例（默认是屏幕比例， 作用在输出图像）
    
    // 3. 创建截图对象
    MKMapSnapshotter *snapShoter = [[MKMapSnapshotter alloc] initWithOptions:option];
    
    // 4. 开始截图
    [snapShoter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if (error == nil) {
            // 获取到截图图像
            UIImage *image = snapshot.image;
            // 将截图转换成为NSData数据
            NSData *data = UIImagePNGRepresentation(image);
            // 将图像保存到指定路径
            [data writeToFile:@"/Users/TD/Desktop/test.png" atomically:YES];
        }else{
           NSLog(@"截图错误：%@",error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
