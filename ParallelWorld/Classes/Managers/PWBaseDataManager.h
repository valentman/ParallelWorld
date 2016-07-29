//
//  PWBaseDataManager.h
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWBaseDataManager : NSObject

singleton_interface(PWBaseDataManager);

/**
 *  图片上传接口
 *
 *  @param _imageAry 图片数组
 *  @param _params   参数（）
 *  @param _progress 进度回调
 *  @param _success  成功回调
 *  @param _fail     失败回调
 */
- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail;


/**
 *  图片上传接口
 *
 *  @param _imageAry 图片数组
 *  @param _params   参数（）
 *  @param _progress 进度回调
 *  @param _success  成功回调
 *  @param _fail     失败回调
 *  @param _url      指定url
 */
- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
              andUrl:(NSString*)_url;

/**
 *  音频上传接口
 *
 *  @param _voiceData 音频数据（NSData*类型）
 *  @param _params    参数（如：音频格式）
 *  @param _progress  进度回调
 *  @param _success   成功回调
 *  @param _fail      失败回调
 */
- (void)uploadVoice:(NSData*)_voiceData
              param:(NSDictionary*)_params
           progress:(ProgressBlockHandler)_progress
            success:(SuccessBlockHandler)_success
            failure:(FailureBlockHandler)_fail;

@end
