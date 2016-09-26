//
//  ViewController.m
//  OC - 地理编码和反地理编码
//
//  Created by 蓝田 on 2016/9/26.
//  Copyright © 2016年 Loto. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;// 地址
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;// 纬度
@property (weak, nonatomic) IBOutlet UITextField *longitudeUITextField;// 经度
@property(nonatomic, strong) CLGeocoder *geoCoder;   // 用作地理编码、反地理编码的工具类
@end

@implementation ViewController

#pragma mark - 懒加载
- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

#pragma mark - 地理编码(地址->经纬度)
- (IBAction)geoCode:(UIButton *)sender {
    
    // 判断输入地址的 text 是否为空
    if ([self.addressTextView.text length] == 0) {
        return;
    }
    
#pragma mark - 地理编码方案1：根据地址字符串解析，进行地理编码（返回结果可能有多个，因为一个地点有重名）
    [self.geoCoder geocodeAddressString:self.addressTextView.text
                      completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                          
                          // 防错处理
                          if (error || placemarks.count == 0) {
                              NSLog(@"地理编码错误:%@", error);
                              return;
                          }
                          
                          // 罗列出所有搜索到的地址名称
                          for (CLPlacemark *placemark in placemarks) {
                              NSLog(@"所有搜索到的地址名称:%@",placemark.name);
                          }
                          
                          // 一个placemark对应一个地理坐标,包含一个地方的信息(因为可能有多种结果,所有是一个数组,因此要给用户一个列表去选择)
                          CLPlacemark *placemark = [placemarks firstObject]; // 包含区，街道等信息的地标对象
                          NSLog(@"搜索到的第一个城市名:%@,搜索到的第一个地址名称:%@", placemark.locality, placemark.name);
                          
                          // 显示搜索到的第一个地址名称，到 addressTextView 中
                          self.addressTextView.text = [NSString stringWithFormat:@"%@", placemark.name];
                          // 显示纬度(拼接字符串)，到 latitudeTextField
                          self.latitudeTextField.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                          // 显示经度(拼接字符串)，到 longitudeUITextField
                          self.longitudeUITextField.text =[NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                      }];
    
    
#pragma mark - 地理编码方案2：在区域内根据地址字符串解析，进行地理编码（更加精确）
    [self.geoCoder geocodeAddressString:self.addressTextView.text
                               inRegion:nil
                      completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                          
                          // 防错处理
                          if (error || placemarks.count == 0) {
                              NSLog(@"地理编码错误:%@", error);
                              return;
                          }
                          
                          // 罗列出所有搜索到的地址名称
                          for (CLPlacemark *placemark in placemarks) {
                              NSLog(@"所有搜索到的地址名称:%@",placemark.name);
                          }
                          
                          // 一个placemark对应一个地理坐标,包含一个地方的信息(因为可能有多种结果,所有是一个数组,因此要给用户一个列表去选择)
                          CLPlacemark *placemark = [placemarks firstObject]; // 包含区，街道等信息的地标对象
                          NSLog(@"搜索到的第一个城市名:%@,搜索到的第一个地址名称:%@", placemark.locality, placemark.name);
                          
                          // 显示搜索到的第一个地址名称，到 addressTextView 中
                          self.addressTextView.text = [NSString stringWithFormat:@"%@", placemark.name];
                          // 显示纬度(拼接字符串)，到 latitudeTextField
                          self.latitudeTextField.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                          // 显示经度(拼接字符串)，到 longitudeUITextField
                          self.longitudeUITextField.text =[NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                      }];
    
#pragma mark - 地理编码方案3：根据地址信息字典解析，进行地理编码(不推荐)
    NSDictionary *addressDic = @{
                                 (__bridge NSString *)kABPersonAddressStreetKey:@"杭州",(__bridge NSString *)kABPersonAddressStreetKey:@"上海"
                                 };
    
    [self.geoCoder geocodeAddressDictionary:addressDic
                          completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                              // code
                          }];
}

#pragma mark - 清空
- (IBAction)clearButton:(UIButton *)sender {
    self.addressTextView.text = NULL;
    self.latitudeTextField.text = NULL;
    self.longitudeUITextField.text = NULL;
}

#pragma mark - 反地理编码：根据给定的经纬度，获得具体的位置信息
- (IBAction)reverseGeoCode:(UIButton *)sender {
    
    // 过滤空数据
    if ([self.latitudeTextField.text length] == 0 ||
        [self.longitudeUITextField.text length] == 0) {
        return;
    }
    
    // 创建CLLocation对象
    double latitude = [self.latitudeTextField.text doubleValue];
    double longitude = [self.longitudeUITextField.text doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 根据CLLocation对象进行反地理编码
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                            
                            // 防错处理
                            if (error || placemarks.count == 0) {
                                NSLog(@"反地理编码错误:%@", error);
                                return;
                            }
                            
                            // 罗列出所有搜索到的地址名称
                            for (CLPlacemark *placemark in placemarks) {
                                NSLog(@"所有搜索到的地址名称:%@",placemark.name);
                            }
                            
                            //   一个placemark对应一个地理坐标,包含一个地方的信息(因为可能有多种结果,所有是一个数组,因此要给用户一个列表去选择)
                            CLPlacemark *placemark = [placemarks firstObject]; // 包含区，街道等信息的地标对象
                            NSLog(@"搜索到的第一个城市名:%@,搜索到的第一个地址名称:%@", placemark.locality, placemark.name);
                            
                            // 显示地址方法1：
                            // for (CLPlacemark *placemark in placemarks) {
                            // self.addressTextView.text = placemark.name; //具体地名
                            // }
                            
                            // 显示地址方法2：显示搜索到的第一个地址名称，到 addressTextView 中
                            self.addressTextView.text = [NSString stringWithFormat:@"%@", placemark.name];
                            
                            // 显示纬度(拼接字符串)，到 latitudeTextField
                            self.latitudeTextField.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                            // 显示经度(拼接字符串)，到 longitudeUITextField
                            self.longitudeUITextField.text =[NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                        }];
}

#pragma mark - 退出键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
