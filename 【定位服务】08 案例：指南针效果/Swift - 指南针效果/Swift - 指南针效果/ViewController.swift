//
//  ViewController.swift
//  Swift - 指南针效果
//
//  Created by 蓝田 on 2016/9/29.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var compassView: UIImageView!
    
    // 1. 懒加载，创建位置管理者
    lazy var locationM: CLLocationManager = {
        
        let locationM = CLLocationManager()
        locationM.delegate = self
        
        return locationM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. 判断当前"磁力计"传感器是否可用
        if CLLocationManager.headingAvailable() {
            // 使用位置管理者, 获取当前设备朝向
            locationM.startUpdatingHeading()
        }else {
            print("当前磁力计设备损坏")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// 代理协议
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        // 0.判断当前的角度是否有效(如果此值小于0,代表角度无效)
        if newHeading.headingAccuracy < 0 { return }
        
        // 1.获取当前设备朝向（0- 359.9 角度）
        let angle = newHeading.magneticHeading
        
        // 1.1 把角度转换成为弧度
        let hudu = CGFloat(angle / 180 * M_PI)
        
        // 2. 反向旋转图片(弧度)
        UIView.animate(withDuration: 0.5, animations: {
            self.compassView.transform = CGAffineTransform(rotationAngle: -hudu)
        })
    }
}
