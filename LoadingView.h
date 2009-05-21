//
//  LoadingView.h
//  LoadingView
//
//  Created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Use of this file is subject to the MIT-style license in the license.txt
//  file included with the project.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{

    
}

+ (id)loadingViewInView:(UIView *)aSuperview withText:(NSString*)text;
+ (id)loadingViewInView:(UIView *)aSuperview;

- (void)updateText:(NSString *)text;
- (void)stopActivity;
- (void)updateAndCloseWithText:(NSString *)text;
- (void)removeView;


@end
