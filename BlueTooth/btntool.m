//
//  btntool.m
//  BlueTooth
//
//  Created by sq-ios48 on 16/4/14.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "btntool.h"

@implementation btntool
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.order forKey:@"order"];
    [aCoder encodeObject:self.btnName forKey:@"name"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.btnName=[aDecoder decodeObjectForKey:@"name"];
        self.order=[aDecoder decodeObjectForKey:@"order"];
        }
    return self;
}
@end
