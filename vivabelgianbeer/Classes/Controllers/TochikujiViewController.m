//
//  TochikujiViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "TochikujiViewController.h"
#import "TochikujiViewCell.h"
#import "TochikujiSlideViewController.h"
#import "TochikujiContent.h"

@interface TochikujiViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tochikujiList;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

@property (nonatomic) CGFloat viewHeight ;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray *slideList;
@property int totalSlideImageCount ;
@property bool initialLoad ;
@property int loopCounter ;

@end

int table[100];

@implementation TochikujiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationItem setHidesBackButton:YES];
    
    self.initialLoad = true ;
    self.totalSlideImageCount = 10 ;
    
    self.slideList = [[NSMutableArray alloc] init];
    for (int i = 0;i < self.totalSlideImageCount;i++) {
        TochikujiContent *content = [[TochikujiContent alloc] init] ;
        content.object = nil ;
        [self.slideList addObject:content];
    }


    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    // Prepare XIB for each cell
    UINib *nib = [UINib nibWithNibName:TochikujiViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TochikujiViewCell"];
    
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame ;
    self.viewHeight = rect.size.height -
    self.navigationController.navigationBar.frame.size.height -
    self.tabBarController.tabBar.frame.size.height;
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating];
    
    /*
     For remove warning,
     "Capturing self strongly in this block is likely to lead to a retain cycle"
     */
    __unsafe_unretained typeof(self) weakSelf = self;
    
    // Load all news from server
    [self loadData:^(NSError *error) {
        if (!error){
            [self setNewTochikujiList:^(NSError *error) {
                if (!error) {

                } else {
                    
                }
                [weakSelf.activityIndicator stopAnimating ];
                [weakSelf.startButton setEnabled:YES] ;
            }] ;
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
    [self setNewTochikujiList:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [weakSelf.activityIndicator stopAnimating];
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
    static NSString *CellIdentifier = @"TochikujiViewCell";
    TochikujiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

- (void)loadData:(CallbackHandler)handler {
    
    // Load news from parse
    PFQuery *query = [PFQuery queryWithClassName:@"Tochikuji"];
    [query orderByDescending:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                      
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            if (handler) {
                handler(error);
            }
            return;
        }
        
        NSMutableArray *latestList = [objects mutableCopy];
        bool updated = false ;
        if ([latestList count] == [self.tochikujiList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.tochikujiList objectAtIndex:i] ;
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
            NSLog (@"Tochikuji data updated, loading...") ;
            // Clear all data..
            [self.tochikujiList removeAllObjects];
            self.tochikujiList = [objects mutableCopy];
        } else {
            NSLog(@"[Tochikuji] No updates found.") ;
        }
        if (handler) {
            handler(error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TochikujiSlideViewController *secondViewController = segue.destinationViewController;
    secondViewController.slideList = _slideList ;
}

- (void)setNewTochikujiList:(CallbackHandler)handler {
    
    
    if (self.totalSlideImageCount < [self.tochikujiList count]) {
        for (int i = 0;i < self.totalSlideImageCount;) {
            int rand = arc4random() % [self.tochikujiList count] ;
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
        for (int i = 0;i < self.totalSlideImageCount;) {
            table[i] = 0 ;
        }
    }
/*
    for (int i = 0;i < self.totalSlideImageCount;i++) {
        NSLog (@"table[%d]:%d",i,table[i]) ;
    }
*/
    for (int i = 0;i < self.totalSlideImageCount;i++) {
        TochikujiContent *content = [self.slideList objectAtIndex:i] ;
        
        // Load object in full quiz list at random position
        PFObject *object = [self.tochikujiList objectAtIndex:table[i]];
        content.object = object ;
        [self.slideList replaceObjectAtIndex:i withObject:content];
    }
    
    self.loopCounter = 0;
    for (int i = 0;i < self.totalSlideImageCount;i++) {
        
        TochikujiContent *content = [self.slideList objectAtIndex:i] ;
        PFObject *object = content.object;
        
        PFFile *image = [object objectForKey:@"image"];
        
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                content.image = [UIImage imageWithData:data];
            } else {
                NSLog(@"no data!");
            }
            [self.slideList replaceObjectAtIndex:i withObject:content] ;

            self.loopCounter++  ;
            if (self.totalSlideImageCount <= self.loopCounter) {
                if (handler) {
                    NSLog(@"[Tochikuji] Done downloading.") ;
                    handler (nil) ;
                }
            }
        }];
    }
}

@end
