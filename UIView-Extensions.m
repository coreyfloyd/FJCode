//
//  UIView-Extensions.m
//  Compounds
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "UIView-Extensions.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation UIView (Extensions)


- (void)fadeInWithDelay:(CGFloat)delay duration:(CGFloat)duration{
    
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];
	self.alpha=1;
	[UIView commitAnimations];		
	
	
}

- (void)fadeOutWithDelay:(CGFloat)delay duration:(CGFloat)duration{
	
	[UIView beginAnimations:@"fadeOut" context:nil];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];
	self.alpha=0;
	[UIView commitAnimations];
	
}

- (void)slideToFrame:(CGRect)aFrame delay:(CGFloat)delay duration:(CGFloat)duration{
	
	[UIView beginAnimations:@"slide" context:nil];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	self.frame=aFrame;
	[UIView commitAnimations];
	
}	

-(void)shrinkToSize:(CGSize)aSize withDelay:(CGFloat)delay duration:(CGFloat)duration{
	
	CGRect myNewFrame= self.frame;
	myNewFrame.size=aSize;	
	myNewFrame.origin=CGPointMake(self.frame.origin.x+self.frame.size.width/2-myNewFrame.size.width/2,self.frame.origin.y+self.frame.size.height/2-myNewFrame.size.height/2);
	
	[UIView beginAnimations:@"shrink" context:nil];
	[UIView setAnimationDuration:.5];	
	self.frame=myNewFrame;
	[UIView commitAnimations];	
	
}


- (void)changeColor:(UIColor *)aColor withDelay:(CGFloat)delay duration:(CGFloat)duration{
	
	[UIView beginAnimations:@"changeColor" context:nil];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];	
	[self setBackgroundColor:[UIColor lightGrayColor]];
	[UIView commitAnimations];
	
}

- (void)rotate:(float)degrees{
	
	CGAffineTransform rotateTransform = self.transform;
	rotateTransform = CGAffineTransformRotate(rotateTransform, degreesToRadians(degrees));
	self.transform = rotateTransform;
    
}

- (BOOL)hasSubviewOfClass:(Class)aClass{
    
    BOOL containsClass = NO;
    for(UIView *aSubview in self.subviews){
        NSLog([[aSubview class] description]);
        if([aSubview isKindOfClass:aClass]){
            containsClass = YES;
            break;
        } else {
            containsClass = [aSubview hasSubviewOfClass:aClass];
            if(containsClass)
                break;
        }
    }
    return containsClass;
}

- (BOOL)hasSubviewOfClass:(Class)aClass thatContainsPoint:(CGPoint)aPoint{
    
    BOOL touchIsInClass = NO;
    
    for(UIView *subview in self.subviews){
        
        CGPoint convertedPoint = [subview convertPoint:aPoint fromView:[self superview]];
        NSLog([[subview class] description]);
        if(CGRectContainsPoint(subview.frame, convertedPoint)){
            if([subview isKindOfClass:aClass]){
                touchIsInClass = YES;
                break;
            } else {
                touchIsInClass = [subview hasSubviewOfClass:aClass thatContainsPoint:convertedPoint];
                if(touchIsInClass)
                    break;
                
            }
        }
    }
    
    return touchIsInClass;
}


- (UIView*)firstResponder{
    
    UIView *theFirstResponder = nil;
    
    for(UIView *aSubview in self.subviews){
        
        if([aSubview isFirstResponder]){
            theFirstResponder = aSubview;
            break;
        } else{
            if(theFirstResponder = [aSubview firstResponder])
                break;
        }
    }
    
    //if(!theFirstResponder)
        //NSLog(@"responder not found");
    return theFirstResponder;
    
}




@end
