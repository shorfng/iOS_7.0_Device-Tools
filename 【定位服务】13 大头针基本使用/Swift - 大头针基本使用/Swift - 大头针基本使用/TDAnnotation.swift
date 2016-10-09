//
//  TDAnnotation.swift
//  Swift - 大头针基本使用
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

//MARK: - 自定义大头针
import MapKit

class TDAnnotation: NSObject,MKAnnotation {
    
    // 确定大头针砸在哪个位置
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    // 弹框的标题
    var title: String?
    
    // 弹框的子标题
    var subtitle: String?
}
