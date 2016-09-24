//
//  QuestionContent.h
//  vivabelgianbeer
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#ifndef QuestionContent_h
#define QuestionContent_h

@interface QuestionContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *image ;

- (NSString*)getTitle ;
- (NSString*)getText ;
- (UIImage*)getImage ;

@end

#endif /* QuestionListContent_h */
