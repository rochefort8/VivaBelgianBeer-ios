//
//  SchoolRouteVideoViewController.h
//  vivabelgianbeer
//
//  Created by Yuji Ogihara on 2015/09/12.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface SchoolRouteVideoViewController : UIViewController<YTPlayerViewDelegate> {
    NSString *_videoId ;
}
@property (strong, nonatomic) NSString *videoId;

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end
