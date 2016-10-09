//
//  TDAnnotation.swift
//  Swift - 大头针场景模拟
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

// 继承自NSObject，遵守MKAnnotation协议
import MapKit

class TDAnnotation: NSObject,MKAnnotation {
    
    // 确定大头针扎在地图上哪个位置
    var coordinate: CLLocationCoordinate2D
    
    // 确定大头针弹框的标题
    var title: String?
    
    // 确定大头针弹框的子标题
    var subtitle: String?
    
    // 构造方法
    init(coordinate:CLLocationCoordinate2D!, title:String?, subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
