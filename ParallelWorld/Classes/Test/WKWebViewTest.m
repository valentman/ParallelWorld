//
//  WKWebViewTest.m
//  ParallelWorld
//
//  Created by Joe.Pen on 6/27/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "WKWebViewTest.h"
#import "IMYWebView.h"
#import <WebKit/WebKit.h>
#import "PWBaseDataManager.h"

@interface WKWebViewTest ()

@property (nonatomic, strong) IMYWebView *webView;
@property (nonatomic) UIProgressView *progressView;
@end

@implementation WKWebViewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    self.webView = [[IMYWebView alloc] initWithFrame:self.view.bounds];
    self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:_webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 64, PJ_SCREEN_WIDTH, 2);
    [self.view addSubview:self.progressView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tmall.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
