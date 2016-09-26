//
//  ViewController.swift
//  Swift - 地理编码和反地理编码
//
//  Created by 蓝田 on 2016/9/23.
//  Copyright © 2016年 Loto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var addressTextView: UITextView!       // 地址
    @IBOutlet weak var latitudeTextField: UITextField!    // 纬度
    @IBOutlet weak var longitudeUITextField: UITextField! // 经度
    
    // MARK: - 懒加载
    lazy var geoCoder : CLGeocoder = {
        return CLGeocoder()
    }()
    
    // MARK: - 地理编码(地址->经纬度)
    @IBAction func geoCode(_ sender: UIButton) {
        
        let address = addressTextView.text
        
        geoCoder.geocodeAddressString(address!) { (placemarks : [CLPlacemark]?, error :Error?) in
            
            if error == nil{
                print("地理编码成功")
                
                guard let pls = placemarks else {return}
                let firstPL = pls.first
                
                self.addressTextView.text = firstPL?.name
                self.latitudeTextField.text = "\(firstPL?.location?.coordinate.latitude)"
                self.longitudeUITextField.text = "\(firstPL?.location?.coordinate.longitude)"
            }else {
                print("地理编码错误！！！")
            }
        }
    }
    
    // MARK: - 清空
    @IBAction func clearButton(_ sender: UIButton) {
        self.addressTextView.text = nil
        self.latitudeTextField.text = nil
        self.longitudeUITextField.text = nil
    }
    
    // MARK: - 反地理编码(经纬度->地址)
    @IBAction func reverseGeoCode(_ sender: UIButton) {
        
        let latitude = CLLocationDegrees(latitudeTextField.text!)
        let longitude = CLLocationDegrees(longitudeUITextField.text!)
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks :[CLPlacemark]?, error :Error?) in
            
            if error == nil{
                print("反地理编码成功")

                guard let pls = placemarks else {return}
                let firstPL = pls.first
                
                self.addressTextView.text = firstPL?.name
                self.latitudeTextField.text = "\(firstPL?.location?.coordinate.latitude)"
                self.longitudeUITextField.text = "\(firstPL?.location?.coordinate.longitude)"
            }else {
                print("反地理编码错误！！！")
            }
        }
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

