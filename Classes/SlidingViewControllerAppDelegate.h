//
//  SlidingViewControllerAppDelegate.h
//  SlidingViewController
//
//  Created by Christopher Motl on 1/22/11.
//  Copyright 2011 cmotl.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewController.h"


@interface SlidingViewControllerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SlidingViewController *slidingViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) SlidingViewController *slidingViewController;

@end

