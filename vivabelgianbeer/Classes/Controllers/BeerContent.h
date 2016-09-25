//
//  BeerContent.h
//  vivabelgianbeer
//
//  Created by 荻原有二 on 2016/09/25.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#ifndef BeerContent_h
#define BeerContent_h

@interface BeerContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *image ;

- (NSString*)getName ;
- (NSString*)getName_JP ;
- (NSString*)getDescription ;
- (UIImage*)getImage ;

@end

#endif /* BeerContent_h */
