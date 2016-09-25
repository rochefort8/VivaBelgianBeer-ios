//
//  QuestionViewController.m
//  vivabelgianbeer
//
//  Created by 荻原有二 on 2016/09/24.
//  Copyright © 2016年 Yuji Ogihara. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionContent.h"
#import "RecommendedViewController.h"

@interface QuestionViewController ()

// UI Components
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;

// Question view
- (void)setQuestionView ;
- (void)setNextQuestionView ;
@property NSInteger index ;

@end
const NSInteger kNumberOfQuestions = 3;

@implementation QuestionViewController
@synthesize questions = _questions ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.index = 0 ;
    [self setQuestionView] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickAnswer1:(id)sender {
    [self setQuestionView] ;
}

- (IBAction)onClickAnswer2:(id)sender {
    [self setNextQuestionView] ;
}

- (IBAction)onClickAnswer3:(id)sender {
    [self setNextQuestionView] ;
}

- (void)setNextQuestionView {

    self.index++ ;
    if (self.index < kNumberOfQuestions) {
        [self setQuestionView] ;
    } else {
        [self findBeer];
    }
}

- (void)findBeer {

    // Next view
    RecommendedViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"recommendedView"];
    [self.navigationController pushViewController:ViewController animated:YES];
    
}

- (void)setQuestionView {
    QuestionContent *content = [self.questions objectAtIndex:self.index] ;
    self.subject.text   = [content getTitle] ;
    self.text.text      = [content getText];
    self.image.image    = [content getImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
