//
//  SchoolRouteVideoViewController.m
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "SchoolRouteVideoViewController.h"
#import "AppDelegate.h"

@implementation SchoolRouteVideoViewController

@synthesize videoId = _videoId ;


- (void)viewDidLoad {
    [super viewDidLoad];

    [(AppDelegate*)[[UIApplication sharedApplication] delegate] allowOrientationLandscape:true];

    self.playerView.delegate = self;

    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @0,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };
    [self.playerView loadWithVideoId:_videoId playerVars:playerVars];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;

    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    [(AppDelegate*)[[UIApplication sharedApplication] delegate] allowOrientationLandscape:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        default:
            break;
    }
}
@end
