//
//  TochikujiViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TochikujiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString * const TochikujiViewCellIdentifier = @"TochikujiViewCell";
