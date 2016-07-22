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
    NSString* msgKey = [[info valueForKey:@"code"] stringValue];
    if (![msgKey isEqual:@"0"]) {
        //        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowErrorInfoWithErrorCode: stringValue]];
        [PUtils tipWithText:[info valueForKey:@"message"] andView:nil];
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
        else
        {
            if (_fail)
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


- (void)generlUploadImage:(NSArray*)_imageAry
                    param:(NSDictionary*)_params
             andServerAPI:(NSString*)_url
                 progress:(ProgressBlockHandler)_progress
                  success:(SuccessBlockHandler)_success
                  failure:(FailureBlockHandler)_fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            _success(json);
        }
        if (_fail) {
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
                            toURL:_url
                         progress:_progress
                           sccess:successBlock
                          failure:failBlock];
}


- (void)showHomePage:(NSDictionary*)_params
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
{
    [self generalPost:nil success:_success fail:_fail andServerAPI:@"http://119.29.135.211/Customer/customerInfo"];
}

- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
{
    [self generlUploadImage:_imageAry param:_params andServerAPI:@" http://static.chinacloudapp.cn/" progress:_progress success:_success failure:_fail];
}

@end
