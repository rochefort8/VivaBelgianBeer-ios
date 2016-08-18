//
//  MessageViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController {
    NSString *_msgTitle ;
    NSString *_msgeContent;
    UIImage *_msgImage ;
}

@property (strong, nonatomic) NSString *msgTitle ;
@property (strong, nonatomic) NSString *msgContent;
@property (strong, nonatomic) UIImage  *msgImage ;

@end


static NSString * const MessageViewCellIdentifier = @"MessageViewCell";
