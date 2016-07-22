//
//  LineView.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)awakeFromNib
{
    self.radius = 20;
};

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [WHITECOLOR setFill];
//    UIRectFill(rect);
    
    [GRAYCOLOR set];

    CGContextSaveGState(ctx);
//    CGContextRotateCTM(ctx, M_PI_4);//旋转
//    CGContextScaleCTM(ctx, 0.5, 1.5);   //缩放
//    CGContextTranslateCTM(ctx, -200, 50);   //平移
    
//    //直线
//    CGContextMoveToPoint(ctx, 20, 50);
//    CGContextAddLineToPoint(ctx, 300, 50);
    
//    CGContextSetRGBStrokeColor(ctx, 0, 1, 1, 1);
//    CGContextSetRGBFillColor(ctx, 1,0,1,1);

//    CGContextSetLineWidth(ctx, 5);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//    CGContextStrokePath(ctx);
    
//    CGContextRestoreGState(ctx);
    
//    //长方形
//    CGContextAddRect(ctx, CGRectMake(300, 50, 100, 100));
//    CGContextStrokePath(ctx);
    
    
    //三角形
//    CGContextMoveToPoint(ctx, 20, 200);
//    CGContextAddLineToPoint(ctx, 100, 200);
//    CGContextAddLineToPoint(ctx, 60, 240);
//    CGContextClosePath(ctx);

    //圆弧
    CGContextAddArc(ctx, 100, 100, self.radius, 0, 2*M_PI, 0);

    
//    画圆
//    CGContextRestoreGState(ctx);
//    CGContextAddEllipseInRect(ctx, CGRectMake(100, 100, 80, 80));
//    CGContextStrokePath(ctx);
    
//    CGContextMoveToPoint(ctx, 100, 100);
//    CGContextAddLineToPoint(ctx, 60, 150);
//    CGContextAddLineToPoint(ctx, 140, 150);
//    CGContextClosePath(ctx);
    
//    CGContextClip(ctx);
    
    
    
    //文字渲染
//    NSString* str = @"的额搜风搜分手了粉色发俄双方说法offFF瓦房你F回复F入会费WFH；飞；FN返回WFH；哦发货；F回复；FHISFHSIFH我皮肤好APIFRHi分红AWFHIOF威锋网";

    
    
    //将图形渲染到Layer上。
    CGContextFillPath(ctx);
    
//    [str drawInRect:CGRectMake(0, 100, 100, 100) withAttributes:nil];
//    [str drawAtPoint:CGPointMake(0, 100) withAttributes:nil];
    
    
    
    
    
//    
//    UIImage* image = IMAGENAMED(@"share_icon");
//    [image drawInRect:CGRectMake(100, 100, 80, 80) blendMode:kCGBlendModeNormal alpha:0.8];

}



- (void)setRadius:(float)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}
@end
