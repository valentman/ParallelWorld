//
//  PWValueType.h
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#ifndef PWValueType_h
#define PWValueType_h

#pragma mark- typedef
typedef void (^ProgressBlockHandler)(NSProgress* progress);
typedef void (^SuccessBlockHandler)(id json);
typedef void (^FailureBlockHandler)();
typedef void (^GeneralBlockHandler)();


#pragma mark- define
#define PWNetworkInstance [PWNetworkManager sharedPWNetworkManager]
#define PWBaseDataInstance [PWBaseDataManager sharedPWBaseDataManager]


struct CZJMargin {
    CGFloat horisideMargin;
    CGFloat vertiMiddleMargin;
};
typedef struct CZJMargin CZJMargin;



CG_INLINE CZJMargin CZJMarginMake(CGFloat horisideMargin, CGFloat vertiMiddleMargin)
{
    CZJMargin margin;
    margin.horisideMargin = horisideMargin;
    margin.vertiMiddleMargin = vertiMiddleMargin;
    return margin;
}


#endif /* PWValueType_h */
