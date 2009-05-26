//
//  ImageScrollView.m
//  Skinny Jeans
//
//  Created by Corey Floyd on 4/10/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJSScrollView.h"


@interface FJSScrollView () 

- (void)enableUserInteraction;

@end



@implementation FJSScrollView


- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    
    isScrolling = NO;
    [super touchesBegan:touches withEvent:event];
    [[self nextResponder] touchesBegan:touches withEvent:event]; 

}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {

    isScrolling = YES;
    [super touchesMoved:touches withEvent:event];
    [[self nextResponder] touchesCancelled:touches withEvent:event]; 

}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {

    if(isScrolling){
        [super touchesEnded:touches withEvent:event];

    } else {
        [[self nextResponder] touchesEnded:touches withEvent:event];
        [self setUserInteractionEnabled:NO];
        [self performSelector:@selector(enableUserInteraction) withObject:nil afterDelay:1.5];

    }
    isScrolling =NO;
}

- (void)enableUserInteraction{
    
    [self setUserInteractionEnabled:YES];

}
@end
