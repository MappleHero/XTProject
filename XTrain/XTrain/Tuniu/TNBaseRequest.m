//
//  TNBaseRequest.m
//  XTrain
//
//  Created by Ben on 14/11/14.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "TNBaseRequest.h"
#import "XTEncodeUtil.h"
#import "TNServerURLConfig.h"

@implementation TNBaseRequest

- (NSString *)baseURLString
{
    NSString *baseURLString = nil;
    switch ([self requestServerType])
    {
        case TNRequestServerTypeHTTP:
            baseURLString = [TNServerURLConfig defaultConfig].HTTPURLString;
            break;
        case TNRequestServerTypeDynamicHTTP:
            baseURLString = [TNServerURLConfig defaultConfig].dynamicHTTPURLString;
            break;
        case TNRequestServerTypeHTTPS:
            baseURLString = [TNServerURLConfig defaultConfig].HTTPURLString;
            break;
        case TNRequestServerTypeChat:
            baseURLString = [TNServerURLConfig defaultConfig].HTTPURLString;
            break;
        default:
            break;
    }
    return baseURLString;
}

- (NSString *)requestURLString
{
    NSMutableString *urlString = [NSMutableString string];
    // Base url
    [urlString appendString:[self baseURLString]];
    // Path
    [urlString appendFormat:@"%@", [self path]];
    // Params
    if ([self params])
    {
        NSData *paramJsonData = [NSJSONSerialization dataWithJSONObject:[self params]
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:nil];
        NSString *query = [XTEncodeUtil encodeBase64WithData:paramJsonData];
        [urlString appendFormat:@"?%@", query];
    }
    
    return urlString;
}

- (TNRequestServerType)requestServerType
{
    // Subclass override
    return TNRequestServerTypeHTTP;
}
@end
