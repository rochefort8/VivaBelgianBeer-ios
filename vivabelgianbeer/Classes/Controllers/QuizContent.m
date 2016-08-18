//
//  QuizContent.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/11.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "QuizContent.h"

@implementation QuizContent

- (id)init
{
    self = [super init];
    if(self) {
        // Initialize Queue
        self.object = NULL ;
        self.quiz_image = NULL ;
        self.answer_image = NULL ;
    }
    return self;
}

- (void)dealloc {
//    [super dealloc];
}

- (NSString*)getTitle {
    return [self.object objectForKey:@"title"] ;
}

- (NSString*)getQuiz {
    return [self.object objectForKey:@"quiz"] ;
}

- (NSString*)getChoice1 {
    return [self.object objectForKey:@"choice1"] ;
}

- (NSString*)getChoice2 {
    return [self.object objectForKey:@"choice2"] ;
}

- (NSString*)getChoice3 {
    return [self.object objectForKey:@"choice3"] ;
}

- (NSString*)getChoice4 {
//    return [self.object objectForKey:@"choice4"] ;
    return @"Vacant" ;
}

- (NSString*)getAnswer {
    return [self.object objectForKey:@"answer"] ;
}

- (NSString*)getDescription {
    return [self.object objectForKey:@"description"] ;
}

- (UIImage*)getQuizImage {
    return self.quiz_image ;
}

- (UIImage*)getAnswerImage {
    return self.answer_image ;
}

@end
