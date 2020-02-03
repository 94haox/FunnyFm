//
//  VICahcheHelper.h
//  FunnyFm
//
//  Created by Duke on 2020/2/3.
//  Copyright © 2020 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VIMediaCache.h>

@interface VICahcheHelper : NSObject

- (void)cleanAllCache;

- (unsigned long long)getAllCacheSize;

@end


