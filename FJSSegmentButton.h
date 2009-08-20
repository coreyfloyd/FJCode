//
//  FJSSegmentButton.h
//  FJSCode
//
//  Created by Corey Floyd on 7/29/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FJSSegmentButton : UIView {
    
    UISegmentedControl* glossyBackground;
    
    UIColor *tintColor;
    NSString *title;
    UIFont *font;
    float fontSize;
    UIColor *fontColor;
}

@property(nonatomic,retain)UISegmentedControl *glossyBackground;
@property(nonatomic,retain)UIColor *tintColor;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic,assign)float fontSize;
@property(nonatomic,retain)UIColor *fontColor;

- (void)addTarget:(id)target action:(SEL)action;
- (void)drawText;


@end