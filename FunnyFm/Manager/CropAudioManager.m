//
//  CropAudioManager.m
//  Gangstribe
//
//  Created by Duke on 2019/11/7.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "CropAudioManager.h"


@implementation CropAudioManager




+ (void)audioCrop:(NSURL *)url
startTime:(NSInteger)startTime
  endTime:(NSInteger)endTime
	 name:(NSString *)name
 complete:(void(^)(BOOL isSuccess, NSString *path))complete{

	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil]; //初始化音频媒体文件
	NSError *assetError = nil; //错误标识
	AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset                 error:&assetError];
	if (assetError) {
		NSLog (@"error: %@", assetError);
		complete(NO,@"");
		return;
	}
	 
	AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput                                                             assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks audioSettings: nil]; //读取指定文件的音频轨道混音
	if (! [assetReader canAddOutput: assetReaderOutput]) {
		NSLog (@"can't add reader output... die!");
		complete(NO,@"");
		return;
	}

	[assetReader addOutput: assetReaderOutput];//输出音乐
	NSString *exportPath = [[self composeDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",name]];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
			[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	}
	if (assetError) {
		complete(NO,@"");
		NSLog (@"error: %@", assetError);
		return;
	}
	[self exportAsset:songAsset toFilePath:exportPath startTime:startTime endTime:endTime complete:complete];
}

/*
 剪切开始工作
 大概流程
1、获得视频总时长，处理时间，数组格式返回音频数据
2、创建导出会话
3、设计导出时间范围，淡出时间范围
4、设计新音频配置数据，文件路径，类型等
5、开始剪切
 */

+ (BOOL)exportAsset:(AVAsset *)avAsset
		 toFilePath:(NSString *)filePath
		  startTime:(NSInteger)start
			endTime:(NSInteger)end
		   complete:(void(^)(BOOL isSuccess, NSString *path))complete{

	//返回该音频文件数据的数组
    NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];
	if ([tracks count] == 0){
		complete(NO,@"");
		return NO;
	}
	//获取第一个对象
    AVAssetTrack *track = [tracks objectAtIndex:0];
    //创建导出会话
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetAppleM4A];
	if (nil == exportSession){
		complete(NO,@"");
		return  NO;
	}

    CMTime startTime = CMTimeMake(start, 1);
    CMTime stopTime = CMTimeMake(end, 1);
	//导出时间范围
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);

    // 新的配置信息
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
	
    //开始真正工作
    [exportSession exportAsynchronouslyWithCompletionHandler:^{ //block
        if (AVAssetExportSessionStatusCompleted == exportSession.status) { //如果信号提示已经完成
			NSLog(@"AVAssetExportSessionStatusCompleted"); //格式化输出成功提示
			complete(YES, filePath);
        } else{
			NSLog(@"ExportSessionStatus---%ld",(long)exportSession.status);
			complete(NO,@"");
		}
    }];

    return YES;
}

+ (NSString *)composeDir {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    NSString *compseDir = [NSString stringWithFormat:@"%@/AudioCompose/", cacheDir];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:compseDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:compseDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return compseDir;
}

@end
