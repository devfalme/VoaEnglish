//
//  WebViewController.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/8.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

#define IsIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height > 20)

@interface WebViewController () < WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate >

@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *webTitle;

@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) WKWebView *webView;

@property (nonatomic, copy) NSString *themeHexColor;

@end

@implementation WebViewController
#pragma mark - < LifeCycle >
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     else if ([keyPath isEqualToString:@"title"]) {
     if (object == self.webView) {
     self.title = self.webView.title;
     self.titleLabel.text = self.webView.title;
     } else {
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
     }
     }
     */
    [VE_VOAHUD showLoading:@"正在加载.."];
    [self setupUI];
}

#pragma mark - < KVO >
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [VE_VOAHUD hideHud];
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        if (object == self.webView) {
            [self.progressView setAlpha:1.0f];
            BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
            [self.progressView setProgress:[change[@"new"] doubleValue] animated:animated];
            
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

#pragma mark - < WKWebViewDelegate >
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [self showAlterViewControllerWithMessage:message];
}

//获取网页提示框事件
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    //获取网页提示信息并展示
    [self showAlterViewControllerWithMessage:message];
    completionHandler();
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if (url.length > 5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webUrl] options:@{} completionHandler:nil];
}

#pragma mark - < Action >
//初始化UI
- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.navigationController) {
        [self.view addSubview:self.topView];
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//弹出警告框
- (void)showAlterViewControllerWithMessage:(NSString *)message {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:nil];
}


#pragma mark - < Getter >
- (NSString *)themeHexColor {
    
    if (!_themeHexColor) {
        _themeHexColor = @"F3F4F5";
    }
    return _themeHexColor;
}

- (WKWebView *)webView {
    
    if (!_webView) {
        CGFloat y;
        if (self.navigationController) {
            y = 0;
        }else{
            if (IsIphoneX) {
                y = 88.0;
            }else{
                y = 64.0;
            }
        }
        CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - (IsIphoneX?88:64));
        
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize =10;
        config.preferences.javaScriptEnabled =YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
        config.allowsInlineMediaPlayback = YES;
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];

        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        [_webView.configuration.userContentController addUserScript:noneSelectScript];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [_webView.scrollView setAlwaysBounceVertical:YES];
        [_webView setAllowsBackForwardNavigationGestures:true];

        [_webView sizeToFit];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat y;
        if (self.navigationController) {
            y = 0;
        } else {
            if (IsIphoneX) {
                y = 88;
            }else{
                y = 64;
            }
        }
        
        CGRect frame = CGRectMake(0, y, SCREEN_WIDTH, 1);
        _progressView = [UIProgressView new];
        _progressView.frame = frame;
        _progressView.progressTintColor = [UIColor qmui_colorWithHexString:@"3492FF"];
        _progressView.trackTintColor = [UIColor qmui_colorWithHexString:@"e9e9e9"];
    }
    return _progressView;
}

- (UIView *)topView {
    if (!_topView) {
        CGFloat height = 0;
        if (!self.navigationController) {
            if (IsIphoneX) {
                height = 88.0;
            } else {
                height = 64.0;
            }
        }
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _topView.backgroundColor = [UIColor qmui_colorWithHexString:self.themeHexColor];
        if (!self.navigationController) {
            [_topView addSubview:self.titleLabel];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, height-.5, SCREEN_WIDTH, .5)];
        line.backgroundColor = UIColor.grayColor;
        [_topView addSubview:line];
    }
    return _topView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat y;
        if (IsIphoneX) {
            y = 44.0;
        } else {
            y = 20.0;
        }
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, y, SCREEN_WIDTH - 70.0, 44)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor qmui_colorWithHexString:@"41465E"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.webTitle;
    }
    return _titleLabel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
@end

