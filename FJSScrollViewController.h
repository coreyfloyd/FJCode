//
//  ImageSelectScrollViewController.h
//  Skinny Jeans
//
//  Created by Corey Floyd on 4/9/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSViewController;
@class FJSScrollView;

@interface FJSScrollViewController : UIViewController <UIScrollViewDelegate> {

	NSArray *data;
    
    FJSScrollView *scrollView;
    NSMutableArray *viewControllers;
    FJSViewController *highlightedViewController;

    UIPageControl *pageController;
    NSInteger currentPage;
	NSInteger lastPage;

}

@property(nonatomic,retain)IBOutlet UIPageControl *pageController;
@property(nonatomic,retain)FJSViewController *highlightedViewController;
@property(nonatomic,retain)NSMutableArray *viewControllers;
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger lastPage;
@property(nonatomic,retain)FJSScrollView *scrollView;


- (id)initWithData:(NSArray*)nameArray;

- (void)highlightCurrentPage;
- (void)dehighlightCurrentPage;
- (void)selectCurrentPage;




@end
