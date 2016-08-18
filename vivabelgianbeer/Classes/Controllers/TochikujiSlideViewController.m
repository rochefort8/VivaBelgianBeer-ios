//
//  TochikujiSlideViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/04.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "TochikujiSlideViewController.h"
#import "TochikujiResultViewController.h"
#import "TochikujiViewController.h"
#import "TochikujiContent.h"

@interface TochikujiSlideViewController ()

@property (nonatomic) NSTimer *slideShowTimer;
@property (nonatomic) float slideShowTimerInterval;
@property (nonatomic) float slideShowFadeInDuration;
@property (nonatomic) int currentImageIndex;
@property (nonatomic) int totalSlideCount;
@property (nonatomic) int imageWidth;
@property (nonatomic) int imageHeight;
@property (nonatomic) BOOL isRunningSlideShow;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) AVAudioPlayer *audioPlayer;

@end

#define MAX_SLIDESHOW_NUM (50)

@implementation TochikujiSlideViewController
@synthesize slideList = _slideList ;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];

    [self initSlideShowImages];
    [self initAudio];
    [self initSlideShowImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startSlideShow] ;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopSlideShow] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TochikujiResultViewController *ViewController = segue.destinationViewController;
    ViewController.tochikujiImage=self.imageView.image ;
}

- (IBAction)onTouch:(id)sender {
    NSLog(@"onTouch") ;
    [self stopSlideShow] ;
    sleep(1) ;
    [self performSegueWithIdentifier:@"toTochikujiResultView" sender:self];
}

- (void)initSlideShowImages
{
    /*
    self.slideShowImages = [NSMutableArray arrayWithObjects:
                            @"t0",
                            @"t1",
                            @"t2",
                            @"t3",
                            @"t4",
                            nil];
     */
//    self.slideShowImageNum = [self.slideShowImages count] - 1;
//    self.slideShowImageNum = (int)[self.slideList count] ;
    self.currentImageIndex = 0;

    //  self.slideShowTimerInterval = 5.0f
    self.slideShowTimerInterval = 0.4f;
    self.slideShowFadeInDuration = 0.1;
    self.imageWidth = 320;
    self.imageHeight = 568;
}

- (IBAction)onCancel:(id)sender {
    if (self.isRunningSlideShow == YES) {
        [self stopSlideShow] ;
        NSInteger count = self.navigationController.viewControllers.count - 2;
        TochikujiViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
        [self.navigationController popToViewController:vc animated:YES];

    }
}

- (void)initAudio
{
    NSError *error ;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tochikuji" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = -1 ;
    if ( error != nil ) {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    
}

- (void)initSlideShowImageView
{
    /*
    self.imageView.image = [self getUIImageFromResources:[self.slideShowImages objectAtIndex:self.currentImageIndex] ext:@"jpg"];
    //UIImageViewを UIViewに乗せる
*/
    TochikujiContent *content = [self.slideList objectAtIndex:0] ;
    self.imageView.image = content.image ;
    UIView *slideShowView = [[UIView alloc] init];
    slideShowView = self.imageView;
    [self.view addSubview:slideShowView];
}

- (void)startSlideShow
{
    if (self.isRunningSlideShow) {
        return;
    }
    if ([self isLastImage]) {
        self.currentImageIndex = -1;
    }
    self.slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:self.slideShowTimerInterval
                                                           target:self
                                                         selector:@selector(nextSlideShow:)
                                                         userInfo:nil
                                                          repeats:YES];
    self.isRunningSlideShow = YES;
    self.totalSlideCount = 0 ;
    
    [self.audioPlayer play];
}

- (void)nextSlideShow:(NSTimer*)timer
{
    if ([self isLastImage]) {
        self.currentImageIndex = -1;
    }
    [self changeToNextImage];
}

- (void)changeToNextImage
{
    self.currentImageIndex++;

    if (MAX_SLIDESHOW_NUM <= self.totalSlideCount) {
        self.totalSlideCount = 0 ;
        [self stopSlideShow] ;
        [self askMoreSlideshow] ;
        return ;
    }
    self.totalSlideCount++ ;
    
    /*
    NSString *imageTitle = [NSString stringWithFormat:@"%@", [self.slideShowImages objectAtIndex:self.currentImageIndex]];
    self.imageView.image = [self getUIImageFromResources:imageTitle ext:@"jpg"];
*/
    TochikujiContent *content = [self.slideList objectAtIndex:self.currentImageIndex] ;
    self.imageView.image = content.image ;
    
    _imageView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:self.slideShowFadeInDuration];
    _imageView.alpha = 1;
    [UIView commitAnimations];
}

- (void) askMoreSlideshow {
    UIAlertController * ac =
    [UIAlertController alertControllerWithTitle:@"20秒経過しました"
                                    message:@"続けますか？"
                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * destructiveAction =
    [UIAlertAction actionWithTitle:@"止める"
                         style:UIAlertActionStyleDestructive
                       handler:^(UIAlertAction * action) {
                           NSInteger count = self.navigationController.viewControllers.count - 2;
                           TochikujiViewController *vc = [self.navigationController.viewControllers objectAtIndex:count];
                           [self.navigationController popToViewController:vc animated:YES];

                           
                       }];

    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:@"続ける"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               [self startSlideShow] ;
                           }];

    [ac addAction:destructiveAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)stopSlideShow
{
    [self.slideShowTimer invalidate];
    self.isRunningSlideShow = NO;
    
    [self.audioPlayer stop];

}

- (void)callSlideShow
{
    if (self.isRunningSlideShow) {
        [self stopSlideShow];
    } else {
        [self startSlideShow];
    }
    self.isRunningSlideShow = !self.isRunningSlideShow;
}

- (BOOL)isLastImage
{
//    return (self.slideShowImageNum <= self.currentImageIndex);
    return ([self.slideList count]-1 <= self.currentImageIndex);
}

- (UIImage *)getUIImageFromResources:(NSString*)fileName ext:(NSString*)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    return img;
}

@end
