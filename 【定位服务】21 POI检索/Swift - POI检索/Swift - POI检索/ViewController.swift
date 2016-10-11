//
//  ViewController.swift
//  Swift - POI检索
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // MARK: - POI检索
        // 1. 创建一个POI请求
        let request: MKLocalSearchRequest = MKLocalSearchRequest()
        
        // 2.1 设置请求检索的关键字
        request.naturalLanguageQuery = "银行"
        // 2.2 设置请求检索的区域范围
        request.region = mapView.region
        
        // 3. 根据请求创建检索对象
        let search: MKLocalSearch = MKLocalSearch(request: request)
        
        // 4. 使用检索对象, 检索对象
        search.start { (response:MKLocalSearchResponse?, error:Error?) in
            
            if error == nil {
                // 响应对象MKLocalSearchResponse,里面存储着检索出来的"地图项",每个地图项中有包含位置信息, 商家信息等
                let items = response!.mapItems
                
                for item in items {
                    // 遍历所有的关键字搜到的结果的名称
                    print(item.name) // 最多只能打印10条数据
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

