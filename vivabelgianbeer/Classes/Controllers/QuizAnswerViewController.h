//
//  QuizAnswerViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizAnswerViewController : UIViewController {
    int _quizPoition ;
    int _quizNumberOfRightAnswers ;
    NSString *quizChoice ;
    NSMutableArray *_questionList ;
}

@property (strong, nonatomic) NSMutableArray *questionList;
@property (nonatomic) int quizPosition;
@property (nonatomic) int quizNumberOfRightAnswers ;
@property (nonatomic) NSString* quizChoice;
@property (weak, nonatomic) IBOutlet UILabel *quizAnswerVerify;
@property (weak, nonatomic) IBOutlet UILabel *quizAnswer;
@property (weak, nonatomic) IBOutlet UILabel *quizDescription;
@property (weak, nonatomic) IBOutlet UIImageView *quizAnswerImage;
@property (weak, nonatomic) IBOutlet UILabel *quizYourAnswer;

@end
