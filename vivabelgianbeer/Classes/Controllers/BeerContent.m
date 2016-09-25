//
//  BeerContent.m
//  vivabelgianbeer
//
//  Created by 荻原有二 on 2016/09/25.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "BeerContent.h"

@implementation BeerContent

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

- (NSString*)getName {
    return [self.object objectForKey:@"name"] ;
}

- (NSString*)getName_JP {
    return [self.object objectForKey:@"name_jp"] ;
}

- (NSString*)getDescription {
    return [self.object objectForKey:@"description"] ;
}

- (UIImage*)getImage {
    return self.image ;
}

@end
