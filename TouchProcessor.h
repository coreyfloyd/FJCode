//
//  TouchProcessor.h
//  iBalloon
//
//  Created by Corey Floyd on 7/10/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroUtilities.h"


@protocol TouchProcessorDelegate <NSObject>

@optional

//respond to taps
- (void)wasTappedWithCount:(int)taps;

//respond to held taps
- (void)wasTappedandHeld;

//respond to taps held for a specified duration which is given as the argument
- (void)wasTappedandHeldForDuration:(float)delay;

//respond to a double tap and hold
- (void)wasDoubleTappedAndHeld;

//respond to releasing of single or double tap
- (void)tapHoldWasReleased;


//respond to scaling by pinching
- (void)wasScaledByXFactor:(float)xScalingFactor yFactor:(float)yScalingFactor;

//respond to swipes
- (void)wasSwipedHorizontally;
- (void)wasSwipedVertically;


//unimplemented
- (void)pathOfTouch:(CGPathRef)path;

@end


@interface TouchProcessor : NSObject {
        
    float holdDelay;

    NSTimer *TouchHoldTimer;                    ///< Fires after a fraction of a second (1/5) to represent a held touch fires ever 1/5 second until holdDelay
    NSInteger TouchAndHoldCounter;              ///< Number of times the the timer fired and updated the touch and hold variable (could be changed to a BOOL)
    NSDate *FirstTouchTime;                     ///< Used for informational purposes only.
    
    // Double tap and hold
    NSInteger DoubleTapAndHoldCounter;          ///< Number of times the the timer fired and updated the touch and hold variable (could be changed to a BOOL)
    NSDate *DoubleTapTime;                      ///< Used for informational purposes only.
    
    // Tracking All touches
    NSMutableArray *ActiveTouches;              ///< Used to keep track of all current touches.
    
    // Pinch and Zoom
    CGSize OriginalDifference;                  ///< Used for calulating the relative difference between two multi-taps for pinch/strech and zoom/unzoom
    
    CGPoint gestureStartPoint;
    BOOL isSwiped;
    float swipeLength;
    float swipeVariance;


    UIView *view;
    
    id<TouchProcessorDelegate> delegate;

}

//set delay for timer in seconds. Default 1.0
@property(nonatomic,assign)float holdDelay;

//set to control the detection of a swipe, default is 30, 20
@property(nonatomic,assign)float swipeLength;
@property(nonatomic,assign)float swipeVariance;


//set to receive notifications for touch events
@property(nonatomic,assign)id<TouchProcessorDelegate> delegate;


//forward all touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


- (void)didReceiveMemoryWarning;


@end
