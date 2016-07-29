//
//  PWBaseDataManager.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PWBaseDataManager.h"
#import "PWNetworkManager.h"



@interface PWBaseDataManager ()
{
    NSMutableDictionary *_baseParams;
}
@end

@implementation PWBaseDataManager

singleton_implementation(PWBaseDataManager)

- (id)init
{
    if (self == [super init])
    {
        [self initBaseParameters];
        return self;
    }
    return nil;
}

- (void)initBaseParameters
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSString* userid = @"2555";
    NSString* singkey = @"chengdujingheqianchengkejiyouxiangongsishiyijiafeichangniubidegongsi";
    NSString* originMdt = [NSString stringWithFormat:@"%@%@%@",userid,timeSp,singkey];
    NSString* md5Str = [[iOSMD5 md5:originMdt] uppercaseString];
    _baseParams = [@{@"userid":@"2555",
                     @"Utime":timeSp,
                     @"sgin":md5Str
                     } mutableCopy];
}

- (BOOL)showAlertView:(id)info{
    NSString* msgKey = [[info valueForKey:@"status"] stringValue];
    if (![msgKey isEqual:@"1"]) {
        [PUtils tipWithText:[info valueForKey:@"msg"] andView:nil];
        DLog(@"%@",[info valueForKey:@"msg"]);
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
    [self uploadImages:_imageAry
                 param:_params
              progress:_progress
               success:_success
               failure:_fail
                andUrl:kServerUploadAPI];
}


- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
              andUrl:(NSString*)_url
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
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValue:@"files" forKey:@"action"];
    [params setValuesForKeysWithDictionary:_baseParams];
    
    [PWNetworkInstance uploadData:_imageAry
                        parameter:params
                            toURL:_url
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
    [params setValue:@"files" forKey:@"action"];
    [params setValuesForKeysWithDictionary:_baseParams];
    
    [PWNetworkInstance uploadVoice:_voiceData
                        parameters:params
                             toURL:kServerUploadAPI
                          progress:_progress
                           success:successBlock
                           failure:failBlock];
}
@end
