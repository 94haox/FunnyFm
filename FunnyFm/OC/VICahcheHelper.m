//
//  VICahcheHelper.m
//  FunnyFm
//
//  Created by Duke on 2020/2/3.
//  Copyright © 2020 Duke. All rights reserved.
//

#import "VICahcheHelper.h"

@implementation VICahcheHelper

- (void)cleanAllCache{
	NSError *error = [[NSError alloc] init];
	[VICacheManager cleanAllCacheWithError:&error];
}

- (unsigned long long)getAllCacheSize{
	NSError *error = [[NSError alloc] init];
	return [VICacheManager calculateCachedSizeWithError:&error];
}

@end
