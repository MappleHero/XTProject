//
//  TNBaseResponse.m
//  XTrain
//
//  Created by Ben on 14/11/14.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "TNBaseResponse.h"
#import "XTEncodeUtil.h"
#import <Mantle/Mantle.h>

NSString *const TNResponseErrorDomain = @"com.tuniu.BUSINESSERROR";

@implementation TNBaseResponse

- (NSString *)description
{
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@ JSONDic:[%@]", superDescription, self.JSONDic];
}

- (NSString *)modelClassName
{
    return nil;
}

- (void)handleBusiness
{
    NSData *JSONData = [XTEncodeUtil decodeBase64WithString:self.responseString];
    NSError *JSONParseError = nil;
    self.JSONDic = [NSJSONSerialization JSONObjectWithData:JSONData
                                                   options:0
                                                     error:&JSONParseError];
    
    if (!self.JSONDic)
    {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey:
                                       [NSString stringWithFormat:@"Failed to parse response data to JSON, error:[%@]", JSONParseError]};
        self.error = [NSError errorWithDomain:TNResponseErrorDomain code:TNResponseCodePaserJSONFailed userInfo:userInfo];
    }
    else
    {
        BOOL success = [self.JSONDic[@"success"] boolValue];
        NSInteger errorCode = [self.JSONDic[@"errorCode"] integerValue];
        
        self.success = success;
        if (!success
            || errorCode != TNResponseCodeSuccess)
        {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"Business error with message:%@", self.JSONDic[@"msg"]]};
            self.error = [NSError errorWithDomain:TNResponseErrorDomain code:errorCode userInfo:userInfo];
        }
        else
        {
            if ([self modelClassName].length > 0
                && self.JSONDic[@"data"])
            {
                // TODO:Maybe we should parse error here...
                self.model = [MTLJSONAdapter modelOfClass:NSClassFromString([self modelClassName])
                                       fromJSONDictionary:self.JSONDic[@"data"]
                                                    error:nil];
            }
        }
    }
}

@end
