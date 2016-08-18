//
//  QuizViewController.h
//  LikeTochiku
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizQuestionViewController.h"

@interface QuizViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *quizView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *quizActivityIndicator;

@end

static NSString * const QuizViewCellIdentifier = @"QuizViewCell";

