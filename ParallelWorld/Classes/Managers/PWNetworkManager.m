//
//  PWNetworkManager.m
//  ParallelWorld
//
//  Created by Joe.Pen on 7/19/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PWNetworkManager.h"

static NSString* const ImageName = @"image";
static NSString* const ImageFileName = @"imageFile";

@implementation PWNetworkManager
singleton_implementation(PWNetworkManager)

-(id)init{
    if (self = [super init]) {
        
        return self;
    }
    
    return nil;
}


//POST方法获取数据
- (void)postDataWithUrl:(NSString*)_urlStr
             parameters:(id)_parameters
                success:(SuccessBlockHandler)_success
                   fail:(FailureBlockHandler)_failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    
    [manager POST:_urlStr parameters:_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_failure) {
            _failure();
        }
    }];
}


//GET方法获取数据
- (void)getDataWithUrl:(NSString*)_urlStr
            parameters:(id)_parameters
               success:(SuccessBlockHandler)_success
                  fail:(FailureBlockHandler)_failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    
    [manager GET:_urlStr parameters:_parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_failure) {
            _failure();
        }
    }];
}

//下载数据
- (void)downloadDataWithURL:(NSString*)_urlStr
                   progress:(ProgressBlockHandler)_progress
                    success:(SuccessBlockHandler)_success
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    
    NSURLSessionDownloadTask* downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (_progress) {
            _progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString* filePath = CachesDirectory;
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (_success) {
            _success(response);
        }
    }];
    [downloadTask resume];
}


//上传文件
- (void)uploadData:(NSArray*)_uploadImageAry
         parameter:(id)_parameter
             toURL:(NSString*)_urlStr
          progress:(ProgressBlockHandler)_progress
            sccess:(SuccessBlockHandler)_success
           failure:(FailureBlockHandler)_fail
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [manager POST:_urlStr parameters:_parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传 多张图片
        for(NSInteger i = 0; i < _uploadImageAry.count; i++)
        {
            UIImage* image = _uploadImageAry[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"%@%zi", ImageName, i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", ImageFileName];
            
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            _fail();
        }
    }];
}

@end
