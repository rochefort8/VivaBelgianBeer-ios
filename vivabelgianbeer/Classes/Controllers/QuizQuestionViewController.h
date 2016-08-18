//
//  QuizQuestionViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizQuestionViewController : UIViewController {
    NSMutableArray *_questionList ;
}
@property (weak, nonatomic) IBOutlet UIImageView *quizImage;
@property (weak, nonatomic) IBOutlet UILabel *quizTitle;
@property (weak, nonatomic) IBOutlet UILabel *quizQuestion;
@property (weak, nonatomic) IBOutlet UIButton *quizAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *quizAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *quizAnswer3;
@property (weak, nonatomic) IBOutlet UIButton *quizAnswer4;

@property (strong, nonatomic) NSMutableArray *questionList;

@property int quizPosition ;
@property int quizNumberOfRightAnswers ;


@end
