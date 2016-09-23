//
//  ViewController.swift
//  Swift-地理定位（iOS8+）
//
//  Created by 蓝田 on 2016/9/22.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // 懒加载
    lazy var locationM : CLLocationManager = {
        
        // 1. 创建位置管理者
        let locationM : CLLocationManager = CLLocationManager()
        
        // 2. 设置代理, 接收位置数据（其他方式：block、通知）
        locationM.delegate = self
        
        // 3.定位（在info.plist文件中配置对应的key）
        
        // 如果两个授权都请求，那么先执行前面那个请求弹框，后面那个请求授权 有可能 下次被调用时，才会起作用
        // 如果，先请求的是“前后台授权”，那“前台授权”即使被调用，也不会有反应（因为“前后台授权”权限大于“前台授权”）
        // 反之，如果先请求的是“前台授权”，而且用户选中的是“允许”，那下次被调用时“前后台授权”会做出请求，但只请求一次
        
        // 本质：1. 两个授权同时请求，先执行前面那个授权请求
        //      2. “前后台请求授权”方法，在（当前的授权状态 == 用户未选择状态 or 前台授权状态） 才会起作用
        //      3. “前台请求授权”方法，在（当前的授权状态 == 用户未选择状态） 才会起作用
        
        // 判断系统版本，做适配
        if (Float(UIDevice.current.systemVersion)! >= 8.0){
            // 前台定位
            // 配合后台模式，屏幕上方会出现一个蓝色的横幅, 不断提醒用户, 当前APP 正在使用你的位置
            locationM.requestWhenInUseAuthorization()
            
            // 前后台定位
            // 无论是否勾选后台模式, 都可以获取位置信息. 而且无论前后台, 都不会出现蓝条
            // locationM.requestAlwaysAuthorization()
        }
        
        // 4. 设置过滤距离
        // 如果当前位置, 距离上一次的位置之间的物理距离大于以下数值时, 就会通过代理, 将当前位置告诉外界
        locationM.distanceFilter = 100   // 每隔100 米定位一次
        
        // 5. 设置定位的精确度（定位精确度越高, 越耗电, 定位的速度越慢）
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationM
    }()
    
    // 点击屏幕，开始更新用户位置
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationM.startUpdatingLocation()
    }
}

// 类扩展（CLLocationManager的代理方法）
extension ViewController: CLLocationManagerDelegate {
    
    // 代理方法：当位置管理器，获取到位置后，就会调用此方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("获取到位置")
        
        // 只想获取一次用户位置信息,那么在获取到位置信息之后,停止更新用户的位置信息
        // 应用场景: 获取用户所在城市
        manager.stopUpdatingLocation()
    }
}

