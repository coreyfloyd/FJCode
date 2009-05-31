//
//  UIView-Extensions.h
//  Compounds
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

- (void)fadeInWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)fadeOutWithDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)translateToFrame:(CGRect)aFrame delay:(CGFloat)delay duration:(CGFloat)duration;
- (void)shrinkToSize:(CGSize)aSize withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)changeColor:(UIColor *)aColor withDelay:(CGFloat)delay duration:(CGFloat)duration;
- (void)rotate:(float)degrees;
- (BOOL)hasSubviewOfClass:(Class)aClass;
- (BOOL)hasSubviewOfClass:(Class)aClass thatContainsPoint:(CGPoint)aPoint;
- (UIView*)firstResponder;


@end
