// Copyright 2017 HootSuite Media Inc.
//
// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

#import "ViewController.h"
#import "OwlBannersObjcDemo-Swift.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++ ) {
            [[DemoBanner successBanner:@"Success banner"] enqueue];
            [[DemoBanner warningBanner:@"Warning banner"] enqueue];
            [[DemoBanner errorBanner:@"Error banner"] enqueue];
            [[DemoBanner infoBanner:@"Info banner"] enqueue];
        }
        
    });
}

@end
