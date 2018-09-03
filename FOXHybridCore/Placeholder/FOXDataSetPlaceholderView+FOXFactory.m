//
//  FOXDataSetPlaceholderView+BBLinkFactory.m
//  BBLink
//
//  Created by Jave on 2018/1/11.
//  Copyright © 2018年 bilibili. All rights reserved.
//

#import "FOXDataSetPlaceholderView+FOXFactory.h"

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@implementation FOXDataSetPlaceholderView (FOXFactory)

+ (instancetype)defaultPlaceholder;{
    return [self defaultPlaceholderWithTitle:@"什么都木有┑(￣Д ￣)┍\n轻触重试"];
}

+ (instancetype)defaultPlaceholderWithTitle:(NSString *)title {
    return [self defaultPlaceholderWithImage:[UIImage imageNamed:@"vcs_common_boxempty_ico"] title:title];
}

+ (instancetype)defaultPlaceholderWithImage:(UIImage *)image title:(NSString *)title {
    FOXDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:image completion:nil];
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 20;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor grayColor];
    }];
    return placeholderView;
}

+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL {
    return [self defaultPlaceholderWithImageURL:imageURL title:@"什么都木有┑(￣Д ￣)┍"];
}

+ (instancetype)defaultPlaceholderWithImageURL:(NSURL *)imageURL title:(NSString *)title {
    FOXDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:nil completion:^(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width) {
        [imageView yy_setImageWithURL:imageURL options:0];
    }];
    
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 10;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = HEXCOLOR(0x333333);
    }];

    return placeholderView;
}



+ (instancetype)defaultPlaceHolderWithImageURL:(NSURL *)imageURL buttonTitle:(NSString *)buttonTitle {
    return [self defaultPlaceHolderWithImageURL:imageURL buttonTitle:buttonTitle title:@"似乎已断开与互联网的连接"];
}

+ (instancetype)defaultPlaceHolderWithImageURL:(NSURL *)imageURL buttonTitle:(NSString *)buttonTitle title:(NSString *)title {
    FOXDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:nil completion:^(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width) {
        [imageView yy_setImageWithURL:imageURL options:0];
    }];
    
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 10;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = HEXCOLOR(0x333333);
    }];
    
    [placeholderView appendButtonWithTitle:buttonTitle completion:^(UIButton *button, CGFloat *offset, CGFloat *height, CGFloat *width) {
        [button setTitleColor:[UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setBackgroundColor:[UIColor clearColor]];
    }];
    return placeholderView;
}


+ (instancetype)defaultPlaceHolderWithImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle {
    return [self defaultPlaceHolderWithImage:image buttonTitle:buttonTitle title:@"电波无法到达呦"];
}

+ (instancetype)defaultPlaceHolderWithImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle title:(NSString *)title {
    FOXDataSetPlaceholderView *placeholderView = [self placeholder];
    [placeholderView appendImage:image completion:nil];
    [placeholderView appendTitle:title completion:^(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width) {
        *offset = 10;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = HEXCOLOR(0x333333);
    }];
    [placeholderView appendButtonWithTitle:buttonTitle completion:^(UIButton *button, CGFloat *offset, CGFloat *height, CGFloat *width) {
        [button setTitleColor:[UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setBackgroundColor:[UIColor clearColor]];
    }];
    return placeholderView;
}


@end
