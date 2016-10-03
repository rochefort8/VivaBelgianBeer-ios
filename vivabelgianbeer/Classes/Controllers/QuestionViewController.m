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
#import "BeerContent.h"
#import "SVProgressHUD.h"

@interface QuestionViewController ()

// UI Components
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitle;

// Question view
- (void)setQuestionView ;
- (void)setNextQuestionView ;
@property NSInteger index ;

// Getting data from Parse server
typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

// Recommended Beer
- (void)chooseRecommendedBeer:(CallbackHandler)handler;
@property (strong, nonatomic) BeerContent *recommendedBeer ;

@property (strong, nonatomic) NSMutableArray *itemList;

@end
const NSInteger kNumberOfQuestions = 3;

@implementation QuestionViewController
@synthesize questions = _questions ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.recommendedBeer= [[BeerContent alloc] init] ;
    self.index = 0 ;
    [self setQuestionView] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickAnswer1:(id)sender {
    [self setNextQuestionView] ;
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
    [SVProgressHUD showWithStatus:@"探しています。"];

    [self loadData:^(NSError *error) {

        if (!error){
            [self chooseRecommendedBeer:^(NSError *error) {
                if (!error) {
                    
                    // Next view
                    RecommendedViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"recommendedView"];
                    ViewController.recommendedBeer = _recommendedBeer;
                    [self.navigationController pushViewController:ViewController animated:YES];
                    
                } else {
                    
                }
                [SVProgressHUD dismiss];
            }];
        } else {
            // Error
            [SVProgressHUD dismiss];
        }

    }];
}

- (void)chooseRecommendedBeer:(CallbackHandler)handler {
    
    // Find best one
        // At this moment, algorithm is just random in list
    int itemNo = arc4random() % [self.itemList count] ;
    PFObject *object = [self.itemList objectAtIndex:itemNo] ;
    self.recommendedBeer.object = object ;
        
    //NSString *name = [object objectForKey:@"name"] ;
    //NSString *name_jp = [object objectForKey:@"name_jp"] ;
    
    PFFile *image = [object objectForKey:@"image"];
    
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            NSLog(@"Got image!");
            self.recommendedBeer.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"no data!");
            self.recommendedBeer.image = nil ;
        }
        if (handler) {
            handler (nil) ;
        }
    }];

}

- (void)setQuestionView {
    
    self.naviTitle.title = [NSString stringWithFormat:@"質問:その%d",self.index + 1];
    
    QuestionContent *content = [self.questions objectAtIndex:self.index] ;
//    self.subject.text   = [content getTitle] ;
    self.text.text      = [content getText];
    self.image.image    = [content getImage];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)loadData:(CallbackHandler)handler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"BeerList"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[itemList] Error");
            if (handler) {
                handler(error) ;
            }
            return;
        }
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.itemList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.itemList objectAtIndex:i] ;
                if ([[latest objectId] isEqualToString:[current objectId]]) {
                    // Continue..
                } else {
                    NSLog (@"String is different %@ / %@",[latest objectId],[current objectId]) ;
                    updated = true ;
                    break ;
                }
            }
        } else {
            NSLog (@"Number is different") ;
            updated = true ;
        }
        
        // Reload view only when data had been really changed
        if (updated == true) {
            NSLog (@"[itemList] data updated, loading...") ;
            self.itemList = [objects mutableCopy];
        } else {
            NSLog(@"[itemList] No updates found.") ;
        }
        if (handler) {
            handler(error) ;
        }
    }];
}

@end
