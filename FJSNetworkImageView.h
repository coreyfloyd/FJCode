//
//  FJSNetworkImageView.h
//  Carousel
//
//  Created by Corey Floyd on 12/28/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJSNetworkImageView : UIView {
	
	UIImageView* imageView;
	UIActivityIndicatorView* activityIndicator;

}
@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;

- (id)initWithImageURL:(NSURL*)url frame:(CGRect)aFrame useCache:(BOOL)flag;
- (void)loadImageAtURL:(NSURL*)url useCache:(BOOL)flag;

@end
