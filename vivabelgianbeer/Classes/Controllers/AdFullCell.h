//
//  AdFullCell.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/08/08.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdFullCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet UILabel *adContent;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;


+ (CGFloat)rowHeight;

@end
