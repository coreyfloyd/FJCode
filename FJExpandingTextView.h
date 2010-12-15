

#import <UIKit/UIKit.h>


@interface FJExpandingTextView : UIView {

    UITextView* textView;
    NSString* text;
    CGFloat maxHeight;
    
    CGRect originalFrame;
    NSUInteger numberOfVisibleLines;
    NSString* labelText;

}
@property (nonatomic, copy) NSString *text; 
@property (nonatomic) CGFloat maxHeight;

- (void)update; //call to refesh label if needed (i.e you set label properties after setting the text property)





//private
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) NSUInteger numberOfVisibleLines;
@property (nonatomic, copy) NSString *labelText;

- (NSString*)_stringByTruncatingString:(NSString*)string appendingTruncationString:(NSString*)truncationString withFont:(UIFont *)font forSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode;
- (void)_calculateVisibleLines;


@end
