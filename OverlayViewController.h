//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import <UIKit/UIKit.h>

@protocol OverlayViewControllerDelegate <NSObject>

- (void)quitSearching;

@end




@interface OverlayViewController : UIViewController {

	id <OverlayViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id delegate;

@end
