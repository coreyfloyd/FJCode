#import <UIKit/UIKit.h>


@interface UIButton (Glossy)

+ (UIButton*)shinyButtonWithWidth:(NSUInteger)width height:(NSUInteger)height color:(UIColor*)color;

+ (void)setPathToRoundedRect:(CGRect)rect forInset:(NSUInteger)inset inContext:(CGContextRef)context;
+ (void)drawGlossyRect:(CGRect)rect withColor:(UIColor*)color inContext:(CGContextRef)context;


- (void)setBackgroundToGlossyRectOfColor:(UIColor*)color withBorder:(BOOL)border forState:(UIControlState)state;
- (void)setRecessedTitle:(NSString*)title color:(UIColor*)color forControlState:(UIControlState)state;

@end

