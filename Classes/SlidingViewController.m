    //
//  SlidingViewController.m
//  SlidingViewController
//
//  Created by Christopher Motl on 1/22/11.
//  Copyright 2011 cmotl.com. All rights reserved.
//

#import "SlidingViewController.h"

#define SLIDING_VIEW_VISIBLE_HEIGHT 40
#define SLIDING_VIEW_HEIGHT 200

typedef enum {
	UP, DOWN
} Direction;

typedef enum {
	HIDDEN, VISIBLE
} Visibility;

@implementation SlidingViewController {
    Direction direction;
    Visibility visibility;
    
    UITapGestureRecognizer *recognizer;
    UITapGestureRecognizer *slidingRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    
    CGFloat startX;
    CGFloat startY;
}


@synthesize slidingView;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.view.backgroundColor = [UIColor greenColor];
	
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSlidingView)];
	recognizer.delegate = self;
	[self.view addGestureRecognizer:recognizer];
    
	self.slidingView = [[UIView alloc] initWithFrame:CGRectMake(0, 480-SLIDING_VIEW_VISIBLE_HEIGHT, 320, SLIDING_VIEW_HEIGHT)];
	self.slidingView.backgroundColor = [UIColor blackColor];
	self.slidingView.alpha = .8;
	direction = DOWN;
	visibility = VISIBLE;

    slidingRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouched)];
	slidingRecognizer.delegate = self;
	[self.slidingView addGestureRecognizer:slidingRecognizer];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [slidingView addGestureRecognizer:panRecognizer];
    
	[self.view addSubview:slidingView];
}

-(void)slideView:(Direction)_direction{
	
    
    CGFloat max_distance_to_slide = SLIDING_VIEW_HEIGHT - SLIDING_VIEW_VISIBLE_HEIGHT;
    CGFloat actual_distance_to_slide;
    
    if(_direction == UP)
    {
        actual_distance_to_slide = slidingView.frame.origin.y - (480 - SLIDING_VIEW_HEIGHT);
    }
    else
    {
        actual_distance_to_slide = 480 - slidingView.frame.origin.y - SLIDING_VIEW_VISIBLE_HEIGHT; 
    }
    
    CGFloat percent_to_slide = actual_distance_to_slide/max_distance_to_slide;
    
    CGFloat animation_duration = 0.3f * percent_to_slide;
    
    printf("Max distance to slide:    %f\n", max_distance_to_slide);
    printf("Actual distance to slide: %f\n", actual_distance_to_slide);
    printf("Percent to slide:         %f\n\n", percent_to_slide);
    
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animation_duration];
    
    
	//slidingView.frame = CGRectMake(0, _direction==DOWN?0:-SLIDING_VIEW_HEIGHT+SLIDING_VIEW_VISIBLE_HEIGHT, 320, SLIDING_VIEW_HEIGHT);
	slidingView.frame = CGRectMake(0, _direction==UP?480-SLIDING_VIEW_HEIGHT:480-SLIDING_VIEW_VISIBLE_HEIGHT, 320, SLIDING_VIEW_HEIGHT);
	[UIView commitAnimations];
}
-(void)slideDown {
    [self slideView:DOWN];
    direction = DOWN;
}
-(void)slideUp {
    [self slideView:UP];
    direction = UP;
}
-(void)viewTouched{
	NSLog(@"view touched");
	
	if (direction == DOWN) {
		[self slideUp];
	}
	else {
		[self slideDown];
        
	}
}

-(void)move:(id)sender {
    
    
    //[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        startX = [[sender view] center].x;
        startY = [[sender view] center].y;
    }

    translatedPoint = CGPointMake(startX, startY + translatedPoint.y);
    
    printf("Translated Point y: %f\n", translatedPoint.y);
    

    if (translatedPoint.y <= 480-SLIDING_VIEW_HEIGHT/2) {
        translatedPoint.y = 480-SLIDING_VIEW_HEIGHT/2;
    }
    else if (translatedPoint.y >= 480 + SLIDING_VIEW_HEIGHT/2 - SLIDING_VIEW_VISIBLE_HEIGHT) {
        translatedPoint.y = 480 + SLIDING_VIEW_HEIGHT/2 - SLIDING_VIEW_VISIBLE_HEIGHT;
    }
    [[sender view] setCenter:translatedPoint];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        /*
        CGFloat velocityX = (0.3*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        CGFloat velocityY = (0.3*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        CGFloat finalX = startX;        
        CGFloat finalY = translatedPoint.y + velocityY;
        
        if(finalY <= 480-SLIDING_VIEW_HEIGHT/2) {    
            finalY = 480-SLIDING_VIEW_HEIGHT/2;
        }
        else if(finalY >= 480 + SLIDING_VIEW_HEIGHT/2 - SLIDING_VIEW_VISIBLE_HEIGHT) {   
            finalY = 480 + SLIDING_VIEW_HEIGHT/2 - SLIDING_VIEW_VISIBLE_HEIGHT;
        }
    
        
        CGFloat animationDuration = (ABS(velocityX)*.0003)+.3;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
         */
        
        CGFloat slidingViewUpYCoordinate = 480 - SLIDING_VIEW_HEIGHT;
        CGFloat slidingViewDownYCoordinate = 480 - SLIDING_VIEW_VISIBLE_HEIGHT;
        
        if (direction == UP && slidingView.frame.origin.y > slidingViewUpYCoordinate)
        {
            printf("Up, and sliding down\n");
            [self slideDown];
        }
        else if (direction == DOWN && slidingView.frame.origin.y < slidingViewDownYCoordinate)
        {
            printf("Down, and sliding up\n");
            [self slideUp];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if (touch.view == slidingView && gestureRecognizer == slidingRecognizer) {
        return YES;
    }
    else if (touch.view == slidingView && gestureRecognizer == panRecognizer) {
        return YES;
    }
    else if(touch.view == self.view && gestureRecognizer == recognizer) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)hideSlidingView{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35f];
	if (visibility == VISIBLE) {
		slidingView.alpha = 0;
		visibility = HIDDEN;
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	}
	else {
		slidingView.alpha = .8;
		visibility = VISIBLE;
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	}
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.slidingView = nil;
}

@end
