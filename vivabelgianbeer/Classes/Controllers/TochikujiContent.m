//
//  QuizContent.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/11.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "TochikujiContent.h"

@implementation TochikujiContent

- (id)init
{
    self = [super init];
    if(self) {
        // Initialize Queue
        self.object = NULL ;
        self.image = NULL ;
    }
    return self;
}

- (void)dealloc {
//    [super dealloc];
}

- (UIImage*)getImage {
    return self.image ;
}

@end
