//
//  ViewController.m
//  OC - POI检索
//
//  Created by 蓝田 on 2016/10/11.
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
    
    // 1. 创建一个POI请求
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    
    // 2.1 设置请求检索的关键字
    request.naturalLanguageQuery = @"银行";
    // 2.2 设置请求检索的区域范围
    request.region = self.mapView.region;
    
    // 3. 根据请求创建检索对象
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    // 4. 使用检索对象, 检索对象
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            // 响应对象MKLocalSearchResponse,里面存储着检索出来的"地图项",每个地图项中有包含位置信息, 商家信息等
            [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 遍历所有的关键字搜到的结果的名称
                NSLog(@"%@",obj.name);  // 最多只能打印10条数据
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
