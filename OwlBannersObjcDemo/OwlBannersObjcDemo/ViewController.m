//
//  ViewController.m
//  OwlBannersObjcDemo
//
//  Created by Brett Stover on 10/8/15.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

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
