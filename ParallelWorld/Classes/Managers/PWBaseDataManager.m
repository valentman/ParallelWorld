//
//  PWBaseDataManager.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PWBaseDataManager.h"
#import "PWNetworkManager.h"

@implementation PWBaseDataManager

singleton_implementation(PWBaseDataManager)

- (BOOL)showAlertView:(id)info{
    NSString* msgKey = [[info valueForKey:@"status"] stringValue];
    if (![msgKey isEqual:@"1"]) {
        //        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowErrorInfoWithErrorCode: stringValue]];
        [PUtils tipWithText:[info valueForKey:@"msg"] andView:nil];
        return NO;
    }
    DLog(@"%@",msgKey);
    return YES;
}

- (void)generalPost:(NSDictionary*)_postParams
            success:(SuccessBlockHandler)_success
               fail:(FailureBlockHandler)_fail
       andServerAPI:(NSString*)_api
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            _success(json);
        }
        else if (_fail)
        {
                _fail();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        if (_fail)
            _fail();
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_postParams];
    
    [PWNetworkInstance getDataWithUrl:_api parameters:_postParams success:successBlock fail:failBlock];
}



- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            _success(json);
        }
        else if (_fail)
        {
            _fail();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        if (_fail) {
            _fail();
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    
    [PWNetworkInstance uploadData:_imageAry
                        parameter:_params
                            toURL:@"http://static.chinacloudapp.cn/upload.php"
                         progress:_progress
                           sccess:successBlock
                          failure:failBlock];
}



- (void)uploadVoice:(NSData*)_voiceData
              param:(NSDictionary*)_params
           progress:(ProgressBlockHandler)_progress
            success:(SuccessBlockHandler)_success
            failure:(FailureBlockHandler)_fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            _success(json);
        }
        else if (_fail)
        {
            _fail();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        if (_fail) {
            _fail();
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    
    [PWNetworkInstance uploadVoice:_voiceData
                        parameters:params
                             toURL:@"http://static.chinacloudapp.cn/upload.php"
                          progress:_progress
                           success:successBlock
                           failure:failBlock];
}
@end
