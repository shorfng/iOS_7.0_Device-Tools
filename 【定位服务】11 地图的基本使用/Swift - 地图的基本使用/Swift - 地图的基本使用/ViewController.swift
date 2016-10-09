//
//  ViewController.swift
//  Swift - 地图的基本使用
//
//  Created by 蓝田 on 16/9/9.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! // 地图view
    
    // MARK: - 懒加载
    lazy var locationM: CLLocationManager = {
        
        let locationM = CLLocationManager()
        
        // 请求用户授权（判断设备的系统）（当前target为7.0）
        if #available(iOS 8.0, *) {
            locationM.requestAlwaysAuthorization()
        }
        return locationM
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 设置地图显示类型
        mapView.mapType = MKMapType.standard
        
        // MARK: - 设置地图的控制项
        // 注意：设置对应的属性时，注意该属性是从哪个系统版本开始引入的，做好不同系统版本的适配
        mapView.isZoomEnabled = true  // 是否可以缩放
        mapView.isScrollEnabled = true // 是否可以滚动
        mapView.isRotateEnabled = true // 是否可以旋转
        mapView.isPitchEnabled = true // 是否显示3D
        
        
        // MARK: - 设置地图显示项
        mapView.showsPointsOfInterest = true // 是否显示兴趣点（POI）
        mapView.showsBuildings = true // 是否显示建筑物
        
        if #available(iOS 9.0, *) {// 下面的方法是iOS 9.0以后加入的
            mapView.showsCompass = true  // 是否显示指南针
            mapView.showsScale = true // 是否显示比例尺
            mapView.showsTraffic = true // 是否显示交通
        }
        
        
        // MARK: - 地图显示用户位置
        _ = locationM //调用懒加载，请求用户授权
        
        // 显示用户位置方案1：（需要请求用户授权）
        // 效果：显示一个蓝点,在地图上面标示用户的位置信息
        // 缺点：不会自动放大地图,当用户位置移动时,地图不会自动跟着跑
        mapView.showsUserLocation = true
        
        // 显示用户位置方案2：设置地图的跟随模式（需要请求用户授权）
        // 效果：显示一个蓝点,在地图上面标示用户的位置信息，会自动放大地图,当用户位置移动时，地图会自动跟着跑
        // 缺点：拖动地图后，地图不会再随着用户位置移动而移动
        /*
         case none   // 不跟随
         case follow // 跟随用户位置
         case followWithHeading // 跟随用户位置，并跟随用户方向
         */
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
