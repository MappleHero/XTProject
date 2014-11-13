//
//  XTHTTPRequestSerializer.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTHTTPRequestSerializer.h"
#import "XTEncodeUtil.h"

@implementation XTHTTPRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters)
    {
        // 参数转成json格式，并做base64编码
        NSData *paramJsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                                options:NSJSONWritingPrettyPrinted error:error];
        NSString *query = [XTEncodeUtil encodeBase64WithData:paramJsonData];
        
        // 如果是"GET" "HEAD" "DELETE"方法，把参数直接拼到URL
        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]])
        {
            NSURL *url = request.URL;
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:@"?%@", query]];
            [mutableRequest setURL:url];
        }
        else // 否则作为请求body
        {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"])
            {
                NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
                [mutableRequest setValue:[NSString stringWithFormat:@"text/html; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
            }
            
            [mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return mutableRequest;
}

@end
