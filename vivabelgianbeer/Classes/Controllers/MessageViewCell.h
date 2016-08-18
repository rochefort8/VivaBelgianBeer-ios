//
//  NewsListCell.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/06.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

+ (CGFloat)rowHeight;
@property (weak, nonatomic) IBOutlet UILabel *msgBody;
@property (weak, nonatomic) IBOutlet UIImageView *msgImage;

@end
