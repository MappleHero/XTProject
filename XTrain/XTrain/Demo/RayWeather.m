//
//  RayWeather.m
//  XTrain
//
//  Created by Ben on 14/11/13.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "RayWeather.h"

#pragma mark - Model

@implementation RayWeatherCondition

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"cloudCover":@"cloudcover",
             @"observationTime":@"observation_time",
             @"tempC":@"temp_C",
             @"tempF":@"temp_F"};
}

@end

@implementation RayWeatherRequst

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

@end

@implementation RayWeatherInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

@end

@implementation RayWeather

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"conditions":@"current_condition"};
}

+ (NSValueTransformer *)conditionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RayWeatherCondition class]];
}

+ (NSValueTransformer *)requestJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RayWeatherRequst class]];
}

+ (NSValueTransformer *)weatherJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RayWeatherInfo class]];
}

@end

#pragma mark - Request

@implementation RayWeatherRequest

- (NSString *)baseURLString
{
    return @"http://www.raywenderlich.com/demos/weather_sample/";
}

- (NSString *)path
{
    return @"weather.php";
}

- (NSDictionary *)params
{
    return @{@"format":@"json"};
}

- (NSTimeInterval)cacheInterval
{
    return ONE_DAY;
}

@end

#pragma mark - Response

@implementation RayWeatherResponse

- (void)handleBusiness
{
    // TODO:Validate response
    if (self.responseData)
    {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                                options:0
                                                                  error:nil];
        
        RayWeather *weather = [MTLJSONAdapter modelOfClass:[RayWeather class]
                                        fromJSONDictionary:jsonDic[@"data"]
                                                     error:nil];
        self.weather = weather;
    }
}

@end

