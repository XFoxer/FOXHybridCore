//
//  FOXDataSetPlaceholderView+BBLinkFactory.h
//  BBLink
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 bilibili. All rights reserved.
//

#import "FOXDataSetPlaceholderView.h"



@interface FOXDataSetPlaceholderView (FOXFactory)


+ (instancetype)defaultPlaceholder;

+ (instancetype)defaultPlaceholderWithTitle:(NSString *)title;
+ (instancetype)defaultPlaceholderWithImage:(UIImage *)image title:(NSString *)title;


+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL;
+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL title:(NSString *)title;


+ (instancetype)defaultPlaceHolderWithImageURL:(NSURL *)imageURL buttonTitle:(NSString *)buttonTitle;
+ (instancetype)defaultPlaceHolderWithImageURL:(NSURL *)imageURL buttonTitle:(NSString *)buttonTitle title:(NSString *)title;


+ (instancetype)defaultPlaceHolderWithImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle;
+ (instancetype)defaultPlaceHolderWithImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle title:(NSString *)title;

@end
