//
//  QuizViewController.m
//  LikeTochiku
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "QuizContent.h"
#import "QuizViewCell.h"
#import "QuizViewController.h"
#import <Parse/Parse.h>


@interface QuizViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *quizList;
@property (strong, nonatomic) NSMutableArray *questionList;
@property int totalQuestionCount ;
@property bool initialLoad ;

@property int counter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

- (void)setNewQuestionList:(CallbackHandler)handler ;

@property (nonatomic) CGFloat viewHeight ;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *quizActivityIndicator;

@end

int table[20];

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initialLoad = true ;
    
    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    // Prepare XIB for each cell
    UINib *nib = [UINib nibWithNibName:QuizViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"QuizViewCell"];

    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame ;
    self.viewHeight = rect.size.height -
    self.navigationController.navigationBar.frame.size.height -
    self.tabBarController.tabBar.frame.size.height;

    NSLog(@"Quiz View");

    self.totalQuestionCount = 3 ;

    self.questionList = [[NSMutableArray alloc] init];
    for (int i = 0;i < self.totalQuestionCount;i++) {
        QuizContent *content = [[QuizContent alloc] init] ;
        content.object = nil ;
        [self.questionList addObject:content];
    }

    [self.quizActivityIndicator setHidesWhenStopped:YES];
    [self.quizActivityIndicator startAnimating];

    /* 
        For remove warning,
        "Capturing self strongly in this block is likely to lead to a retain cycle"
     */
    __unsafe_unretained typeof(self) weakSelf = self;
    
    // Load all news from server
    [self loadData:^(NSError *error) {
        if (!error){
            [self setNewQuestionList:^(NSError *error) {
                if (!error) {
                    
                } else {
                    
                }
                [weakSelf.quizActivityIndicator stopAnimating ];
                [weakSelf.startButton setEnabled:YES] ;
            }] ;
        } else {
            [self.quizActivityIndicator stopAnimating ];
            [self.startButton setEnabled:YES] ;
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;


    if (self.initialLoad == true) {
        self.initialLoad = false ;
        return ;
    }
    
    // Called when restart, so change next quiz list
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.quizActivityIndicator startAnimating];
    [self setNewQuestionList:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [weakSelf.quizActivityIndicator stopAnimating];
    }];
}

- (IBAction)onRefresh:(id)sender {
    [self loadData:^(NSError *error) {
        
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [sender endRefreshing] ;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.viewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuizViewCell";
    QuizViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

- (void)loadData:(CallbackHandler)handler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Quiz"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[Quiz] Error");
            /*
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
 //           [alertView show];
             */
            if (handler) {
                handler(error) ;
            }
            return;
        }
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.quizList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.quizList objectAtIndex:i] ;
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
            NSLog (@"[Quiz] data updated, loading...") ;
            self.quizList = [objects mutableCopy];
        } else {
            NSLog(@"[Quiz] No updates found.") ;
        }
        if (handler) {
            handler(error) ;
        }
    }];
}


- (void)setNewQuestionList:(CallbackHandler)handler {
    
    // Store random position in table[]
    
    if (self.totalQuestionCount < [self.quizList count]) {
        for (int i = 0;i < self.totalQuestionCount;) {
            int rand = arc4random() % [self.quizList count] ;
            int already_exist = 0 ;
            for (int j = 0;j < i;j++) {
                if (table[j] == rand) {
                    already_exist = 1 ;
                    break ;
                }
            }
            if (!already_exist) {
                table[i] = rand ;
                i++ ;
            }
        }
    } else {
        for (int i = 0;i < self.totalQuestionCount;) {
            table[i] = 0 ;
        }
    }
    
    for (int i = 0;i < self.totalQuestionCount;i++) {
        QuizContent *content = [self.questionList objectAtIndex:i] ;
        
        // Load object in full quiz list at random position
        PFObject *object = [self.quizList objectAtIndex:table[i]];
        content.object = object ;
        [self.questionList replaceObjectAtIndex:i withObject:content];
    }
    
    
    for (int i = 0;i < self.totalQuestionCount;i++) {
        
        QuizContent *content = [self.questionList objectAtIndex:i] ;
        PFObject *object = content.object;
    
        PFFile *quiz_image = [object objectForKey:@"quiz_image"];
        
        [quiz_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                content.quiz_image = [UIImage imageWithData:data];
            } else {
                NSLog(@"no data!");
            }
            // FIXME !!
            [self.questionList replaceObjectAtIndex:i withObject:content] ;
        }];
        PFFile *answer_image = [object objectForKey:@"answer_image"];
        [answer_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                content.answer_image = [UIImage imageWithData:data];
            } else {
                NSLog(@"no data!");
            }
            // FIXME !!
            [self.questionList replaceObjectAtIndex:i withObject:content] ;
        }];
    }
    // FIXME Should call when all image load are finished..
    if (handler) {
        handler (nil) ;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuizQuestionViewController *secondViewController = segue.destinationViewController;
    secondViewController.questionList = _questionList;
}

@end
