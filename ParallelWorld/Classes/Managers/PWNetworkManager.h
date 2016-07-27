//
//  PWNetworkManager.h
//  ParallelWorld
//
//  Created by Joe.Pen on 7/19/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//
//  这个网络请求管理类是基于 AFNetworking 3.1.0版本的。
//  关于AFNetworking3.*版本跟AFNetworking2.*的区别，自行Google。
//  所以，务必保证AFNetworking的版本为3.*。

#import <AFNetworking/AFNetworking.h>

@interface PWNetworkManager : AFHTTPSessionManager
singleton_interface(PWNetworkManager)

/**
 *  Get Data From Specific URL By POST Method
 *
 */
- (void)postDataWithUrl:(NSString* _Nonnull)_urlStr
             parameters:(id __nullable)_parameters
                success:(nullable void (^)(id _Nonnull responseObject))_success
                   fail:(nullable void (^)())_failure;
/**
 *  Get Data From Specific URL By GET Method
 *
 */
- (void)getDataWithUrl:(NSString* _Nonnull)_urlStr
             parameters:(id __nullable)_parameters
                success:(nullable void (^)(id _Nonnull responseObject))_success
                   fail:(nullable void (^)())_failure;


/**
 *  Download Data From Specific URL
 *
 *  @param _urlStr     paramesters
 *  @param _progress   progress callback
 *  @param _success    success callback
 */
- (void)downloadDataWithURL:(NSString* _Nonnull)_urlStr
                   progress:(nullable void (^)(NSProgress * _Nonnull))_progress
                    success:(nullable void (^)(id _Nonnull responseObject))_success;


/**
 *  upload ImageData to Service
 *
 *  @param _uploadImageAry image Ary
 *  @param _parameter      paramesters
 *  @param _urlStr         service url
 *  @param _progress       progress callback
 *  @param _success        success callback
 *  @param _fail           fail callback
 */
- (void)uploadData:(NSArray* _Nonnull)_uploadImageAry
         parameter:(id __nullable)_parameter
             toURL:(NSString* _Nonnull)_urlStr
          progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            sccess:(nullable void (^)(id _Nonnull responseObject))_success
           failure:(nullable void (^)())_fail;


/**
 *  upload  Voice Data to Service
 *
 *  @param _data     voice data
 *  @param _param    paramesters
 *  @param _urlStr   service url
 *  @param _progress progress callback
 *  @param _success  success callback
 *  @param _fail     fail callback
 */
- (void)uploadVoice:(NSData* _Nonnull)_voiceData
         parameters:(__nullable id)_param
              toURL:(NSString* _Nonnull)_urlStr
           progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            success:(nullable void (^)(id _Nonnull responseObject))_success
            failure:(nullable void (^)())_fail;


/**
 *  upload  Video Data to Service
 *
 *  @param _videoData voice data
 *  @param _param     paramesters
 *  @param _urlStr    service url
 *  @param _progress  progress callback
 *  @param _success   success callback
 *  @param _fail      fail callback
 */
- (void)uploadVideo:(NSData* _Nonnull)_videoData
         parameters:(id __nullable)_param
              toURL:(NSString* _Nonnull)_urlStr
           progress:(nullable void (^)(NSProgress * _Nonnull))_progress
            success:(nullable void (^)(id _Nonnull responseObject))_success
            failure:(nullable void (^)())_fail;
@end
