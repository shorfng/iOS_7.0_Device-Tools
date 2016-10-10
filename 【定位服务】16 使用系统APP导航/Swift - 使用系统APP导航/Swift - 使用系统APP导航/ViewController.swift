//
//  ViewController.swift
//  Swift - 使用系统APP导航
//
//  Created by 蓝田 on 16/9/19.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK: - 懒加载
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: - 地理编码（导航包括:起点和终点  数据由苹果处理）
        geoCoder.geocodeAddressString("广州") { (pls: [CLPlacemark]?, error) -> Void in
            // 1. 拿到广州地标对象
            let gzPL = pls?.first
            
            self.geoCoder.geocodeAddressString("上海") { (pls: [CLPlacemark]?, error) -> Void in
                // 2. 拿到上海地标对象
                let shPL = pls?.first
                
                // 3. 调用开始导航的方法（从广州到上海）
                self.beginNav(gzPL!, endPLCL: shPL!)
            }
        }
    }
    
    //MARK: - 开始导航
    func beginNav(_ startPLCL: CLPlacemark, endPLCL: CLPlacemark) {
        
        // 获取起点
        let startplMK: MKPlacemark = MKPlacemark(placemark: startPLCL)
        let startItem: MKMapItem = MKMapItem(placemark: startplMK)
        
        // 获取终点
        let endplMK: MKPlacemark = MKPlacemark(placemark: endPLCL)
        let endItem: MKMapItem = MKMapItem(placemark: endplMK)
        
        // 设置起点和终点
        let mapItems: [MKMapItem] = [startItem, endItem]
        
        // 设置导航地图启动项参数字典
        let dic: [String : AnyObject] = [
            // 导航模式:驾驶
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving as AnyObject,
            // 地图样式：标准样式
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue as AnyObject,
            // 显示交通：显示
            MKLaunchOptionsShowsTrafficKey: true as AnyObject
        ]
        
        // 根据 MKMapItem 的起点和终点组成数组, 通过导航地图启动项参数字典, 调用系统的地图APP进行导航
        MKMapItem.openMaps(with: mapItems, launchOptions: dic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

