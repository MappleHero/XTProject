//
//  RayWeather.h
//  XTrain
//
//  Created by Ben on 14/11/13.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTNetworkRequest.h"
#import "XTNetworkResponse.h"
#import <Mantle/Mantle.h>

#pragma mark - Model

@interface RayWeatherCondition : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *cloudCover;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *observationTime;
@property (nonatomic, strong) NSString *precipMM;
@property (nonatomic, strong) NSString *pressure;
@property (nonatomic, strong) NSString *tempC;
@property (nonatomic, strong) NSString *tempF;
@property (nonatomic, strong) NSString *visibility;
@property (nonatomic, strong) NSString *weatherCode;
@property (nonatomic, strong) NSArray *weatherDesc;
@property (nonatomic, strong) NSArray *weatherIconUrl;
@property (nonatomic, strong) NSString *winddir16Point;
@property (nonatomic, strong) NSString *winddirDegree;
@property (nonatomic, strong) NSString *windspeedKmph;
@property (nonatomic, strong) NSString *windspeedMiles;

@end

@interface RayWeatherRequst : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *cloudCover;
@property (nonatomic, strong) NSString *humidity;

@end

@interface RayWeatherInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *precipMM;
@property (nonatomic, strong) NSString *tempMaxC;
@property (nonatomic, strong) NSString *tempMaxF;
@property (nonatomic, strong) NSString *tempMinC;
@property (nonatomic, strong) NSString *tempMinF;
@property (nonatomic, strong) NSString *weatherCode;
@property (nonatomic, strong) NSString *weatherDesc;
@property (nonatomic, strong) NSString *weatherIconUrl;
@property (nonatomic, strong) NSString *winddir16Point;
@property (nonatomic, strong) NSString *winddirDegree;
@property (nonatomic, strong) NSString *windspeedKmph;
@property (nonatomic, strong) NSString *windspeedMiles;

@end

@interface RayWeather : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *conditions;
@property (nonatomic, strong) NSArray *request;
@property (nonatomic, strong) NSArray *weather;

@end

#pragma mark - Request

@interface RayWeatherRequest : XTNetworkRequest

@end

#pragma mark - Response

@interface RayWeatherResponse : XTNetworkResponse

@property (nonatomic, strong) RayWeather *weather;

@end
