//
//  ViewController.swift
//  Swift - 大头针场景模拟
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

// 场景描述：鼠标点击在地图哪个位置, 就在对应的位置添加一个大头针, 并在标注弹框中显示对应的城市和街道;
import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - 地理编码懒加载
    lazy var geoCoder : CLGeocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - 点击屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 1. 获取当前触摸点所在的位置
        let point = touches.first?.location(in: mapView)
        
        // 2. 将从mapView上获取的点转换对应的经纬度坐标
        let coordinate = mapView.convert(point!, toCoordinateFrom: mapView)
        
        // 3.1 根据经纬度创建大头针数据模型
        let annotation = TDAnnotation(coordinate:coordinate, title: "大头针弹框的标题", subtitle: "大头针弹框的子标题")
        
        // 4. 进行反地理编码
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (pls:[CLPlacemark]?, error:Error?) in
            
            if error == nil {
                let pl = pls?.first // 这里取第一个
                print(pl)
                
                // 赋值
                annotation.title = pl?.locality
                annotation.subtitle = pl?.name
            }
        }
        // 3.2 添加大头针数据模型到地图
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

