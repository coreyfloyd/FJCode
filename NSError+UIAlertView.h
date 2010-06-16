//
//  NSError+UIAlertView.h
//  Carousel
//
//  Created by Corey Floyd on 12/29/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSError(UIAlertView)

- (void)presentInAlertView;
- (void)presentInAlertViewWithDelegate:(id)delegate;

@end
