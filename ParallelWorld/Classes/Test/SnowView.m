//
//  SnowView.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/24/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "SnowView.h"

@interface SnowView ()
@property(nonatomic,assign)float imageY;
@end

@implementation SnowView

- (void)awakeFromNib
{
    DLog();
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        CADisplayLink* display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImage)];
        [display setFrameInterval:1];
        [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        DLog();
    }
    return self;
}

- (void)updateImage
{
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.imageY += 5;
    
    if (self.imageY > PJ_SCREEN_HEIGHT)
    {
        self.imageY = 0;
    }
    
    UIImage* image = IMAGENAMED(@"share_icon");
    [image drawAtPoint:CGPointMake(20, self.imageY)];
}

@end
