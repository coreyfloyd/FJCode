//
//  UIView-Extensions.h
//  Compounds
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (animation)

- (void)fadeInWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)fadeOutWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)translateToFrame:(CGRect)aFrame delay:(CGFloat)delay duration:(CGFloat)duration;
- (void)shrinkToSize:(CGSize)aSize withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)changeColor:(UIColor *)aColor withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)rotate:(float)degrees;


@end

@interface UIView (introspection)

- (BOOL)hasSubviewOfClass:(Class)aClass;
- (BOOL)hasSubviewOfClass:(Class)aClass thatContainsPoint:(CGPoint)aPoint;
- (UIView*)firstResponder;

@end


@interface UIView (drawing)


// save and restore graphics context
-(void)contextRestore:(CGContextRef)context;
-(CGContextRef)contextSave;

// points
-(void)drawPoint:(CGPoint)point;
-(void)drawPoint:(CGPoint)point color:(UIColor*)color;

// filled rects
-(void)fillRect:(CGRect)rect;
-(void)fillRect:(CGRect)rect color:(UIColor*)color;

// filled rects with rounded corners
-(void)fillRoundRect:(CGRect)rect;
-(void)fillRoundRect:(CGRect)rect color:(UIColor*)color;

// outlined rects
-(void)strokeRect:(CGRect)rect;
-(void)strokeRect:(CGRect)rect color:(UIColor*)color;

// outlined rects with rounded corners
-(void)strokeRoundRect:(CGRect)rect;
-(void)strokeRoundRect:(CGRect)rect color:(UIColor*)color;


//usage:
/*
-(void)drawRect:(CGRect)rect
{
    CGRect  test = CGRectMake(0.0, 0.0, 20.0, 20.0);
    [self strokeRect:test color:[UIColor magentaColor]];
    
    test.origin.x += test.size.width;
    [self strokeRoundRect:test color:[UIColor yellowColor]];
    
    test.origin.x += test.size.width;
    [self fillRect:test color:[UIColor blueColor]];
    
    test.origin.x += test.size.width;
    [self fillRoundRect:test color:[UIColor redColor]];
}
*/


@end


