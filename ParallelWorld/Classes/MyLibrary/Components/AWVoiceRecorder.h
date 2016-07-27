//
//  AWVoiceRecorder.h
//  ChatLib
//
//  Created by Qifei Wu on 16/7/19.
//  Copyright © 2016年 JingHeQianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kVoiceRecorderTotalTime 60.0

typedef BOOL(^AWPrepareRecorderCompletion)();
typedef void(^AWStartRecorderCompletion)();
typedef void(^AWStopRecorderCompletion)();
typedef void(^AWPauseRecorderCompletion)();
typedef void(^AWResumeRecorderCompletion)();
typedef void(^AWCancellRecorderDeleteFileCompletion)();
typedef void(^AWRecordProgress)(float progress);
typedef void(^AWPeakPowerForChannel)(float peakPowerForChannel);

@interface AWVoiceRecorder : NSObject
@property (nonatomic, copy) AWStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) AWRecordProgress recordProgress;
@property (nonatomic, copy) AWPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(AWPrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(AWStartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(AWPauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(AWResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(AWStopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(AWCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;
@end
