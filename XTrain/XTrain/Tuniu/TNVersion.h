//
//  TNVersion.h
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "TNBaseRequest.h"
#import "TNBaseResponse.h"

#pragma mark - Model

@interface TNSplash : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger splashId;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *splashUrl;

@end

@interface TNVersion : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) BOOL isUpgradeNeeded;
@property (assign, nonatomic) BOOL isForceUpgrade;
@property (strong, nonatomic) NSString *latestVersionNumber;
@property (strong, nonatomic) NSArray *upgradeReason;
@property (strong, nonatomic) NSString *upgradePath;
@property (strong, nonatomic) TNSplash *splash;

@end

#pragma mark - Request

@interface TNVersionRequest : TNBaseRequest

@end

#pragma mark - Response

@interface TNVersionResponse : TNBaseResponse

@end