//
//  XTEncodeUtil.h
//  XTrain
//
//  Created by Ben on 14-5-9.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//
//  Some methods was imported from FXBase64Util which maintained by Lenoard.
//  Thanks to him.
//

#import <Foundation/Foundation.h>

/**
 *  编解码工具类
 */
@interface XTEncodeUtil : NSObject

#pragma mark - Base64

/**
 对于字符串类型进行base64加密
 
 @param strData 需要加密的数据
 
 @return 加密结果
 */
+ (NSString *)encodeBase64WithString:(NSString *)strData;

/**
 对于纯数据类型进行base64加密
 
 @param objData 需要加密的数据
 
 @return 加密结果
 */
+ (NSString *)encodeBase64WithData:(NSData *)objData;


/**
 base64解密方法
 
 @param strBase64 需要解密的数据
 
 @return 解密结果
 */
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

@end
