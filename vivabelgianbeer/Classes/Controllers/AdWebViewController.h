//
//  AdWebViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/07/20.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdWebViewController : UIViewController <UIWebViewDelegate> {
    NSString *_adURLString ;
}

@property (strong, nonatomic) NSString *adURLString ;

@property (weak, nonatomic) IBOutlet UIWebView *adWebView;

@end
