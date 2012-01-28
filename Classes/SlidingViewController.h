//
//  SlidingViewController.h
//  SlidingViewController
//
//  Created by Christopher Motl on 1/22/11.
//  Copyright 2011 cmotl.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingViewController : UIViewController<UIGestureRecognizerDelegate> {
	UIView *slidingView;
}

@property (nonatomic, strong) UIView *slidingView;


-(void)viewTouched;

@end
