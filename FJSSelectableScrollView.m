//
//  ImageScrollView.m
//  Skinny Jeans
//
//  Created by Corey Floyd on 4/10/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJSSelectableScrollView.h"


@interface FJSSelectableScrollView () 

- (void)enableUserInteraction;

@end



@implementation FJSSelectableScrollView

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {

    if (1 == [touches count] && 1 == [[touches anyObject] tapCount]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewTapped" object:self];

        //process tap to bring up nav bar    
    }
}
 

- (void)enableUserInteraction{
    
    [self setUserInteractionEnabled:YES];

}
@end
