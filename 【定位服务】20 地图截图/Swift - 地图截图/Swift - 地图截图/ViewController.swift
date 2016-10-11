//
//  ViewController.swift
//  Swift - 地图截图
//
//  Created by 蓝田 on 16/9/20.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 地图截图
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 创建截图附加选项 - option
        let option: MKMapSnapshotOptions = MKMapSnapshotOptions()
        
        // 2. 设置截图附加选项 - option
        option.mapRect = mapView.visibleMapRect  // 设置地图区域
        option.region = mapView.region       // 设置截图区域(在地图上的区域,作用在地图)
        option.mapType = .standard           // 截图的地图类型
        option.showsPointsOfInterest = true  // 是否显示POI
        option.showsBuildings = true         // 是否显示建筑物
        // option.size = CGSize(width: 100, height: 100)// 设置截图后的图片大小(作用在输出图像)
        option.size = self.mapView.frame.size    // 设置截图后的图片大小(作用在输出图像)
        option.scale = UIScreen.main.scale       // 设置截图后的图片比例（默认是屏幕比例， 作用在输出图像）
        
        // 3. 创建截图对象
        let snapShoter = MKMapSnapshotter(options: option)
        
        // 4. 开始截图
        snapShoter.start { (shot:MKMapSnapshot?, error:Error?) in
            
            if error == nil {
                // 获取到截图图像
                let image = shot?.image
                // 将截图转换成为NSData数据
                let data = UIImagePNGRepresentation(image!)
                // 将图像保存到指定路径
                try? data?.write(to: URL(fileURLWithPath: "/Users/TD/Desktop/test.png"), options: [.atomic])
            }else {
                print("截图错误")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

