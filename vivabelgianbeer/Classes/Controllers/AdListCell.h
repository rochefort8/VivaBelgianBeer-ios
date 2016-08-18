//
//  NewsListCell.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/06.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
 
+ (CGFloat)rowHeight;

@end
