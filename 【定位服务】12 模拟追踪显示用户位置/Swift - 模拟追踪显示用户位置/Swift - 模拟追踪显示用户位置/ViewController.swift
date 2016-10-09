//
//  ViewController.swift
//  Swift - 模拟追踪显示用户位置
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!// 地图view
    
    // 懒加载
    lazy var locationM: CLLocationManager = {
        
        let locationM = CLLocationManager()
        
        // 请求用户授权（判断设备的系统）（当前target为7.0）
        if #available(iOS 8.0, *) {
            locationM.requestAlwaysAuthorization()
        }
        return locationM
    }()
    
    // 地图显示用户位置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = locationM //调用懒加载，请求用户授权
        
        // 显示用户位置：跟踪模式
        // 缺点：iOS8.0之前，地图不会自动滚到用户所在位置
        // 解决方案：设置地图代理，在地图获取用户位置代理方法中操作；设置地图显示中心/设置地图显示区域
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        mapView.delegate = self
    }
}


extension ViewController: MKMapViewDelegate {
    
    // 当地图更新用户位置信息时, 调用的方法
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        // MKUserLocation: 大头针数据模型
        // location : 者就是大头针的位置信息(经纬度)
        // heading: 设备朝向对象
        // title: 弹框标题
        // subtitle: 弹框子标题
        userLocation.title = "大头针弹框的标题"  // 大头针弹框的标题
        userLocation.subtitle = "大头针弹框的子标题" // 大头针弹框的子标题
        
        // 方案1：根据用户当前位置的经纬度，设置地图的中心,显示在当前用户所在的位置
        // 效果：地图会自动移动到指定的位置坐标,并显示在地图中心
        // 缺点：地图显示比例过大，无法调整，不会自动放大地图
        // 解决：直接使用对应的调整地图“显示区域”的API
        mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
        
        
        /* 地图视图显示，不会更改地图的比例，会以地图视图高度或宽度较小的那个为基准，按比例调整
         MKCoordinateSpan 跨度解释
         latitudeDelta：纬度跨度，因为南北纬各90度，所以此值的范围是（0-180）；此值表示整个地图视图宽度，显示多大跨度
         longitudeDelta：经度跨度，因为东西经各180度，所以此值范围是（0-360）：此值表示整个地图视图高度，显示多大跨度
         */
        
        // 方案2：设置地图显示区域
        // ①使用地图的经纬度设置地图显示的中心
        // 中国地图全貌（纬度范围：3°51′N至53°33′N）（经度范围：73°33′E至135°05′E）
        let center = CLLocationCoordinate2DMake(28, 104) // 使用地图的经纬度设置地图显示的中心
        let span = MKCoordinateSpanMake(50, 64) // 设置跨度
        let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span) // 设置区域
        mapView.setRegion(region, animated: true)
        
        // ②使用区域中心设置地图显示的中心
        let center = (mapView.region.center) // 使用区域中心设置地图显示的中心
        let span = MKCoordinateSpanMake(0.0219952102009202, 0.0160932558432023)// 设置跨度
        let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)// 设置区域
        mapView.setRegion(region, animated: true)
        
        // ③使用当前用户的位置设置地图显示的中心
        let center = (userLocation.location?.coordinate)!
        let span = MKCoordinateSpanMake(0.0219952102009202, 0.0160932558432023)// 设置跨度
        let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)// 设置区域
        mapView.setRegion(region, animated: true)
    }
    
    
    // 区域改变的时候调用
    // 应用场景：在不知道经纬度跨度的合适值的时候，将地图放大到自己想要的跨度，然后再控制台复制打印出来的跨度
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 打印经度和纬度的跨度
        print(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)
    }
}

