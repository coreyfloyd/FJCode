//
//  ImageViewController.h
//  Skinny Jeans
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FJSImageViewController : UIViewController {
	
	UIImage *image;

}
@property(nonatomic,retain)UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (void)setImageWithImageNamed:(NSString *)anImageName;
- (id)initWithImageNamed:(NSString *)anImageName;


@end
