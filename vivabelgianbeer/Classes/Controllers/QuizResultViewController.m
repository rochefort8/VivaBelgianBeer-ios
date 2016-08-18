//
//  QuizResultViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "QuizResultViewController.h"
#import "QuizViewController.h"

@interface QuizResultViewController ()

@end

@implementation QuizResultViewController
@synthesize quizNumberOfRightAnswers     = _quizNumberOfRightAnswers ;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];

    
    NSLog(@"AAA=%d",self.quizNumberOfRightAnswers);
    
    self.quizFinalResult.text =
        [NSString stringWithFormat: @"%d問正解！", self.quizNumberOfRightAnswers];
    NSString *message ;
    
    switch (self.quizNumberOfRightAnswers) {
        case 0:
            message = @"あかんやろ" ;
            break;
        case 1:
            message = @"がんばらな" ;
            break;
        case 2:
            message = @"お、いい感じ" ;
            break;
        case 3:
            message = @"やるのお" ;
            break;
            
        default:
            break;
    }
    self.quizResultMessage.text = message ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onReturn:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES] ;
}
- (IBAction)OnButtonBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}

@end
