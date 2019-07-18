//
//  NSObject+STModel.h
//  STModel
//
//  Created by 周远明 on 2019/7/16.
//  Copyright © 2019 周远明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (STModel)

/**
 * 字典转模型
 * @param dictionary 待转的字典
 */
+ (instancetype)st_setValueForKeysWithDictionary:(NSDictionary *)dictionary;

@end
