//
//  KitaKyushuFullViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/08/08.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KitaKyushuFullViewController : UIViewController {
    NSString *_adTitle ;
    NSString *_adContents;
    UIImage *_adImage ;
    NSString *_adLink ;
}

@property (strong, nonatomic) NSString *adTitle;
@property (strong, nonatomic) NSString *adContents;
@property (strong, nonatomic) UIImage  *adImage ;
@property (strong, nonatomic) NSString *adLink;

@end

static NSString * const AdFullCellIdentifier = @"AdFull";

