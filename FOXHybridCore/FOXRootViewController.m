//
//  FOXRootViewController.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/2/27.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXRootViewController.h"
#import "FOXWebBrowserViewController.h"
#import "FOXTestViewController.h"

@interface FOXRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FOXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"WebView"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cateTitles].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description] forIndexPath:indexPath];
    [cell.textLabel setText:[self cateTitles][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *webBrowserVC;
    switch (indexPath.row) {
        case 0:
        {
            webBrowserVC = [FOXWebBrowserViewController webViewControllerWithAddress:@"https://baidu.com"];
        }
            break;
        case 1:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
            NSString *htmlString = [NSString stringWithContentsOfFile:path
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
            webBrowserVC = [FOXWebBrowserViewController webViewControllerWithHTMLString:htmlString baseURL:[NSURL URLWithString:path]];
        }
            break;
        case 2:
        {
            webBrowserVC = [FOXWebBrowserViewController webViewControllerWithAddress:@"https://baidusde.com"];
        }
            break;
        case 3:
        {
            webBrowserVC = [[FOXTestViewController alloc] init];
        }
            break;
            
        default:
            webBrowserVC = [FOXWebBrowserViewController webViewControllerWithAddress:@"https://baidu.com"];
            break;
    }
    
    [self.navigationController pushViewController:webBrowserVC animated:YES];
}


#pragma mark - DataSources

- (NSArray *)cateTitles {
    return @[@"WebBrowserTest",
             @"LocalWebResources",
             @"WebLoadError",
             @"TestJSValue"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
