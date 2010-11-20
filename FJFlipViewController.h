

#import <UIKit/UIKit.h>

@protocol FJSubControllerDelegate <NSObject>

- (void)openDetailViewWithObject:(id )anObject animated:(BOOL)flag;

@end

@protocol FJSubController <NSObject>

- (void)reload;

@end



@interface FJFlipViewCoontroller : UIViewController <FJSubControllerDelegate> {

}
@property (nonatomic, retain) id<FJSubController> frontController;
@property (nonatomic, retain) id<FJSubController> backController;
@property (nonatomic, retain) IBOutlet UIToolbar *switchBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *viewSwitch;
@property (nonatomic, retain) IBOutlet UIView *backingView;


- (IBAction)toggleViews:(id)sender;

- (void)showBack;
- (void)showBackAnimated:(BOOL)animated;

- (void)showFront;
- (void)showFrontAnimated:(BOOL)animated;


@end

