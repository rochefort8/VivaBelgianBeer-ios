//
//  RecommendedViewController.m
//  
//
//  Created by 荻原有二 on 2016/09/25.
//
//

#import "RecommendedViewController.h"

@interface RecommendedViewController ()

// UI components
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *name_jp;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *beerDescription;

@end

@implementation RecommendedViewController
@synthesize recommendedBeer = _recommendedBeer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    
    self.name.text              = [self.recommendedBeer getName] ;
    self.name_jp.text           = [self.recommendedBeer getName_JP];
    self.beerDescription.text   = [self.recommendedBeer getDescription];
    self.image.image            = [self.recommendedBeer getImage];

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
