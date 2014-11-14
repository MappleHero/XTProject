//
//  TNBaseResponse.h
//  XTrain
//
//  Created by Ben on 14/11/14.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkResponse.h"
#import <Mantle/Mantle.h>

FOUNDATION_EXPORT NSString *const TNResponseErrorDomain;

typedef NS_ENUM(NSInteger, TNResponseCode)
{
    TNResponseCodePaserJSONFailed = 1000,
    TNResponseCodeSuccess = 710000
};

@interface TNBaseResponse : XTNetworkResponse

/**
 *  reponse data 解析的JSON串
 */
@property (nonatomic, strong) NSDictionary *JSONDic;

/**
 *  JSONDic序列化的对象
 */
@property (nonatomic, strong) MTLModel *model;

/**
 *  序列化对象的类名，默认为nil
 *  
 *  子类覆写以把JSONDic的data字段的值序列化成对象，类必须是MTLModel的子类
 *
 *  @return 序列化对象的类名
 */
- (NSString *)modelClassName;

@end
