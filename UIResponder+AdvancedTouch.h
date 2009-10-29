//
//  UIResponder+AdvancedTouch.h
//  FJSCode
//
//  Created by Corey Floyd on 9/10/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIResponder (AdvancedTouch)

//get the current location of the touch
//only valid for single finger
//not defined if no touch is currently occuring
@property(nonatomic,readonly)CGPoint currentTouchPoint;

//toggles if touchDidMoveToLocation: is called on delegate.
//default is NO.
@property(nonatomic,assign)BOOL sendPositionUpdates;


//set delay for timer in seconds. Default 1.0
@property(nonatomic,assign)float holdDelay;

//set to control the detection of a swipe, default is 30, 20
@property(nonatomic,assign)float swipeLength;
@property(nonatomic,assign)float swipeVariance;


//set to receive notifications for touch events
//@property(nonatomic,assign)id<TouchProcessorDelegate> delegate;


//overide any of the following methods to detect actions


//update current location (only for single finger touch)
- (void)touchDidMoveToLocation:(CGPoint)aPoint;

//respond to taps
- (void)wasTappedWithCount:(int)taps;

//respond to held taps
//called even if touch is moved
- (void)wasTappedandHeld;

//respond to taps held for a specified duration which is given as the argument
//called even if touch is moved
- (void)wasTappedandHeldForDuration:(float)delay;

//respond to a double tap and hold
//called even if touch is moved
- (void)wasDoubleTappedAndHeld;

//respond to releasing of single or double tap
- (void)tapHoldWasReleased;


//respond to scaling by pinching
- (void)wasScaledByXFactor:(float)xScalingFactor yFactor:(float)yScalingFactor;
- (void)wasScaledByFactor:(float)scalingFactor;

//respond to swipes
- (void)wasSwipedHorizontally;
- (void)wasSwipedVertically;

//respond to strokes (consecutive non-directional swipes)
//consecutive strokes must be at least 90* out of phase
- (void)wasStroked:(int)times;
//really? you have a sick mind

//get path of completed touch (only works with single finger touches)
- (void)pathOfTouch:(NSArray*)path;




@end
