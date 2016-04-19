//
//  UIBarButtonItem+Extension.h
//  YUSIR微博客户端2.0
//
//  Created by sq-ios40 on 16/3/17.
//  Copyright © 2016年 YUSIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
