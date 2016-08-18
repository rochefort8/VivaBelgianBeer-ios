//
//  QuizQuestionViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "QuizQuestionViewController.h"
#import "QuizAnswerViewController.h"
#import "QuizContent.h"

//#import <Parse/Parse.h>

@interface QuizQuestionViewController ()

@property NSString *quizChoice ;

- (void)setQuestionView ;

@end

@implementation QuizQuestionViewController
@synthesize questionList = _questionList ;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.quizPosition = 0 ;
    self.quizNumberOfRightAnswers = 0 ;
   [self setQuestionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title =
        [NSString stringWithFormat:@"第%d問",self.quizPosition+1];
    [self setQuestionView] ;
}

- (void)setQuestionView {
    QuizContent *content = [self.questionList objectAtIndex:self.quizPosition] ;
    self.quizTitle.text      = [content getTitle] ;
    self.quizQuestion.text   = [content getQuiz];
    
    [self.quizAnswer1 setTitle:[content getChoice1] forState:UIControlStateNormal] ;
    [self.quizAnswer2 setTitle:[content getChoice2] forState:UIControlStateNormal] ;
    [self.quizAnswer3 setTitle:[content getChoice3] forState:UIControlStateNormal] ;
    [self.quizAnswer4 setTitle:[content getChoice4] forState:UIControlStateNormal] ;
    self.quizImage.image = [content getQuizImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuizAnswerViewController *secondViewController = segue.destinationViewController;
    secondViewController.questionList = _questionList;
    secondViewController.quizPosition = _quizPosition ;
    secondViewController.quizChoice = _quizChoice ;
    secondViewController.quizNumberOfRightAnswers = _quizNumberOfRightAnswers ;
}

- (IBAction)onClickAnswer1:(id)sender {
    self.quizChoice = @"1" ;
}

- (IBAction)onClickAnswer2:(id)sender {
    self.quizChoice = @"2" ;

}

- (IBAction)onClickAnswer3:(id)sender {
    self.quizChoice = @"3" ;

}

- (IBAction)onClickAnswer4:(id)sender {
}

@end
