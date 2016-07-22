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

- (void)showHomePage:(NSDictionary*)_params
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail;

- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail;
@end
