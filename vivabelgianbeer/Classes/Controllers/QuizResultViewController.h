//
//  QuizResultViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizResultViewController : UIViewController {
    int _quizNumberOfRightAnswers ;
    
}

@property (nonatomic) int quizNumberOfRightAnswers;
@property (nonatomic) int AAA;

@property (weak, nonatomic) IBOutlet UILabel *quizFinalResult;
@property (weak, nonatomic) IBOutlet UILabel *quizResultMessage;

@end
