//
//  TNVersion.h
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface XTSplash : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger splashId;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *splashUrl;

@end

@interface XTVersion : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) BOOL isUpgradeNeeded;
@property (assign, nonatomic) BOOL isForceUpgrade;
@property (strong, nonatomic) NSString *latestVersionNumber;
@property (strong, nonatomic) NSArray *upgradeReason;
@property (strong, nonatomic) NSString *upgradePath;
@property (strong, nonatomic) XTSplash *splash;

@end
