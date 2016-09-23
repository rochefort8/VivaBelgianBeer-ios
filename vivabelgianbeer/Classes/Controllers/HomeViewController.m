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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *messageList;

@property (strong, nonatomic) PFObject  *messageObject ;
@property (strong, nonatomic) UIImage   *messageImage ;
@property (nonatomic) NSString   *messageContent ;
@property (nonatomic) NSString   *messageTitle ;
@property (nonatomic) NSInteger  dateInterval ;
@property (strong, nonatomic) UIImage   *countDownImage ;
@property NSInteger enterDateIntervalDebugModeCount ;
@property BOOL isDateInternalDebugMode ;
@property NSInteger debugDateInterval ;

// Banner Advertizement
@property (nonatomic) bool isAdPublishing ;
@property (strong, nonatomic) NSMutableArray *adList;
@property (nonatomic) NSInteger adIndex ;

@property (nonatomic) NSString   *adMessage ;
@property (nonatomic) NSString   *adURLString ;

@property (nonatomic) NSString   *adText ;
@property NSInteger adTextStartIndex ;
@property (nonatomic) NSTimer *adTimer ;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CGFloat viewHeight ;

enum {
    SEGUE_TO_MESSAGEVIEW = 0,
    SEGUE_TO_AD_WEBVIEW
} ;
@property (nonatomic) NSInteger segueTo ;

@end

@interface HomeViewController () <PFLogInViewControllerDelegate,
            PFSignUpViewControllerDelegate>
{
    NSArray *_descriptions;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;

    UINib *nib = [UINib nibWithNibName:HomeViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomeViewCell"];

    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame ;
    self.viewHeight = rect.size.height -
                self.navigationController.navigationBar.frame.size.height -
                self.tabBarController.tabBar.frame.size.height;
    
    // Load message from server
    [self loadData:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
    }];

}

- (void)loadData:(CallbackHandler)handler {
    // Load news from parse
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query orderByDescending:@"_created_at"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"HomeViewController, Can't get first object") ;
            /*
             [self.messageActivityIndicator stopAnimating ];
             */
            if (handler) {
                handler(error);
            }
            return ;
        }
        
        if ([[self.messageObject objectId] isEqualToString:[object objectId]]) {
            NSLog(@"[Home] No updates found.") ;

                    // Continue..
            if (handler) {
                handler(error);
            }
        } else {
            NSLog (@"[Home]String is different %@ / %@",[object objectId],[self.messageObject objectId]) ;
            
            self.messageObject = object ;
            self.messageContent = [object objectForKey:@"message"];
            self.messageTitle = [object objectForKey:@"title"];
        
            PFFile *imageFile = [object objectForKey:@"image"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error){
                    UIImage *image = [UIImage imageWithData:data];
                    self.messageImage = image ;
                    NSLog(@"Got image");
                } else {
                    NSLog(@"no data!");
                }
                [self.tableView reloadData];
                if (handler) {
                    handler(error);
                }
            }];
        }
    }];
}

- (IBAction)onRefresh:(id)sender {
    [self loadData:^(NSError *error) {
        
        if (!error){
            // No error
        } else {
            // Something happened..
        }
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
*/
    cell.messageContent.text = self.messageContent ;
    cell.countDownImage.image = self.countDownImage ;
    cell.adText.text = self.adText;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    switch (self.segueTo) {
            
        default:
            break;
    }
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
