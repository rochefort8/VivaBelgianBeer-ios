//
//  SchoolRouteViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "SchoolRouteViewController.h"
#import "SchoolRouteVideoViewController.h"
#import "SchoolRouteListCell.h"

@interface SchoolRouteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *schoolRouteList;

@property (nonatomic) NSInteger clickedPosition ;

typedef void (^CallbackHandler)(NSError *error);
- (void)loadData:(CallbackHandler)handler ;

@end

@implementation SchoolRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    // Prepare XIB for each cell
    UINib *nib = [UINib nibWithNibName:SchoolRouteListCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SchoolRouteCell"];
    
    // Start actiity indicator
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator startAnimating ];
    
    // Load all news from server
    [self loadData:^(NSError *error) {
        if (!error){
            // No error
        } else {
            // Something happened..
        }
        [self.activityIndicator stopAnimating];
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schoolRouteList count] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SchoolRouteCell";
    SchoolRouteListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFObject *object = [self.schoolRouteList objectAtIndex:indexPath.row] ;
    cell.title.text     = [object objectForKey:@"title"] ;
    cell.content.text     = [object objectForKey:@"description"] ;
    
    
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
    return [SchoolRouteListCell rowHeight];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SchoolRouteVideoViewController *secondViewController = segue.destinationViewController;
    
    PFObject *object = [self.schoolRouteList objectAtIndex:self.clickedPosition] ;
    
    secondViewController.hidesBottomBarWhenPushed = YES;
    
    // Provide title,contents and image to large view
    secondViewController.videoId = [object objectForKey:@"video_id"] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickedPosition = indexPath.row ;

/*
    UIStoryboard *storyboard = self.storyboard;
    SchoolRouteVideoViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"SchoolRouteVideoView"];
    [self presentViewController:svc animated:YES completion:nil];
    // Configure the new view controller here.

    [self presentViewController:svc animated:YES completion:nil];
 */
    
    [self performSegueWithIdentifier:@"toSchoolRouteVideoView" sender:self];
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
    PFQuery *query = [PFQuery queryWithClassName:@"SchoolRoute"];
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
        if ([latestList count] == [self.schoolRouteList count]) {
            for (int i = 0;i < [latestList count];i++) {
                PFObject *latest  = [latestList objectAtIndex:i] ;
                PFObject *current = [self.schoolRouteList objectAtIndex:i] ;
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
            NSLog (@"SchoolRoute data updated, loading...") ;
            // Clear all data..
            [self.schoolRouteList removeAllObjects];
            self.schoolRouteList = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"[SchoolRoute] No updates found.") ;
        }
        if (handler) {
            handler(error);
        }
    }];
}


@end
