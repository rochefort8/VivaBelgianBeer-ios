//
//  RecommendedViewController.m
//  
//
//  Created by 荻原有二 on 2016/09/25.
//
//

#import "RecommendedViewController.h"

@interface RecommendedViewController ()

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}

@end
