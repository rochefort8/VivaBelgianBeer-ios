//
//  KitaKyushuViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/07/20.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "KitaKyushuViewController.h"
#import "KitaKyushuFullViewController.h"
#import "AdListCell.h"

@interface KitaKyushuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *adList;

@property (nonatomic) NSInteger clickedPosition ;
@property (nonatomic) UIImage *fullViewImage ;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

@end

@implementation KitaKyushuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    // Prepare XIB for each cell
    UINib *nib = [UINib nibWithNibName:KitaKyushuListCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AdCell"];
    
    // Start actiity indicator
//    [self.activityIndicator setHidesWhenStopped:YES];
//    [self.activityIndicator startAnimating ];
    
    // Load all news from server
    [self loadData:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
//        [self.newsActivityIndicator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.adList count] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AdCell";
    AdListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFObject *object = [self.adList objectAtIndex:indexPath.row] ;
    cell.title.text     = [object objectForKey:@"title"] ;
    cell.content.text     = [object objectForKey:@"caption"] ;
    
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            UIImage *image = [UIImage imageWithData:data];
            cell.picture.image = image ;
        } else {
            NSLog(@"no data!");
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdListCell rowHeight];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    KitaKyushuFullViewController *secondViewController = segue.destinationViewController;
    
    PFObject *object = [self.adList objectAtIndex:self.clickedPosition] ;
    
    // Provide title,contents and image to large view
    secondViewController.adTitle = [object objectForKey:@"title"] ;
    secondViewController.adContents = [object objectForKey:@"caption"] ;
    secondViewController.adLink = [object objectForKey:@"link"] ;

    secondViewController.adImage = self.fullViewImage ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.clickedPosition = indexPath.row ;
    PFObject *object = [self.adList objectAtIndex:indexPath.row] ;
    PFFile *imageFile = [object objectForKey:@"image"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            self.fullViewImage = [UIImage imageWithData:data];
            [self performSegueWithIdentifier:@"toAdFullView" sender:self];
        } else {
            NSLog(@"no data!");
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
        [sender endRefreshing] ;
    }];
}

- (void)loadData:(CallbackHandler)handler {
    
    // Load news from parse
    PFQuery *query = [PFQuery queryWithClassName:@"Ad"];
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
            NSLog (@"Ad data updated, loading...") ;
            // Clear all data..
            [self.adList removeAllObjects];
            self.adList = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"[Ad] No updates found.") ;
        }
        if (handler) {
            handler(error);
        }
    }];
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
