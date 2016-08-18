//
//  TochikujiResultViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "TochikujiResultViewController.h"
#import "TochikujiViewController.h"

@interface TochikujiResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TochikujiResultViewController
@synthesize tochikujiImage    = _tochikujiImage ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    self.imageView.image = _tochikujiImage ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onReturn:(id)sender {
    NSInteger count       = self.navigationController.viewControllers.count - 3;
    TochikujiViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
    [self.navigationController popToViewController:vc animated:YES];
}

@end
