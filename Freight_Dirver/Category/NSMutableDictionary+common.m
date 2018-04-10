//
//  NSMutableDictionary+common.m
//  Freight_Company
//
//  Created by ToneWang on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "NSMutableDictionary+common.h"

@implementation NSMutableDictionary (common)

- (void)addUnEmptyString:(NSString *)stringObject forKey:(NSString *)key{
    if (stringObject==nil || [stringObject isEqualToString:@""]) {
        return;
    }else{
        [self setObject:stringObject forKey:key];
    }
}

@end
