//
//  CropAudioManager.h
//  Gangstribe
//
//  Created by Duke on 2019/11/7.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CropAudioManager : NSObject

+ (void)audioCrop:(NSURL *)url
		startTime:(NSInteger)startTime
		  endTime:(NSInteger)endTime
			 name:(NSString *)name
		 complete:(void(^)(BOOL isSuccess, NSString *path))complete;

@end

NS_ASSUME_NONNULL_END
