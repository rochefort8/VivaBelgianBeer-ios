//
//  AdWebViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/07/20.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "AdWebViewController.h"

@interface AdWebViewController ()

@end

@implementation AdWebViewController

@synthesize adURLString = _adURLString ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adWebView.delegate = self ;
    self.adWebView.scalesPageToFit = YES;
    self.adWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    NSURL* url = [NSURL URLWithString: self.adURLString];
    NSURLRequest* req = [NSURLRequest requestWithURL: url];
    [self.adWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] != NSURLErrorCancelled) {
        NSString* errString = [NSString stringWithFormat:                               @"<html><center><font size=+7 color='red'>エラーが発生しました。:<br>%@</font></center></html>",
                               error.localizedDescription];
        [webView loadHTMLString:errString baseURL:nil];
    }
}

@end
