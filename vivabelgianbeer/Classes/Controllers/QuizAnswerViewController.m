//
//  QuizAnswerViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "QuizAnswerViewController.h"
#import "QuizQuestionViewController.h"
#import "QuizResultViewController.h"
#import "QuizContent.h"

@interface QuizAnswerViewController ()
@property (nonatomic) bool isRightAnswer ;

- (void) setAnswerView ;
@end

@implementation QuizAnswerViewController
@synthesize questionList     = _questionList ;
@synthesize quizPosition = _quizPoition ;
@synthesize quizNumberOfRightAnswers = _quizNumberOfRightAnswers ;
@synthesize quizChoice   = _quizChoice ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    NSLog (@"Current # of right answer = %d",self.quizNumberOfRightAnswers);
    self.isRightAnswer = false ;
    [self setAnswerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title =
    [NSString stringWithFormat:@"第%d問 回答",self.quizPosition+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAnswerView {

    NSLog(@"P=%d C=%@",self.quizPosition,self.quizChoice) ;

    QuizContent *content = [self.questionList objectAtIndex:self.quizPosition] ;
    
    NSString *answer_no = [content getAnswer] ;
    NSLog(@"P=%d A=%@",self.quizPosition,answer_no) ;
    
    if ([self.quizChoice isEqualToString:answer_no]) {
        self.quizAnswerVerify.text = @"正解!!" ;
        self.quizNumberOfRightAnswers++ ;
    } else {
        self.quizAnswerVerify.text = @"残念.." ;
    }

    NSString *answer ;
    NSString *yourAnswer ;
    if ([answer_no  isEqual: @"1"]) {
        answer = [content getChoice1];
    } else {
        if ([answer_no  isEqual: @"2"]) {
            answer = [content getChoice2];
        } else {
            answer = [content getChoice3];
        }
    }
    if ([self.quizChoice  isEqual: @"1"]) {
        yourAnswer = [content getChoice1];
    } else {
        if ([self.quizChoice  isEqual: @"2"]) {
            yourAnswer = [content getChoice2];
        } else {
            yourAnswer = [content getChoice3];
        }
    }
    
    self.quizAnswer.text        = answer ;
    self.quizDescription.text   = [content getDescription] ;
    self.quizAnswerImage.image = [content getAnswerImage];
    self.quizYourAnswer.text = yourAnswer ;
}



#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuizResultViewController *secondViewController = segue.destinationViewController;
    secondViewController.quizNumberOfRightAnswer = _quizNumberOfRightAnswer ;
}
*/

- (IBAction)onClickNext:(id)sender {

    if (self.quizPosition < 2) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        QuizResultViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quiz_result"];
        ViewController.quizNumberOfRightAnswers = _quizNumberOfRightAnswers ;
        NSLog (@"Right # = %d",_quizNumberOfRightAnswers);
        [self.navigationController pushViewController:ViewController animated:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    if (self.quizPosition < 2) {
        [super viewWillDisappear:animated];
        NSArray *array = self.navigationController.viewControllers;
        NSUInteger arrayCount = [array count];
        QuizQuestionViewController *parent = [array objectAtIndex:arrayCount - 1];
        parent.quizPosition++;
        parent.quizNumberOfRightAnswers = self.quizNumberOfRightAnswers ;
    }
}

@end
