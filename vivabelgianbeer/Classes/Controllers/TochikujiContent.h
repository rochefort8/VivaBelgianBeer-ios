//
//  QuizContent.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/11.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TochikujiContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *image ;

- (UIImage*)getImage ;

@end
