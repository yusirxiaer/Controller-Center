//
//  sendViewController.m
//  BlueTooth
//
//  Created by sq-ios48 on 16/4/14.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "sendViewController.h"
#import "DKCircleButton.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define MyDeviceName @"BT05"
#define Centerx self.view.center.x
#define Centery self.view.center.y
//界面相关
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface sendViewController ()
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (weak, nonatomic) IBOutlet UILabel *equipment;
@property (weak, nonatomic) IBOutlet UITextField *editText;
@property (weak, nonatomic) IBOutlet UILabel *resultText;
@property (nonatomic,strong) DKCircleButton *send;
@end

@implementation sendViewController

#pragma mark - 懒加载
- (DKCircleButton *)send {
    if (_send == nil) {
        
        _send= [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
//        _send.center =CGPointMake(Centerx,Centery);
        NSLog(@"centerx =%f,y = %f",Centerx,Centery);
        _send.titleLabel.font = [UIFont systemFontOfSize:23];
        
        [_send setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
            [_send setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
            [_send setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
        [_send setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
            [_send setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateSelected];
            [_send setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateHighlighted];
        [_send addTarget:self action:@selector(didSend) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_send];
    }
    return _send;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    self.title = @"Debug System";
    self.send.center =CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2-100);
    NSLog(@"%@",self.send);

//    self.send.center = self.view.center;
    self.centralMgr=[[CBCentralManager alloc]initWithDelegate:(id)self queue:dispatch_get_main_queue()];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)didreturn:(id)sender {
//     [self dismissViewControllerAnimated:YES completion:nil];
//}
#pragma mark - CBCentralManager/CBPeripheral Delegate Method
#pragma mark --验证打开设备
//检查App的设备BLE是否可用 （ensure that Bluetooth low energy is supported and available to use on the central device）
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state==CBCentralManagerStatePoweredOn) {
        NSLog(@">>>CBCentralManagerStatePoweredOn");
        //开始扫描周围的外设
        /*
         //第一个参数为CBUUID的数组，需要搜索特点服务的蓝牙设备，只要每搜索到一个符合条件的蓝牙设备都会调用didDiscoverPeripheral代理方法
         第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
         - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
         */
        
        [central scanForPeripheralsWithServices:nil options:nil];
        
    }else
    {
        NSLog(@"蓝牙未正常打开");
    }
}

//找到需要的蓝牙设备，停止搜素，保存数据
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //过滤掉不相干设备，找到需要的蓝牙设备，停止搜素，保存数据
    if([peripheral.name isEqualToString:MyDeviceName]){
        _discoveredPeripheral = peripheral;
        [_centralMgr connectPeripheral:peripheral options:nil];
        self.equipment.text=peripheral.name;
    }
}
//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //Before you begin interacting with the peripheral, you should set the peripheral’s delegate to ensure that it receives the appropriate callbacks（设置代理）
    [_discoveredPeripheral setDelegate:(id)self];
    //discover all of the services that a peripheral offers,搜索服务,回调didDiscoverServices
    [_discoveredPeripheral discoverServices:nil];
}

//连接失败，就会得到回调：
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //此时连接发生错误
    NSLog(@"connected periphheral failed");
}

//获取服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    //我感觉是两台连接设备的Service.UUID
    for (CBService *s in peripheral.services)
    {
        NSLog(@"Service found with UUID : %@", s.UUID);
        //要在method中寻找服务包含了哪些Characteristics
        //Discovering all of the characteristics of a service,回调didDiscoverCharacteristicsForService
        [s.peripheral discoverCharacteristics:nil forService:s];
    }
}

//获取特征后的回调
//我们可以使用例如Characterristic.properties&CBCharacteristicPropertyNotify这样的程序代码来判断每一个Characterristic具备哪种功能。
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    //列出所有的Characterristic
    for (CBCharacteristic *characterristic in service.characteristics)
    {
        NSLog(@"Characterristic.properties:%lu",(unsigned long)characterristic.properties) ;
        //Subscribing to a Characteristic’s Value 订阅
        [peripheral setNotifyValue:YES forCharacteristic:characterristic];
        // read the characteristic’s value，回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:characterristic];
        _writeCharacteristic = characterristic;
    }
    
    //    //列出所有的Characterristic
    //    for (CBCharacteristic *characterristic in service.characteristics)
    //    {
    //        NSLog(@"Characterristic.properties:%lu",(unsigned long)characterristic.properties) ;
    //        //Subscribing to a Characteristic’s Value 订阅
    //        [peripheral setNotifyValue:YES forCharacteristic:characterristic];
    //        // read the characteristic’s value，回调didUpdateValueForCharacteristic
    //        [peripheral readValueForCharacteristic:characterristic];
    //        _writeCharacteristic = characterristic;
    //    }
    
}

//订阅的特征值有新的数据时回调
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
    
    [peripheral readValueForCharacteristic:characteristic];
    
}

// 获取到特征的值时回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    _resultText.text = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark 写数据
-(void)writeChar:(NSData *)data
{
    //回调didWriteValueForCharacteristic
    [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark 写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
}

#pragma mark 发送按钮点击事件
-(void)didSend
{
    NSData *data=[self convertHexStrToData:_editText.text];
    [self writeChar:data];
}
//字符串转16进制，16进制转
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}
#pragma mark - 键盘回收
// 当手指触摸到屏幕，出发该事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 通过放弃第一响应者的身份来回收键盘
    if ([self.editText isFirstResponder]) {
        [self.editText resignFirstResponder];
    }
}


@end
