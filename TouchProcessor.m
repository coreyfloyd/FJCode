//
//  TouchProcessor.m
//  iBalloon
//
//  Created by Corey Floyd on 7/10/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "TouchProcessor.h"

#define kTouchUpdateTimer (1.0/5.0)

#define kMinimumGestureLength       30 
#define kMaximumVariance            20 


@interface TouchProcessor()

- (void)cleanupTimers;

@end


@implementation TouchProcessor

@synthesize holdDelay;
@synthesize swipeLength;
@synthesize swipeVariance;
@synthesize delegate;

/*********************************************************************/
#pragma mark -
#pragma mark ** Methods **

- (void)dealloc {
    [TouchHoldTimer invalidate];
    TouchHoldTimer = nil;
    [FirstTouchTime release];
    [DoubleTapTime release];
    [ActiveTouches release];
    [super dealloc];
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Utilities **

CGSize CGSizeDistanceBetween2Points(CGPoint point1, CGPoint point2)
{
    return CGSizeMake(point1.x -point2.x, point1.y - point2.y);
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Touch Utility Methods **

- (void)touchIsBeingPinchedOrStretched:(NSSet *)touches;
{
    
    UIView *theView = [[ActiveTouches objectAtIndex:0] view];
    // calculate the distance between the two touches    
    CGSize difference = CGSizeDistanceBetween2Points([[ActiveTouches objectAtIndex:0] locationInView:theView], 
                                                     [[ActiveTouches objectAtIndex:1] locationInView:theView]);    
    
    CGFloat x_scale_factor = difference.width/OriginalDifference.width;
    CGFloat y_scale_factor = difference.height/OriginalDifference.height;
    //NSLog(@"Scale Factor: %x:f, y:%f", x_scale_factor, y_scale_factor);
    
    if([delegate respondsToSelector:@selector(wasScaledByXFactor:yFactor:)])
        [delegate wasScaledByXFactor:x_scale_factor yFactor:y_scale_factor];
    
    CGFloat scaleFactor = sqrt(pow(x_scale_factor, 2) + pow(y_scale_factor, 2));
    
    if([delegate respondsToSelector:@selector(wasScaledByFactor:)])
        [delegate wasScaledByFactor:scaleFactor];

    
}

- (void)touchIsBeingHeldWithTimer:(NSTimer *)timer;
{
    if(holdDelay<=0)
        holdDelay=1;
    
    NSSet *touches = [timer userInfo];
    NSInteger count = [[touches anyObject] tapCount];
    NSTimeInterval hold_time = -1*[FirstTouchTime timeIntervalSinceNow];
    
    if (count == 1) {
        //tap and hold logic
        
        if(TouchAndHoldCounter < 1){
            if([delegate respondsToSelector:@selector(wasTappedandHeld)])
                [delegate wasTappedandHeld];
        }
        
        TouchAndHoldCounter += 1;
        
        //NSLog(@"Held for %d counts and %g seconds.", TouchAndHoldCounter, hold_time);
        if (hold_time > holdDelay){
            
            //cancelled
            [self cleanupTimers];
            
            //tap and hold delay logic
            if([delegate respondsToSelector:@selector(wasTappedandHeldForDuration:)])
                [delegate wasTappedandHeldForDuration:holdDelay];
            
        }
        
    }
    else if (count == 2) {
        
        if(DoubleTapAndHoldCounter < 1){
            if([delegate respondsToSelector:@selector(wasTappedandHeldForDuration:)])
                [delegate wasDoubleTappedAndHeld];   
        }
        
        DoubleTapAndHoldCounter += 1;
        
        //NSLog(@"Held for %d counts and %g seconds.", DoubleTapAndHoldCounter, -1*[DoubleTapTime timeIntervalSinceNow]);
    }
}
- (void)cleanupTimers;
{
    [TouchHoldTimer invalidate];
    TouchHoldTimer = nil;
    [FirstTouchTime release];
    FirstTouchTime = nil;
    [DoubleTapTime release];
    DoubleTapTime = nil;
}

/*********************************************************************/
#pragma mark -
#pragma mark ** Touch Handlers **

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    METHOD_LOG;
    OBJECT_LOG(touches);
    
    // NSSet *touches is the set of touches that began now.  We want to 
    // keep track of ALL touches, including touches that may have began 
    // sometime ago.  We have our own NSMutableArray* ActiveTouches to 
    // do so.
    
    if (ActiveTouches == nil)
        ActiveTouches = [[NSMutableArray alloc] init];
    
    for (UITouch *touch in touches) {
        if (![ActiveTouches containsObject:touch])
            [ActiveTouches addObject:touch];
    }
    
    UITouch *touch = [touches anyObject];
    UIView *theView = [touch view];
    gestureStartPoint = [touch locationInView:theView];
    strokePoint = gestureStartPoint;
    
    
    if([delegate respondsToSelector:@selector(touchLocationDidMoveTo:)])
        [delegate touchLocationDidMoveTo:gestureStartPoint];

    
    
    if ([ActiveTouches count] == 1) { //single finger touch
        
        touchPath = [[NSMutableArray alloc] init];
        [touchPath addObject:[NSValue valueWithCGPoint:gestureStartPoint]];
        
        //Start touch timer
        FirstTouchTime = [[NSDate alloc] init];
        TouchHoldTimer = [NSTimer scheduledTimerWithTimeInterval:kTouchUpdateTimer
                                                          target:self
                                                        selector:@selector(touchIsBeingHeldWithTimer:) 
                                                        userInfo:touches
                                                         repeats:YES];
        
        if ([[touches anyObject] tapCount] == 2){
            DoubleTapTime = [[NSDate alloc] init];
            
        }
        
    } else if ([ActiveTouches count] == 2) { //two finger touch
        
        UIView *theView = [[ActiveTouches objectAtIndex:0] view];
        
        OriginalDifference = CGSizeDistanceBetween2Points([[ActiveTouches objectAtIndex:0] locationInView:theView], 
                                                          [[ActiveTouches objectAtIndex:1] locationInView:theView]);    
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if ([ActiveTouches count] == 1) { //single touch
        
        UITouch *touch = [touches anyObject]; 
        UIView *theView = [touch view];
        CGPoint currentPosition = [touch locationInView:theView];         
        
        if([delegate respondsToSelector:@selector(touchLocationDidMoveTo:)])
            [delegate touchLocationDidMoveTo:currentPosition];
        
        [touchPath addObject:[NSValue valueWithCGPoint:currentPosition]];
        
               
        if(swipeLength == 0)
            self.swipeLength = kMinimumGestureLength;
        if(swipeVariance == 0)
            self.swipeVariance = kMaximumVariance;
                
        if(!isSwiped){
            
            CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x); 
            CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);             
            
            if (deltaX >= swipeLength && deltaY <= swipeVariance) { 
                //horizontal swipe detected
                isSwiped=YES;
                [self cleanupTimers];
                
                
                if([delegate respondsToSelector:@selector(wasSwipedHorizontally)])
                    [delegate wasSwipedHorizontally];
                
            } 
            else if (deltaY >= swipeLength && 
                     deltaX <= swipeVariance){ 
                //vertical swipe detected
                isSwiped=YES;
                [self cleanupTimers];
                
                
                if([delegate respondsToSelector:@selector(wasSwipedVertically)])
                    [delegate wasSwipedVertically];
            } 
            
        }
        
        CGSize difference = CGSizeDistanceBetween2Points(strokePoint, currentPosition); 
        CGFloat strokeDelta = sqrt(pow(difference.width, 2) + pow(difference.height, 2));
        
        float direction = atan2(difference.height, -difference.width);
        direction += M_PI / 2.0;
        
        //NSLog([NSString stringWithFormat:@"direction: %f", direction]);
        //NSLog([NSString stringWithFormat:@"stroke length: %f", strokeDelta]);
        
        
        
        if((strokeDelta >= swipeLength) && 
           ((fabsf((lastStrokeDirection - direction))>(M_PI/2.0)) || (strokes==0))){
            
            strokes++;
            
            if([delegate respondsToSelector:@selector(wasStroked:)])
                [delegate wasStroked:strokes];
            
            lastStrokeDirection = direction;
            strokePoint = currentPosition;
        }
        
        
        //TODO: decide whether to return a release even if the touch moved
        //for now we do not
        //cancelling timers setting counters to 0
        [self cleanupTimers];
        TouchAndHoldCounter = 0;
        DoubleTapAndHoldCounter = 0;
        
        // do nothing
    } else if ([ActiveTouches count] == 2) { //two finger touch
        [self cleanupTimers];
        [self touchIsBeingPinchedOrStretched:touches];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    METHOD_LOG;
    OBJECT_LOG(touches);
    for (UITouch *touch in touches) {
        [ActiveTouches removeObject:touch];
    }
    [self cleanupTimers];
    
    if ([touches count] == 1) { //single touch
        
        if([[touches anyObject] tapCount]>0){
            
            if([delegate respondsToSelector:@selector(wasTappedWithCount:)])
                [delegate wasTappedWithCount:[[touches anyObject] tapCount]];
            
        }
        
        if(!isSwiped){
            
            if(TouchAndHoldCounter > 0 || DoubleTapAndHoldCounter > 0){
                
                if([delegate respondsToSelector:@selector(tapHoldWasReleased)])
                    [delegate tapHoldWasReleased];
            }
            
            TouchAndHoldCounter = 0;
        }
        
        DoubleTapAndHoldCounter = 0;
        
        if([touchPath count]>1){
            if([delegate respondsToSelector:@selector(pathOfTouch:)])
                [delegate pathOfTouch:[touchPath autorelease]];            
        } else {
            [touchPath release];
        }

                       
        
        
        // do nothing
    } else if ([touches count] == 2) { //two finger touch
        //
    } 
    
    isSwiped=NO;
    strokes=0;
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    METHOD_LOG;
    [self cleanupTimers];
    [ActiveTouches removeAllObjects];
}


@end
