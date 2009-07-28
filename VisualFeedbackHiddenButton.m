//
//  VisualFeedbackHiddenButton.m
//  CMN2
//
//  Created by David Martorana on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "VisualFeedbackHiddenButton.h"


@implementation VisualFeedbackHiddenButton


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // We'll only draw if there is a touch down
    if (isTouchDown) {
        UIColor* color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [color setFill];
        UIRectFill(rect);
    }
    
    [super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchDown = YES;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchDown = NO;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    [super dealloc];
}


@end
