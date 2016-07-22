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
- (void)postDataWithUrl:(NSString*)_urlStr
             parameters:(id)_parameters
                success:(SuccessBlockHandler)_success
                   fail:(FailureBlockHandler)_failure;
/**
 *  Get Data From Specific URL By GET Method
 *
 */
- (void)getDataWithUrl:(NSString*)_urlStr
             parameters:(id)_parameters
                success:(SuccessBlockHandler)_success
                   fail:(FailureBlockHandler)_failure;


/**
 *  Download Data From Specific URL
 *
 *  @param _urlStr     destinate URL
 *  @param _progress   progress object
 *  @param _success    success Callback
 */
- (void)downloadDataWithURL:(NSString*)_urlStr
                   progress:(ProgressBlockHandler)_progress
                    success:(SuccessBlockHandler)_success;


/**
 *  Upload Data To Specific URL
 *
 *  @param _uploadData need to upload data
 *  @param _parameter  parameters
 *  @param _urlStr     destinate URL
 *  @param _progress   progress object
 *  @param _success    success Callback
 */
- (void)uploadData:(NSArray*)_uploadImageAry
         parameter:(id)_parameter
             toURL:(NSString*)_urlStr
          progress:(ProgressBlockHandler)_progress
            sccess:(SuccessBlockHandler)_success
           failure:(FailureBlockHandler)_fail;
@end
