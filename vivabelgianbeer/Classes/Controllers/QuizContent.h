//
//  QuizContent.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/11.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface QuizContent : NSObject ;

@property (nonatomic,retain) PFObject *object ;
@property (nonatomic,retain) UIImage  *quiz_image ;
@property (nonatomic,retain) UIImage  *answer_image ;

- (NSString*)getTitle ;
- (NSString*)getQuiz ;
- (NSString*)getChoice1 ;
- (NSString*)getChoice2 ;
- (NSString*)getChoice3 ;
- (NSString*)getChoice4 ;
- (NSString*)getAnswer ;
- (NSString*)getDescription ;
- (UIImage*)getQuizImage ;
- (UIImage*)getAnswerImage ;

@end
