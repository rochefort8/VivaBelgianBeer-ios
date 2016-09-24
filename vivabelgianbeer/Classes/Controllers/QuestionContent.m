//
//  QuestionList.m
//  vivabelgianbeer
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "QuestionContent.h"

@implementation QuestionContent

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

- (NSString*)getTitle {
    return [self.object objectForKey:@"title"] ;
}

- (NSString*)getText {
    return [self.object objectForKey:@"text"] ;
}

- (UIImage*)getImage {
    return self.image ;
}

@end
