//
//  FOXProgressView.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/5.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXProgressView.h"


const CGFloat kProgressDuration = 0.25f;

@interface FOXProgressView ()

@property (nonatomic, assign) CGFloat currentProgress;

@end

@implementation FOXProgressView

- (void)dealloc {
    [self removeViewObserver];
}

- (instancetype)initWithProgressViewStyle:(UIProgressViewStyle)style {
    self = [super initWithProgressViewStyle:style];
    if (self) {
        _currentProgress = self.progress;
        [self addViewObserver];
    }
    return self;
}

- (void)progressLoadFinish {
    [self loadProgress:1.0 animated:YES];
}

- (void)cancelLoadProgress {
    [self setAlpha:0.0f];
    [self setProgress:0.0f animated:NO];
    [self setCurrentProgress:0.0f];
}

- (void)loadProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setAlpha:1.0];
    [self setProgress:progress];
    if (animated) {
        [UIView animateWithDuration:kProgressDuration animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self setCurrentProgress:progress];
        }];
    } else {
        [self setCurrentProgress:progress];
    }
}

#pragma mark - KVO Observer

- (void)addViewObserver {
    [self addObserver:self forKeyPath:@"currentProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeViewObserver {
    [self removeObserver:self forKeyPath:@"currentProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentProgress"]) {
        NSString *newProgress = [NSString stringWithFormat:@"%.1f",[change[NSKeyValueChangeNewKey] floatValue]];
        if ([newProgress isEqualToString:@"1.0"]) {
            [UIView animateWithDuration:kProgressDuration animations:^{
                [self setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self setProgress:0.0f animated:NO];
                [self setCurrentProgress:0.0f];
            }];
        }
    }
}


@end
