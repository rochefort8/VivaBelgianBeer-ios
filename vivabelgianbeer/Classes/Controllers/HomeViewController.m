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
- (void)loadCountdown:(CallbackHandler)handler ;

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

    // Countdown
    self.isDateInternalDebugMode = false ;
    self.enterDateIntervalDebugModeCount = 0 ;
    self.debugDateInterval = 0 ;
    self.countDownImage = [UIImage imageNamed: @"NowDownloading"];
        // Load is in viewWillAppear
    
        // Timer for countdown, 1 hour interval
    [NSTimer
     scheduledTimerWithTimeInterval:(1.0*60.0*60.0)
     target:self
     selector:@selector(onTimer:)
     userInfo:nil
     repeats:YES];
    
    // Load Ad
    self.isAdPublishing = false ;
    self.adIndex = 0 ;
    [self loadAdData:^(NSError *error) {
        if (!error){
            [self startAd];
            // No error
        } else {
            // Something happened..
        }
    }];
    
    self.adTimer = nil ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
   
    // Load countdown
    [self loadCountdown:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
    }];
    
    // Start advertizement
    [self startAd] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self stopAd] ;
}

- (void)onTimer:(NSTimer *)timer {
    // Load message from server
    [self loadCountdown:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
    }];
}

- (NSInteger)getCurrentDateInterval {
    NSDate *currentDate = [NSDate date];
    
    // Get internal date from now to target date
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSDate *dateB = [inputDateFormatter dateFromString:@"2015/11/07 00:00:00"];
    NSTimeInterval  since = [dateB timeIntervalSinceDate:currentDate];
    NSInteger dateInterval = (int)since/(24*60*60)+1;
    
    return dateInterval ;
}

- (void)loadCountdown:(CallbackHandler)handler {
    NSDate *currentDate = [NSDate date];
    
    // Get internal date from now to target date
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSDate *dateB = [inputDateFormatter dateFromString:@"2015/11/07 00:00:00"];
    NSTimeInterval  since = [dateB timeIntervalSinceDate:currentDate];
    NSInteger dateInterval = (int)since/(24*60*60)+1;
    
    // Already finished
    if (dateInterval < 0) {
        dateInterval = -1 ;
    }
    
    if (self.isDateInternalDebugMode == false) {
        if (self.dateInterval == dateInterval) {
            NSLog (@"dateInterval : Nothing to be done.");
            if (handler) {
                handler(nil);
            }
            return ;
        }
        
        // Should update countdown image
        self.dateInterval = dateInterval ;
    } else {
        self.dateInterval = dateInterval ;
        
        // Use value for debug
        dateInterval = self.debugDateInterval ;
        if (dateInterval < 0) {
            
            // Debug mode finished
            dateInterval = -1 ;
            self.isDateInternalDebugMode = false ;
        }
    }
    NSString *key ;
    if (dateInterval <= 120) { // From "-1" to "100
        key = [NSString stringWithFormat:@"%ld", (long)dateInterval];
        if (self.isDateInternalDebugMode == false) {
            if (100 < dateInterval) { // From "-1" to "100
                key = @"101" ;
            }
        }
        
    } else {
        key = @"101" ;
    }
    
    // Load news from parse
    PFQuery *query = [PFQuery queryWithClassName:@"Countdown"];
    [query whereKey:@"title" equalTo: key];
 
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"HomeViewController, Can't get countdown object for %@",key) ;
            if (handler) {
                handler(error);
            }
            return ;
        }
        
        PFFile *imageFile = [object objectForKey:@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                UIImage *image = [UIImage imageWithData:data];
                self.countDownImage = image ;
                NSLog(@"Got countdown image");
            } else {
                NSLog(@"no data!");
            }
            [self.tableView reloadData];
            if (handler) {
                handler(error);
            }
        }];
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
        [self loadCountdown:^(NSError *error) {
            if (!error){
                // No error
            } else {
                // Something happened..
            }
            // Load Ad
            [self loadAdData:^(NSError *error) {
                if (!error){
                    // No error
                } else {
                    // Something happened..
                }
                [sender endRefreshing] ;
            }];
        }];
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
    [cell.messageButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.countdownButton addTarget:self action:@selector(onCountdownButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.adButton addTarget:self action:@selector(onAdButton:) forControlEvents:UIControlEventTouchUpInside];

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
        case SEGUE_TO_MESSAGEVIEW: {
            MessageViewController *secondViewController = segue.destinationViewController;
            secondViewController.msgTitle = self.messageTitle ;
            secondViewController.msgContent = self.messageContent ;
            secondViewController.msgImage = self.messageImage ;
        } break;
        case SEGUE_TO_AD_WEBVIEW: {
            AdWebViewController *secondViewController = segue.destinationViewController;
            secondViewController.adURLString = self.adURLString ;
        } break;
            
            
        default:
            break;
    }
}

- (IBAction)onMessageButton:(id)sender {
    self.segueTo = SEGUE_TO_MESSAGEVIEW;
    [self performSegueWithIdentifier:@"toMessageView" sender:self];
}

- (IBAction)onCountdownButton:(id)sender {
    if (self.isDateInternalDebugMode == true) {
        self.debugDateInterval-- ;
        NSLog (@"Countdown debug mode:interval=%ld",(long)self.debugDateInterval) ;

        [self loadCountdown:^(NSError *error) {
        }];
        
    } else {
        
        self.enterDateIntervalDebugModeCount++ ;
        NSLog (@"Count for entering countdown debug mode=%ld",(long)self.enterDateIntervalDebugModeCount) ;

        if (10 < self.enterDateIntervalDebugModeCount) {
            NSLog (@"Entered countdown debug mode.") ;
            self.isDateInternalDebugMode = true ;
            self.enterDateIntervalDebugModeCount = 0 ;
            self.debugDateInterval = 103 ;
//            self.debugDateInterval = [self getCurrentDateInterval] ;
            
        }
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
- (IBAction)onReunionRegistrationButton:(id)sender {
    NSLog (@"懇親会申し込み") ;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LikeList" bundle:nil];
    
    RegistrationViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"registration"];

//    [self presentViewController:secondViewController animated:YES completion:nil];

    [self.navigationController pushViewController:secondViewController animated:YES];
}

/* ====== Banner advertizement ====== */

- (void)startAd {

    NSInteger numberOfAd = [self.adList count] ;
    if (numberOfAd == 0) {
        NSLog(@"No ad found.") ;
        return ;
    }
    if (numberOfAd <= self.adIndex) {
        self.adIndex = 0 ;
    }
    
    PFObject *object = [self.adList objectAtIndex:self.adIndex] ;
    self.adTextStartIndex = 0 ;
    
    self.adURLString = [object objectForKey:@"link"] ;
    
    // "title -- caption"
    NSString *title = [object objectForKey:@"title"] ;
    NSString *caption = [object objectForKey:@"caption"] ;
    self.adMessage =  [title stringByAppendingString:@" -- "];
    self.adMessage = [self.adMessage stringByAppendingString:caption];
                   
    // Increment for next ad
    self.adIndex++ ;
    if (numberOfAd <= self.adIndex) {
        self.adIndex = 0 ;
    }

    
    // Timer for countdown, 1 hour interval
    self.adTimer = [NSTimer
               scheduledTimerWithTimeInterval:4.0
                    target:self
                    selector:@selector(onStartFlip:)
                    userInfo:nil
                    repeats:NO];
    self.adTextStartIndex = 0;
    [self setAdText] ;
    self.isAdPublishing = true ;
}

- (void)stopAd {
    [self.adTimer invalidate] ;
    
    self.adText = @"" ;
    self.adTextStartIndex = 0 ;
    [self.tableView reloadData] ;
    self.adTimer = nil ;
    self.isAdPublishing = false ;
}

- (void)onStartFlip:(NSTimer *)timer {
    
    // Generate next timer
    self.adTimer = [NSTimer
                    scheduledTimerWithTimeInterval:0.5
                    target:self
                    selector:@selector(onAdTimer:)
                    userInfo:nil
                    repeats:YES];
    self.adTextStartIndex++;
    [self setAdText] ;
}

- (void)onAdTimer:(NSTimer *)timer {
    self.adTextStartIndex++;
    [self setAdText] ;
}

- (void)setAdText {
    
    self.adText = [self.adMessage substringFromIndex:self.adTextStartIndex];

    if ([self.adText length] <= 0) {
        [self stopAd] ;
    }
    
    [self.tableView reloadData] ;
}

- (IBAction)onAdButton:(id)sender {
    
    if (self.isAdPublishing == false) {
        return ;
    }
    NSLog(@"onAdButton") ;
    self.segueTo = SEGUE_TO_AD_WEBVIEW;
    [self performSegueWithIdentifier:@"toAdWebView" sender:self];
}

- (void)loadAdData:(CallbackHandler)handler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Ad"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"[Ad] Error");
            if (handler) {
                handler(error) ;
            }
            return;
        }
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.adList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.adList objectAtIndex:i] ;
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
            NSLog (@"[Ad] data updated, loading...") ;
            self.adList = [objects mutableCopy];
        } else {
            NSLog(@"[Ad] No updates found.") ;
        }
        if (handler) {
            handler(error) ;
        }
    }];
}


@end
