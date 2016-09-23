//
//  ViewController.swift
//  Swift-地理定位（iOS8-）
//
//  Created by 蓝田 on 16/9/3.
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
        
        // 3.前台定位，后台定位（在info.plist文件中配置对应的key）
        
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




