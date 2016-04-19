//
//  YSFunctionTableViewController.m
//  BlueTooth
//
//  Created by sq-ios40 on 16/4/18.
//  Copyright © 2016年 BFMobile. All rights reserved.
//
#define arraycount  4
#define filePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"btninfo.plist"]
#import "YSFunctionTableViewController.h"

@interface YSFunctionTableViewController ()

@end

@implementation YSFunctionTableViewController
{
    NSMutableArray *arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    arr=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SQResusableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SQResusableCell"];
    }
    NSString *str =[arr[indexPath.row] valueForKey:@"name"];
     NSString *str2 =[arr[indexPath.row] valueForKey:@"order"];
    cell.textLabel.text = [NSString stringWithFormat:@"functionName:%@",str];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"HEXOrder:   %@",str2];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
