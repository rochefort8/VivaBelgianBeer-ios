//
//  KitaKyushuFullViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/08/08.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "KitaKyushuFullViewController.h"
#import "AdFullCell.h"
#import "AdWebViewController.h"

@interface KitaKyushuFullViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CGFloat rowHeight ;

@end

@implementation KitaKyushuFullViewController
@synthesize adTitle = _adTitle ;
@synthesize adContents = _adContents ;
@synthesize adImage = _adImage;
@synthesize adLink = _adLink;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Setting up listview
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    
    UINib *nib = [UINib nibWithNibName:AdFullCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AdFullCell"];
    
    self.rowHeight = 600.0f ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AdFullCell";
    
    AdFullCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.adTitle.text = self.adTitle ;
    cell.adContent.text = self.adContents ;
    cell.adImage.image = self.adImage ;
    
    [cell.adContent sizeToFit] ;
    [cell.adImage sizeToFit] ;
    
    self.rowHeight = cell.adContent.frame.size.height +
    cell.adImage.frame.size.height + 100.0f ;
    
    return cell;
    
}

- (IBAction)onClickLink:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    AdWebViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"ad_webview"];
    secondViewController.adURLString = self.adLink ;
    [self.navigationController pushViewController:secondViewController animated:YES];
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
