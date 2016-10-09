//
//  TDAnnotation.h
//  OC - 大头针基本使用
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

#pragma mark - 自定义大头针模型
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TDAnnotation : NSObject<MKAnnotation>
// 大头针所在经纬度（订在地图哪个位置）
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// 大头针标注显示的标题
@property (nonatomic, copy, nullable) NSString *title;
// 大头针标注显示的子标题
@property (nonatomic, copy, nullable) NSString *subtitle;
@end
