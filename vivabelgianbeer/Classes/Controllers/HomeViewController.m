//
//  HomeViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/03.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "HomeViewController.h"
#import "RegistrationViewController.h"
#import "MessageViewController.h"
#import "AdWebViewController.h"
#import "HomeViewCell.h"
#import "QuestionContent.h"
#import "QuestionViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/* UI components */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

// Getting data from Parse server
typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

// Question list
@property int totalQuestionCount;
    // All questions on server
@property (strong, nonatomic) NSMutableArray *questionList;
@property (strong, nonatomic) NSMutableArray *questions;

- (void)setQuestionsFromList:(CallbackHandler)handler ;

@property (nonatomic) CGFloat viewHeight ;
@property bool initialLoad ;

@end

int table[20];

@interface HomeViewController () <PFLogInViewControllerDelegate,
            PFSignUpViewControllerDelegate>
{
    NSArray *_descriptions;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // General initialzation
    self.initialLoad = true ;
    
    // Tableview initialization
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    UINib *nib = [UINib nibWithNibName:HomeViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomeViewCell"];

    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame ;
    self.viewHeight = rect.size.height -
                self.navigationController.navigationBar.frame.size.height -
                self.tabBarController.tabBar.frame.size.height;
    
    // Question list
    self.totalQuestionCount = 3 ;
    self.questions = [[NSMutableArray alloc] init];
    for (int i = 0;i < self.totalQuestionCount;i++) {
        QuestionContent *content = [[QuestionContent alloc] init] ;
        content.object = nil ;
        [self.questions addObject:content];
    }
    
    // Activity Indicator
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];

    // Load data from server
    
    /*
     For remove warning,
     "Capturing self strongly in this block is likely to lead to a retain cycle"
     */
    __unsafe_unretained typeof(self) weakSelf = self;

    [self loadData:^(NSError *error) {
        if (!error){
            [self setQuestionsFromList:^(NSError *error) {
                if (!error) {
                    
                } else {
                    
                }
                [weakSelf.activityIndicator stopAnimating ];
                [weakSelf.startButton setEnabled:YES] ;
            }];
        } else {
            [self.activityIndicator stopAnimating ];
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
    
    [self.activityIndicator startAnimating];
    [self setQuestionsFromList:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [weakSelf.activityIndicator stopAnimating];
    }];
}


- (void)loadData:(CallbackHandler)handler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"QuestionList"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[QuestionList] Error");
            if (handler) {
                handler(error) ;
            }
            return;
        }
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.questionList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.questionList objectAtIndex:i] ;
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
            NSLog (@"[QuestionList] data updated, loading...") ;
            self.questionList = [objects mutableCopy];
        } else {
            NSLog(@"[QuestionList] No updates found.") ;
        }
        if (handler) {
            handler(error) ;
        }
    }];
}

- (void)setQuestionsFromList:(CallbackHandler)handler {
    
    // Store random position in table[]
    
    if (self.totalQuestionCount < [self.questionList count]) {
        for (int i = 0;i < self.totalQuestionCount;) {
            int rand = arc4random() % [self.questionList count] ;
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
        QuestionContent *content = [self.questions objectAtIndex:i] ;
        
        // Load object in full quiz list at random position
        PFObject *object = [self.questionList objectAtIndex:table[i]];
        content.object = object ;
        [self.questions replaceObjectAtIndex:i withObject:content];
    }
    
    
    for (int i = 0;i < self.totalQuestionCount;i++) {
        
        QuestionContent *content = [self.questions objectAtIndex:i] ;
        PFObject *object = content.object;
        
        PFFile *image = [object objectForKey:@"image"];
        
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                content.image = [UIImage imageWithData:data];
            } else {
                NSLog(@"no data!");
            }
            // FIXME !!
            [self.questions replaceObjectAtIndex:i withObject:content] ;
        }];
    }
     
    // FIXME Should call when all image load are finished..
    if (handler) {
        handler (nil) ;
    }
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
    static NSString *CellIdentifier = @"HomeViewCell";
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    /*
    [cell.messageButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.countdownButton addTarget:self action:@selector(onCountdownButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.adButton addTarget:self action:@selector(onAdButton:) forControlEvents:UIControlEventTouchUpInside];

    cell.messageContent.text = self.messageContent ;
    cell.countDownImage.image = self.countDownImage ;
    cell.adText.text = self.adText;
     */
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QuestionViewController *secondViewController = segue.destinationViewController;
    secondViewController.questions = _questions;
}

#pragma mark -
#pragma mark PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Do nothing, as the view controller dismisses itself
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    // Do nothing, as the view controller dismisses itself
}


@end
