//
//  ImageSelectScrollViewController.h
//  Skinny Jeans
//
//  Created by Corey Floyd on 4/9/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSViewController;

@interface FJSScrollViewController : UIViewController <UIScrollViewDelegate> {

	NSArray *data;
    
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    FJSViewController *highlightedViewController;

    NSInteger currentPage;
	NSInteger lastPage;
    
    CGSize pageSize;

}


//viewcontrollers will recieve data[index] to populate them whenever data changes (KVO)
//should be subclass of FJSViewController
@property(nonatomic,retain)NSMutableArray *viewControllers;

//change will automatically propagate to viewControllers
//elements should be NSDictionaries
@property(nonatomic,retain)NSArray *data;

//page size used for all size calculations
//if not set, then the default 416x320 is used
@property(nonatomic,assign)CGSize pageSize;

//index of current view
@property(nonatomic,assign)NSInteger currentPage;

//index of previous view
@property(nonatomic,assign)NSInteger lastPage;


@property(nonatomic,retain)FJSViewController *highlightedViewController;
@property(nonatomic,retain)UIScrollView *scrollView;

//overide this method to create the array of empty viewcontrollers
//by default this viewControllers.count = 0;
- (void)createViewControllers;


- (void)highlightCurrentPage;
- (void)dehighlightCurrentPage;
- (void)selectCurrentPage;

//call to reconfigure scrollView if it is dirty
- (void)setViewFrames;



@end
