//
//  functionViewController.m
//  BlueTooth
//
//  Created by sq-ios48 on 16/4/14.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "functionViewController.h"
#import "DKCircleButton.h"
#import "btntool.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIBarButtonItem+Extension.h"

#import "YSFunctionTableViewController.h"
//#import "WEPopoverController.h"
//#import "WEPopoverContentViewController.h"
#define filePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"btninfo.plist"]
#define MyDeviceName @"BT05"
//#define Center self.view.center
//#define Centerx SCREEN_WIDTH/2
#define Centerx self.view.center.x
//#define Centery SCREEN_HEIGHT/2
#define Centery self.view.center.y
#define width 75
#define height 100
#define arraycount  4
#define buttonSquareSide 150
//界面相关
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//CGFloat centerwidth= SCREEN_WIDTH/2;
//CGFloat centerheight = SCREEN_HEIGHT/2;
@interface functionViewController ()
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property(nonatomic,strong)NSMutableArray *btninfo;
@property(nonatomic,strong)btntool *btn;
@property(nonatomic,assign)NSInteger num;
@property (nonatomic,strong) UIBarButtonItem* rightbutton;
@end

@implementation functionViewController
{
    
    DKCircleButton *button1;
    DKCircleButton *button2;
    DKCircleButton *button3;
    DKCircleButton *button4;
    
}
//@synthesize popoverController;
-(btntool *)btn
{
    if (_btn==nil) {
        _btn=[[btntool alloc]init];
    }
    return _btn;
}
-(NSMutableArray *)btninfo
{
    if (_btninfo==nil) {
        _btninfo=[[NSMutableArray alloc]initWithCapacity:arraycount];
    }
    return _btninfo;
}
- (void)viewDidLoad {
//    [self.popoverController dismissPopoverAnimated:NO];
//    self.popoverController = nil;
    [super viewDidLoad];
    self.centralMgr=[[CBCentralManager alloc]initWithDelegate:(id)self queue:dispatch_get_main_queue()];
    self.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    self.title = @"Control Center";
    self.rightbutton = [[UIBarButtonItem alloc]initWithTitle:@"Details" style:UIBarButtonItemStylePlain target:self action:@selector(DetailsClicked)];
    self.navigationItem.rightBarButtonItem = self.rightbutton;
    [self setButton];
    [self setBtnTitle];
}
- (void)DetailsClicked {
    YSFunctionTableViewController *functionTableVC = [[YSFunctionTableViewController alloc]init];
    [self.navigationController pushViewController:functionTableVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - popovercontroller
//-(void)popover:(id)sender
//{
//    //the controller we want to present as a popover
//    DemoTableController *controller = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
//    
//    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
//    
//    //popover.arrowDirection = FPPopoverArrowDirectionAny;
//    popover.tint = FPPopoverDefaultTint;
//    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        popover.contentSize = CGSizeMake(300, 500);
//    }
//    popover.arrowDirection = FPPopoverArrowDirectionAny;
//    
//    //sender is the UIButton view
//    [popover presentPopoverFromView:sender];
//}
//
//
//- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
//          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
//{
//    [visiblePopoverController dismissPopoverAnimated:YES];
//}
//
//-(IBAction)topLeft:(id)sender
//{
//    [self popover:sender];
//}
//


#pragma mark --设置按钮的title
-(void)setBtnTitle
{
    NSMutableArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    //NSLog(@"arr:%@",arr);
    int arrcount=(int)arr.count;
    if (arr.count!=arraycount) {
        for (int i=0; i<arraycount-arrcount; i++) {
            NSDictionary *dic=@{@"name":@"",
                                @"order":@"",
                                };
            [arr addObject:dic];
        }
    }
    //NSLog(@"newarr:%@",arr);
    for (int i=0; i<arraycount; i++) {
        DKCircleButton *button=(DKCircleButton *)[self.view viewWithTag:i+1];
        NSString *str =[arr[i] valueForKey:@"name"];
        if (![str isEqualToString:@""]) {
            [button setTitle:str forState:UIControlStateNormal];
        }
       
    }
    
    
}
#pragma mark --设置按钮
- (DKCircleButton *)buttonWithName:(DKCircleButton *)name BtCenter:(CGPoint)center Tag:(NSInteger)tag {
    name =[[DKCircleButton alloc]initWithFrame:CGRectMake(0, 0, buttonSquareSide, buttonSquareSide)];
    name.center = center;
    name.titleLabel.font = [UIFont systemFontOfSize:40];
    [name setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [name setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [name setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    [name setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
    name.tag = tag;
    NSLog(@"btn1:%ld",(long)name.tag);
    [name addTarget:self action:@selector(btnShort) forControlEvents:UIControlEventTouchUpInside];
    [name addTarget:self action:@selector(getTag:) forControlEvents:UIControlEventTouchDown];
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [name addGestureRecognizer:longPress];
    [self.view addSubview:name];
    
    return name;
}
- (void)setButton {
    button1 = [self buttonWithName:button1 BtCenter:CGPointMake(Centerx-width, Centery-height) Tag:1];
    button2 =[self buttonWithName:button2 BtCenter:CGPointMake(Centerx+width, Centery-width) Tag:2];
    button3 =[self buttonWithName:button3 BtCenter:CGPointMake(Centerx-width, Centery+width) Tag:3];
    button4 =[self buttonWithName:button4 BtCenter:CGPointMake(Centerx+width, Centery+height) Tag:4];
}

-(void)getTag :(id)sender
{
    DKCircleButton *button=(DKCircleButton *)sender;
    self.num=button.tag;
//    NSLog(@"tag:%d",button.tag);
//    NSLog(@"####%d",self.num);
}


#pragma mark -- 长按
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSLog(@"长按事件");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"指令更改 " message:@"You can change instructions!" preferredStyle:UIAlertControllerStyleAlert];
        
        //ios9.0之前的写法
        //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Hello, World" message:@"This is my first app!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
        //    [alertView show];
        
        //声明一个取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //[self dismissViewControllerAnimated : YES completion:nil];
        }];
  
        //声明一个登录按钮
        DKCircleButton *but=(DKCircleButton *)[self.view viewWithTag:self.num];
       // NSLog(@"num:%d",self.num);
       // NSLog(@"button :%@",but);
        self.btninfo=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        int arrcount=(int)self.btninfo.count;
        if (self.btninfo.count!=arraycount) {
            for (int i=0; i<arraycount-arrcount; i++) {
                NSDictionary *dic=@{@"name":@"",
                                    @"order":@"",
                                    };
                [self.btninfo addObject:dic];
            }
        }

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString *btnname = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if (![btnname isEqualToString:@""]) {
                self.btn.btnName=btnname;
                [but setTitle:btnname forState:UIControlStateNormal];
                //button.titleLabel.text=btnname;
            }
            NSString *order = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
            if (![order isEqualToString:@""]) {
                self.btn.order=order;
            }
            NSDictionary *dict=@{@"name":self.btn.btnName,
                                 @"order":self.btn.order
                                 };
            NSLog(@"before:%@",self.btninfo);
            [self.btninfo replaceObjectAtIndex:but.tag-1 withObject:dict];
            NSLog(@"now:%@",self.btninfo);
            [NSKeyedArchiver archiveRootObject:self.btninfo toFile:filePath];
            NSLog(@"nowread :%@",self.btninfo);
        }];
        
        //产生第一个文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入新的按键命名";
        }];
        
        
        //产生第二个文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入16进制指令";
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil ];
    }
}

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
-(void)btnShort
{
    NSMutableArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"arr:%@",arr);
    NSString *str=arr[self.num-1][@"order"];
    NSLog(@"num:%zd",self.num);
    NSLog(@"str:%@",str);
    if (![str isEqualToString:@""]) {
        NSData *data=[self convertHexStrToData:str];
        [self writeChar:data];
    }
  
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


@end
