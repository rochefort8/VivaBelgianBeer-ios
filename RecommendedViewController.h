//
//  RecommendedViewController.h
//  
//
//  Created by 荻原有二 on 2016/09/25.
//
//

#import <UIKit/UIKit.h>
#import "BeerContent.h"

@interface RecommendedViewController : UIViewController {
    BeerContent *_recommendedBeer;
}

@property (strong, nonatomic) BeerContent *recommendedBeer;

@end
