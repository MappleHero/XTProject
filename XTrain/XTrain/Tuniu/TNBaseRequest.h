//
//  TNBaseRequest.h
//  XTrain
//
//  Created by Ben on 14/11/14.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkRequest.h"

typedef NS_ENUM(NSInteger, TNRequestServerType)
{
    TNRequestServerTypeHTTP = 0,
    TNRequestServerTypeDynamicHTTP,
    TNRequestServerTypeHTTPS,
    TNRequestServerTypeChat
};

@interface TNBaseRequest : XTNetworkRequest

/**
 *  获取请求的服务器类型，子类覆写，默认为HTTP
 *
 *  @return 服务器类型
 */
- (TNRequestServerType)requestServerType;

@end
