//
//  MessageViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) CGFloat rowHeight ;

@end

@implementation MessageViewController

@synthesize msgTitle = _msgTitle ;
@synthesize msgContent = _msgContent ;
@synthesize msgImage = _msgImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rowHeight = 600.0f ;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self ;
    UINib *nib = [UINib nibWithNibName:MessageViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MessageCell"];

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
    static NSString *CellIdentifier = @"MessageCell";
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.msgBody.text = self.msgContent ;
    cell.msgImage.image = self.msgImage ;

    // Adjust tableview's height
    [cell.msgBody sizeToFit] ;
    [cell.msgImage sizeToFit] ;
    self.rowHeight = cell.msgBody.frame.size.height +
    cell.msgImage.frame.size.height + 150.0f ;

    return cell;
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
