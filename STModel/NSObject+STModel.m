//
//  NSObject+STModel.m
//  STModel
//
//  Created by 周远明 on 2019/7/16.
//  Copyright © 2019 周远明. All rights reserved.
//

#import "NSObject+STModel.h"
#import <objc/runtime.h>

@implementation NSObject (STModel)

// 字典转模型
+ (instancetype)st_setValueForKeysWithDictionary:(NSDictionary *)dictionary
{
    id obj = [self new];
    [obj st_configDictionary:dictionary];
    return obj;
}

- (instancetype)st_configDictionary:(NSDictionary *)dictionary
{
    Class cls = [self class];
    unsigned int propertyCount = 0;
    objc_property_t * propertys = class_copyPropertyList(cls, &propertyCount);
    for (NSInteger i = 0; i < propertyCount; ++ i) {
        objc_property_t property = propertys[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id dicValue = [dictionary valueForKey:propertyName];
        if (!dicValue) continue;
        NSString * propertyType = [self st_propertyTypeOfProperty:property];
        if ([propertyType hasPrefix:@"@"]) {// 对象类型
            NSString * type = [propertyType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            if (![type hasPrefix:@"NS"]) {// 非系统对象类
                Class cls = NSClassFromString(type);
                dicValue = [cls st_setValueForKeysWithDictionary:dicValue];// 循环调用
                if (dicValue) {
                    [self setValue:dicValue forKey:propertyName];
                }
            }else{
                if ([type isEqualToString:@"NSString"]) {
                    [self setValue:dicValue forKey:propertyName];
                }else if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSMutableArray"]){
                    // 数组
                }
            }
        }else if (![propertyType isEqualToString:@"STOther"]){// 基本类型
            if ([propertyType isEqualToString:@"BOOL"]) {
                if ([dicValue isKindOfClass:[NSString class]]) {
                    NSString * lowerValue= [dicValue lowercaseString];
                    if ([lowerValue isEqualToString:@"yes"] || [lowerValue isEqualToString:@"true"]) {
                        dicValue = @(YES);
                    }else {
                        dicValue = @(NO);
                    }
                }
            }
            [self setValue:dicValue forKey:propertyName];
        }
    }
    return self;
}

- (NSString *)st_propertyTypeOfProperty:(objc_property_t)property
{
    NSString * type = @"STOther";
    NSString * propertyAttrs = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSArray * array = [propertyAttrs componentsSeparatedByString:@","];
    NSString * firstStr = array.firstObject;
    if ([firstStr hasPrefix:@"T@\""]) {
        NSString * strType = firstStr;
        strType = [strType substringWithRange:NSMakeRange(1, firstStr.length - 1)];
        strType = [strType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        type = strType;
    }else{
        NSString * strType = firstStr;
        if ([strType isEqualToString:@"Tq"]) {
            type = @"NSInteger";
        }else if ([strType isEqualToString:@"TB"]){
            type = @"BOOL";
        }else if ([strType isEqualToString:@"Td"]){
            type = @"CGFloat";
        }
    }
    return type;
}

@end
