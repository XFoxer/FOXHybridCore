//
//  FOXDataSetPlaceholderView.h
//  BBLink
//
//  Created by 徐林峰 on 2017/7/4.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FOXDataSetPlaceholderView;

@protocol FOXDataSetPlaceholderViewDelegate<NSObject>

@optional
- (void)placeholderView:(FOXDataSetPlaceholderView *)holderView didTapView:(UIView *)view;
- (void)placeholderView:(FOXDataSetPlaceholderView *)holderView buttonDidTap:(UIButton *)button;
- (BOOL)placeholderViewShouldAllowTouch;

@end

@interface FOXDataSetPlaceholderView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, weak) id <FOXDataSetPlaceholderViewDelegate>delegate;

@property (nonatomic, assign) UIEdgeInsets contentInsets; // Default is UIEdgeInsetsMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX).

+ (instancetype)placeholder;
+ (instancetype)placeholderWithImage:(UIImage *)image;
+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title;
+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle;

- (void)appendImage:(UIImage *)image completion:(void (^)(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width))completion;
- (void)appendTitle:(NSString *)title completion:(void (^)(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion;
- (void)appendSubTitle:(NSString *)subtitle completion:(void (^)(UILabel *subtitleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion;
- (void)appendButtonWithTitle:(NSString *)title completion:(void (^)(UIButton *button, CGFloat *offset, CGFloat *height, CGFloat *width))completion;
- (void)appendSeparatorWithBackgroundColor:(UIColor *)backgroundColor completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion;
- (void)appendView:(UIView *)view completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion;

@end

