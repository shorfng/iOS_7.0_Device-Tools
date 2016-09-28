//
//  ViewController.swift
//  Swift - 区域监听
//
//  Created by 蓝田 on 2016/9/28.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var Label: UILabel!
    
    lazy var locationM: CLLocationManager = {
        
        let locationM = CLLocationManager()
        locationM.delegate = self
        
        // 请求授权 配置key
        if #available(iOS 8.0, *) {
            locationM.requestAlwaysAuthorization()
        }
        return locationM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果想要进行区域监听, 在ios8.0之后, 必须要请求用户的位置授权
        
        // 0. 先判断区域监听是否可用
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
        
        // 1. 创建区域中心
        let center = CLLocationCoordinate2DMake(21.123, 124.345)
        var distance: CLLocationDistance = 10
        
        // 区域半径如果大于最大区域监听半径，则无法监听成功
        if distance > locationM.maximumRegionMonitoringDistance {
            distance = locationM.maximumRegionMonitoringDistance
        }
        
        // 根据区域中心和区域半径创建一个区域
        let region  = CLCircularRegion(center: center, radius: distance, identifier: "TD")
        
        // 2. 开始监听指定区域 (这个方法, 只会当进入或者离开区域这个动作触发时, 才会调用对应的代理方法)
        locationM.startMonitoring(for: region)
        
        // 请求获取某个区域的当前状态
        locationM.requestState(for: region)
        
        }else{
            print("区域监听不可用")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // 进入区域时调用
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("进入区域--" + region.identifier)
        Label.text = "进入区域"
    }
    
    // 离开区域时调用
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("离开区域--" + region.identifier)
        Label.text = "离开区域"
    }
    
    // 当请求某个区域状态时, 如果获取到对应状态就会调用这个方法
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if region.identifier == "TD" {
            if state == CLRegionState.inside{
                Label.text = "您已进入---" + region.identifier + "区域"
            }else if state == CLRegionState.outside {
                Label.text = "您已离开---" + region.identifier + " 区域"
            }else {
                Label.text = "其他"
            }
        }
    }    
}

