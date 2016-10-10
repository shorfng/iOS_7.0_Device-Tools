//
//  ViewController.swift
//  Swift - 3D视图
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
    
    // MARK: - 3D视图
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // 设置需要看的位置的中心点
        let center = CLLocationCoordinate2DMake(23.132931, 113.375924)
        
        // 创建3D视图的对象
        // 参数1: 需要看的位置的中心点   参数2: 从哪个地方看   参数3: 站多高看（眼睛的海拔，单位：米）
        let camera: MKMapCamera = MKMapCamera(lookingAtCenter: center,
                                            fromEyeCoordinate: CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001),
                                                  eyeAltitude: 1)
        
         // 设置到地图上显示
        mapView.setCamera(camera, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

