//
//  ViewController.swift
//  获取当前位置名称
//
//  Created by 蓝田 on 2016/9/26.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // 用于记录上次位置数据的变量
    var lastLoc: CLLocation?
    
    // 位置管理者的懒加载
    lazy var locationM : CLLocationManager = {
        
        let locationM : CLLocationManager = CLLocationManager() // 创建
        
        locationM.delegate = self // 遵守代理
        
        // 如果在iOS8.0之后, 需要额外的执行以下代码, 主动请求用户授权
        if #available(iOS 8.0, *) {
            // 请求前台定位授权(不要忘记在info.plist文件中, 配置对应的key)
            locationM.requestWhenInUseAuthorization()
            
            // 如果是iOS9.0之后, 当前授权状态是前台定位授权状态, 也想在后台获取用户的位置信息,那么需要满足以下条件
            // 1. 勾选后台模式   2. 设置以下属性为true(OC, 里面是YES)
            if #available(iOS 9.0, *) {
                locationM.allowsBackgroundLocationUpdates = true
            }
            locationM.desiredAccuracy = kCLLocationAccuracyBest // 设置精确度
        }
        return locationM
    }()
    
    // MARK: - 点击屏幕开始定位
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 定位: 标准定位服务 (gps/wifi/蓝牙/基站)
        locationM.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 代理
extension ViewController: CLLocationManagerDelegate {
    
    // 当获取到用户位置信息时调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        
        // 当前位置
        guard let newLocation = locations.last else {return}
        
        // 容错判断
        if newLocation.horizontalAccuracy < 0 { return }
        
        
        // 场景演示:打印当前用户的行走方向,偏离角度以及对应的行走距离
        // 例如:”北偏东 30度 方向,移动了 8米”
        
        // 实现步骤:
        // 1> 获取对应的方向偏向(例如”正东”,”东偏南”)
        // 2> 获取对应的偏离角度(并判断是否是正方向)
        // 3> 计算行走距离
        // 4> 打印信息
        
        // 1. 获取当前的行走航向 (算法: 根据航向course, 整除90, 判断出对应的方位)
        let courseStrs : [String] = ["北偏东", "东偏南", "南偏西", "西偏北"] // 定义数组，各个值为0，1，2，3
        let index : Int = Int(newLocation.course) / 90   // 将当前位置/90所得即是数组索引
        var courseStr : String = courseStrs[index]       // 当前的方向
        
        // 2. 行走的偏离角度
        let courseAngle : Int = Int(newLocation.course) % 90 // 取余
        
        // 如果能整除，就是正方向
        if Int(courseAngle) == 0 {
            let index = courseStr.characters.index(courseStr.startIndex, offsetBy: 1) // 截取数组的字符串的第1个
            courseStr = "正" + courseStr.substring(to: index)   // 拼接（正x方向）
        }
        
        // 3. 移动了多少米（计算当前位置和上一次的位置的距离）
        let lastLocation = lastLoc ?? newLocation
        let distance = newLocation.distance(from: lastLocation)
        lastLoc = newLocation
        
        // 4. 合并字符串, 打印（ 例如:”北偏东 30度 方向,移动了 8米” ）
        if courseAngle == 0{
            print("正\(courseStr)方向,移动了\(distance)米")
        }else{
            print("\(courseStr)\(courseAngle)度方向,移动了\(distance)米")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
}


