//
//  ViewController.swift
//  Swift - 自定义大头针
//
//  Created by 蓝田 on 16/9/18.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: - 地图懒加载
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - 地理编码懒加载
    lazy var geoCoder : CLGeocoder = CLGeocoder()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    //MARK: - 触摸屏幕，添加大头针数据模型
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 获取当前触摸点所在的位置
        let point = touches.first?.location(in: mapView)
        
        // 2. 把触摸点所在的位置, 转换成为在地图上的经纬度坐标
        let coordinate =  mapView.convert(point!, toCoordinateFrom: mapView)
        
        // 3.1 创建大头针数据模型
        
        // 方法1：使用系统大头针数据模型
        // let annotation = MKUserLocation()
        // 这个赋值操作会报错, 因为该属性是只读属性, 所以, 系统提供的大头针数据模型, 我们没法使用,只能自定义大头针数据模型
        // annotation.location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        // 方法2：使用自定义大头针数据模型
        let annotation = TDAnnotation(coordinate: coordinate, title: "大头针弹框的标题", subtitle: "大头针弹框的子标题")
        
        // 4. 反地理编码
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (pls:[CLPlacemark]?, error:Error?) in
            if error  == nil
            {
                let pl = pls!.first
                
                annotation.title = pl?.locality
                annotation.subtitle = pl?.name
            }
        }
        // 3.2 添加大头针数据模型到地图
        mapView.addAnnotation(annotation)
    }
    
    //MARK: - 移除大头针数据模型
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("移除大头针数据模型时, 调用了这个方法")
        mapView.removeAnnotations(mapView.annotations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// 代理方法
extension ViewController: MKMapViewDelegate {
    // 根据传进来的 annotation 参数创建并返回对应的大头针控件
    // 当添加大头针数据模型时，会调用此方法，获取对应的大头针视图。如果返回nil，则会显示系统默认的大头针视图。
    // 系统默认的大头针视图对应的类 MKPinAnnotationView，大头针视图与tableview中的cell一样, 都使用“循环利用”的机制
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("添加大头针数据模型时, 调用了这个方法")
        
//MARK: - 默认运行会显示案例1效果，注释案例1可以看到案例2的效果
        
//  ================= 自定义方法案例1（模拟系统默认的大头针视图）
        
        // 0. 从缓存池取出大头针视图
        let ID1 = "PinAnnotationView"
        
        // 1. MKPinAnnotationView 有界面,默认不能显示图片
        // 将 MKAnnotationView 类型转换为 MKPinAnnotationView
        var PinAnnotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: ID1) as! MKPinAnnotationView?
        
        // 2. 如果为空，则创建
        if PinAnnotationView == nil{
            PinAnnotationView = MKPinAnnotationView(annotation: annotation,
                                                    reuseIdentifier: ID1)
        }
        
        // 3. 传递模型数据，重新赋值, 防止循环利用时, 产生的数据错乱
        PinAnnotationView?.annotation = annotation
        
        // 4. 设置大头针可以弹框
        PinAnnotationView?.canShowCallout = true
        
        // 5. 设置大头针的颜色
        if #available(iOS 9.0, *) {
            // iOS9.0以后, 可以设置任意颜色(MKAnnotationView没有此方法)
            PinAnnotationView?.pinTintColor = UIColor.black
        } else {
            // iOS 8.0的方法,只有3种颜色(MKAnnotationView没有此方法)
            PinAnnotationView?.pinColor = MKPinAnnotationColor.green
        }
        
        // 6. 设置大头针下落动画(MKAnnotationView没有此方法)
        PinAnnotationView?.animatesDrop = true
        
        return PinAnnotationView
        
//  ================= 自定义方法案例1（模拟系统默认的大头针视图）
        
        
//  ================= 自定义方法案例2（自定义大头针）
        
        // 1. 从缓存池取出大头针视图
        let ID2 = "annotationView"
        // MKAnnotationView 默认没有界面,可以显示图片
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ID2)
        
        // 2. 如果为空，则创建
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ID2)
        }
        
        // 3. 重新赋值, 防止循环利用时, 产生的数据错乱
        annotationView!.annotation = annotation
        
        // 4. 设置大头针图片
        annotationView!.image = UIImage(named: "1")
        
        // 5. 设置大头针中心偏移量
        annotationView?.centerOffset = CGPoint(x: 0, y: 0)
        
        // 6. 设置可以弹框
        annotationView!.canShowCallout = true
        // 设置弹框的偏移量
        annotationView?.calloutOffset = CGPoint(x: -10, y: 10)
        
        // 6.1 设置弹框左侧视图
        let leftIMV = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftIMV.image = UIImage(named: "huba")
        annotationView?.leftCalloutAccessoryView = leftIMV
        
        // 6.2 设置弹框右侧视图
        let rightIMV = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightIMV.image = UIImage(named: "htl")
        annotationView?.rightCalloutAccessoryView = rightIMV
        
        // 6.3 设置下部弹框（详情视图）,会把子标题覆盖
        if #available(iOS 9.0, *) {
            annotationView?.detailCalloutAccessoryView = UISwitch()
        }
        
        // 7. 设置大头针可以拖动
        annotationView?.isDraggable = true
        
        return annotationView
        
        //  ================= 自定义方法案例2（自定义大头针）
        
    }
    
    // MARK: - 选中一个大头针时调用的方法
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("选中了大头针---\(view.annotation?.title)")
    }
    
    // MARK: - 取消选中某个大头针时调用的方法
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("取消选中了大头针---\(view.annotation?.title)")
    }
}

