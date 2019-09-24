//
//  StaticMethods.m
//  FunnyFm
//
//  Created by Duke on 2019/9/19.
//  Copyright © 2019 Duke. All rights reserved.
//

#import "StaticMethods.h"

static void dw_runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
	NSLog(@"runloop ----%lu  ---- %@",activity,info);
}

static void dw_addRunLoopObserver() {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopEntry| kCFRunLoopExit, true, 0xFFFFFF, dw_runLoopObserverCallBack, NULL);
		CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
		CFRelease(observer);
	});
}

@implementation StaticMethods

- (instancetype)init
{
	self = [super init];
	if (self) {
		dw_addRunLoopObserver();
	}
	return self;
}


@end
