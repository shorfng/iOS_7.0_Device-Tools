//
//  ViewController.swift
//  Swift - 单次定位
//
//  Created by 蓝田 on 16/9/21.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - 懒加载
    lazy var locationM : CLLocationManager = {
        
        // 1. 创建位置管理者（需要强引用，否则一出现就会消失）强引用后，UI控件创建时会添加到subviews数组里,作用域结束时也不会释放
        let locationM : CLLocationManager = CLLocationManager()
        
        // 2. 设置代理, 接收位置数据（其他方式：block、通知）
        locationM.delegate = self
        
        // 3. 请求用户授权 --- ios8之后才有(配置info.plist文件)
        // 判断系统版本
        if (Float(UIDevice.current.systemVersion)! >= 8.0){
            locationM.requestAlwaysAuthorization()// 前后台定位授权
            // locationM.requestWhenInUseAuthorization()  // 前台定位授权
        }
        
        // 4. 设置过滤距离
        // 如果当前位置, 距离上一次的位置之间的物理距离大于以下数值时, 就会通过代理, 将当前位置告诉外界
        locationM.distanceFilter = 100   // 每隔100 米定位一次
        
        // 5. 设置定位的精确度（定位精确度越高, 越耗电, 定位的速度越慢）
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - 点击屏幕，开始更新用户位置
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 方法1：标准定位服务（使用位置管理器进行定位）
        // 开始更新位置信息（一旦调用了这个方法, 就会不断的刷新用户位置, 然后告诉外界）
        // 以下代码默认只能在前台获取用户的位置信息, 如果想要在后台获取用户的位置信息, 那么需要勾选后台模式 location updates
        // 小经验: 如果以后使用位置管理者这个对象, 实现某个服务, 可以用startXX开始某个服务，stopXX停止某个服务
        locationM.startUpdatingLocation()
        
        // 方法2：监听重大位置变化的服务(基于基站进行定位)（显著位置变化定位服务）
        // locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// 类扩展（CLLocationManager的代理方法）
extension ViewController: CLLocationManagerDelegate {
    
    // 代理方法：当位置管理器获取到用户位置后，就会调用此方法
    // 参数: (manager:位置管理者) (locations: 位置对象数组)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("位置信息:%@", locations)
        
        // 停止定位(代理方法一直调用,会非常耗电，除非特殊需求，如导航）
        // 只想获取一次用户位置信息,那么在获取到位置信息之后,停止更新用户的位置信息
        // 应用场景: 获取用户所在城市
        manager.stopUpdatingLocation()
    }
    
    // 代理方法：当用户的定位授权状态发生变化时调用
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case CLAuthorizationStatus.notDetermined:
            print("1.用户还未决定定")
        case CLAuthorizationStatus.restricted:
            print("2.访问受限(苹果预留选项,暂时没用)")
        // 定位关闭时 and 对此APP授权为never时调用
        case CLAuthorizationStatus.denied:
            // 定位是否可用（是否支持定位或者定位是否开启）
            if (CLLocationManager.locationServicesEnabled()){
                print("3.定位服务是开启状态，需要手动授权，即将跳转设置界面")
                
                // 在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权在iOS8.0之后跳转到"设置"界面代码
                var settingURL:URL?
                
                if (Float(UIDevice.current.systemVersion)! >= 8.0){
                    settingURL = URL(string: UIApplicationOpenSettingsURLString)
                }else{
                    // 设置app scheme
                    settingURL = URL(string: "prefs:root=LOCATION_SERVICES")
                }
                
                if (UIApplication.shared.canOpenURL(settingURL!)){
                    UIApplication.shared.openURL(settingURL!)
                    print("已经成功跳转到设置界面")
                }
            }else{
                print("定位关闭，不可用")
            }
        case CLAuthorizationStatus.authorizedAlways:
            print("4.获取前后台定位授权")
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("5.获得前台定位授权")
        }
    }
}




