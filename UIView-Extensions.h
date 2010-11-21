//
//  UIView-Extensions.h
//  Compounds
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>


CGRect rectExpandedByValue(CGRect rect,  float expandRadius);
CGRect rectContractedByValue(CGRect rect,  float expandRadius);


@interface UIView (utility)

- (void)setBackgroundColor:(UIColor*)aColor recursive:(BOOL)flag;

@end


@interface UIView (frame)


// Position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;


-(void)setOrigin:(CGPoint)aPoint;
-(void)setOriginY:(float)value;
-(void)setOriginX:(float)value;
-(void)setSize:(CGSize)aSize;
-(void)setSizeWidth:(float)value;
-(void)setSizeHeight:(float)value;

@end



//returns points relative to bounds
@interface UIView (points)

-(CGPoint)bottomCenter;
-(CGPoint)topCenter;
-(CGPoint)leftCenter;
-(CGPoint)rightCenter;
-(CGPoint)upperRightCorner;
-(CGPoint)upperLeftCorner;
-(CGPoint)lowerLeftCorner;
-(CGPoint)lowerRightCorner;


@end



@interface UIView (animation)

- (void)fadeInWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)fadeOutWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)translateToFrame:(CGRect)aFrame delay:(CGFloat)delay duration:(CGFloat)duration;
- (void)shrinkToSize:(CGSize)aSize withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)changeColor:(UIColor *)aColor withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)rotate:(float)degrees;

- (void)animateAlpha:(float)alphaValue delay:(CGFloat)delay duration:(CGFloat)duration removeFromSuperView:(BOOL)flag;

@end

@interface UIView (introspection)

- (BOOL)hasSubviewOfClass:(Class)aClass;
- (BOOL)hasSubviewOfClass:(Class)aClass thatContainsPoint:(CGPoint)aPoint;
- (UIView*)firstResponder;

@end





struct SCRoundedRect {
	CGFloat xLeft, xLeftCorner;
	CGFloat xRight, xRightCorner;
	CGFloat yTop, yTopCorner;
	CGFloat yBottom, yBottomCorner;
};
typedef struct SCRoundedRect SCRoundedRect;



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


SCRoundedRect SCRoundedRectMake(CGRect, CGFloat);

void SCContextAddRoundedRect(CGContextRef, CGRect, CGFloat);

void SCContextAddLeftRoundedRect(CGContextRef, CGRect, CGFloat);
void SCContextAddLeftTopRoundedRect(CGContextRef, CGRect, CGFloat);
void SCContextAddLeftBottomRoundedRect(CGContextRef, CGRect, CGFloat);

void SCContextAddRightRoundedRect(CGContextRef, CGRect, CGFloat);
void SCContextAddRightTopRoundedRect(CGContextRef, CGRect, CGFloat);
void SCContextAddRightBottomRoundedRect(CGContextRef, CGRect, CGFloat);



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


@interface UIImageView (MFAdditions)

- (void) setImageWithName:(NSString *)name;

@end



