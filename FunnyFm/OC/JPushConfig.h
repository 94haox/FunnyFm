//
//  JPushConfig.h
//  FunnyFm
//
//  Created by Duke on 2018/12/10.
//  Copyright © 2018 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JPush/JPUSHService.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPushConfig : NSObject <JPUSHRegisterDelegate>

+ (JPushConfig *)shared;

@end

NS_ASSUME_NONNULL_END
