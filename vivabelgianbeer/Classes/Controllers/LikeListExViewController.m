//
//  LikeListExViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/05/23.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "LikeListExViewController.h"
#import "HomeViewController.h"
#import "RegistrationViewController.h"
#import "AdWebViewController.h"
#import "AppDelegate.h"

@interface LikeListExViewController ()

@end

@implementation LikeListExViewController

enum {
    SECTION_TOP = 0,
    SECTION_LIKE,
    SECTION_SETTINGS,
    NUMBER_OF_SECTION
} ;

enum {
    ITEM_SPECIAL_SITE = 0,
    ITEM_REUNION_REGISTRATION,
    NUMBER_OF_ROWS_IN_SECTION_TOP
} ;

enum {
    ITEM_HOME = 0,
    ITEM_PHOTORELAY,
    ITEM_QUIZ,
    ITEM_NEWS,
    ITEM_LIKE_KITAKYUSHU,
    ITEM_SHOPPING,
    ITEM_TOCHIKUJI,
    ITEM_SCHOOLROUTE,
    NUMBER_OF_ROWS_IN_SECTION_LIKE
} ;

enum {
    ITEM_SETTINGS = 0 ,
    ITEM_COMMENT,
    ITEM_LOGOUT,
    NUMBER_OF_ROWS_IN_SECTION_SETTINGS
} ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUMBER_OF_SECTION ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case SECTION_TOP:
            return NUMBER_OF_ROWS_IN_SECTION_TOP ;
        case SECTION_LIKE:
            return NUMBER_OF_ROWS_IN_SECTION_LIKE ;
        case SECTION_SETTINGS:
            return NUMBER_OF_ROWS_IN_SECTION_SETTINGS ;
        default:
            break;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch (indexPath.section) {
        case SECTION_TOP:
            [self doSectionTop:indexPath.row];
            break;

        case SECTION_LIKE :
            [self doSectionLike:indexPath.row];
            break;

        case SECTION_SETTINGS :
            [self doSectionSettings:indexPath.row] ;
            break ;
        default:
            break ;
            
    }
}

- (void)doSectionTop:(NSInteger)item
{
    switch (item) {
        case ITEM_REUNION_REGISTRATION :
            [self performSegueWithIdentifier:@"toRegistrationView" sender:self];
            break ;
        case ITEM_SPECIAL_SITE:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            
            AdWebViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"ad_webview"];
            secondViewController.adURLString = @"http://tokyo2016.tochiku.com/";
            [self.navigationController pushViewController:secondViewController animated:YES];
        } break ;
        default :
            break ;
    }
}

- (void)doSectionSettings:(NSInteger)item
{
    switch (item) {
        case ITEM_SETTINGS :
            [self performSegueWithIdentifier:@"toSettingsView" sender:self];
            break;
        case ITEM_COMMENT :
            [self performSegueWithIdentifier:@"toCommentView" sender:self];
            break;
        case ITEM_LOGOUT:
            [self logOut] ;
            break ;
        default :
            break ;
    }

}

- (void)doSectionLike:(NSInteger)item
{
    if (NUMBER_OF_ROWS_IN_SECTION_LIKE <= item) {
        NSLog (@"doSectionLike : Illegal number item=%ld",(long)item);
        return ;
    }
    
    switch (item) {
        case ITEM_LIKE_KITAKYUSHU: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"KitaKyushu" bundle:nil];
            UIViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"kitakyushu"];
            [self.navigationController pushViewController:secondViewController animated:YES];
        } break;
            
        case ITEM_SHOPPING: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            
            AdWebViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"ad_webview"];
            secondViewController.adURLString = @"http://tokyo2015.tochiku.com/goods.html";
            [self.navigationController pushViewController:secondViewController animated:YES];
        } break ;

        case ITEM_TOCHIKUJI:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tochikuji" bundle:nil];
            UIViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"Tochikuji"];
            [self.navigationController pushViewController:secondViewController animated:YES];
        } break;
        case ITEM_SCHOOLROUTE:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolRoute" bundle:nil];
            UIViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"SchoolRoute"];
            [self.navigationController pushViewController:secondViewController animated:YES];
        } break;

        default: {
            UITabBarController *controller = nil ;
            controller = self.tabBarController ;
            controller.selectedViewController =
            [controller.viewControllers objectAtIndex:item];
        } break ;
    }
}


- (void)logOut {
    UIAlertController * ac =
    [UIAlertController alertControllerWithTitle:@"ログアウトしますか?"
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * destructiveAction =
    [UIAlertAction actionWithTitle:@"ログアウト"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * action) {
                               NSLog(@"Destructive button tapped.");
                               [(AppDelegate*)[[UIApplication sharedApplication] delegate] doLogout];
                               
                           }];
    
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:@"しない"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               NSLog(@"OK button tapped.");
                           }];
    
    [ac addAction:destructiveAction];
    [ac addAction:okAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
