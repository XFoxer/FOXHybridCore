//
//  FOXProgressView.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/5.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FOXProgressView : UIProgressView

- (void)progressLoadFinish;
- (void)cancelLoadProgress;
- (void)loadProgress:(CGFloat)progress animated:(BOOL)animated;

@end
