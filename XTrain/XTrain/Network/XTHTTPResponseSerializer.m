//
//  XTHTTPResponseSerializer.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTHTTPResponseSerializer.h"
#import "XTEncodeUtil.h"

NSString *const XTResponseErrorDomain = @"com.xt.BUSINESSERROR";

@implementation XTHTTPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error])
    {
        if (!error)
        {
            return nil;
        }
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName)
    {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId)
        {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSError *serializationError = nil;
    @autoreleasepool {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
        if (responseString && ![responseString isEqualToString:@" "])
        {
            // Base64解码
            data = [XTEncodeUtil decodeBase64WithString:responseString];
            
            if (data)
            {
                if ([data length] > 0)
                {
                    responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
                }
                else
                {
                    return nil;
                }
            }
            else
            {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", @"AFNetworking", nil),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", @"AFNetworking", nil), responseString]
                                           };
                
                serializationError = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
    }
    
    BOOL success = [responseObject[@"success"] boolValue];
    NSInteger errorCode = [responseObject[@"errorCode"] boolValue];
    
    if (!success)
    {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"Business error with message:%@", responseObject[@"msg"]]};
       *error = [NSError errorWithDomain:XTResponseErrorDomain code:errorCode userInfo:userInfo];
    }
    
    return responseObject;
}

@end
