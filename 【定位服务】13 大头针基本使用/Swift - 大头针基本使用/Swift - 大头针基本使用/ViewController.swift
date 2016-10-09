//
//  ViewController.swift
//  Swift - 大头针基本使用
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1、创建一个大头针数据模型
        let annotation: TDAnnotation = TDAnnotation()
        
        // 2、大头针数据模型的属性
        annotation.coordinate = mapView.centerCoordinate
        annotation.title = "大头针弹框的标题"
        annotation.subtitle = "大头针弹框的子标题"
        
        // 3、添加大头针数据模型, 到地图上
        mapView.addAnnotation(annotation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 获取所有的大头针数据模型
        let annotations = mapView.annotations
        
        // 2. 移除大头针
        mapView.removeAnnotations(annotations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = "用户位置的标题"
        userLocation.subtitle = "用户位置的标题"
    }
}

