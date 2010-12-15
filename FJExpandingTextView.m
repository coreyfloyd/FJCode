

#import "FJExpandingTextView.h"

static NSString* const kTapText = @"… [Tap To Expand]";

@implementation FJExpandingTextView

@synthesize textView;
@synthesize text;
@synthesize originalFrame;
@synthesize numberOfVisibleLines;
@synthesize labelText;
@synthesize maxHeight;





- (void)dealloc {
   
    [textView release];
    textView = nil;
    [text release];
    text = nil;
    [labelText release];
    labelText = nil;
    [super dealloc];
}


- (void)_initVars{
    
    self.originalFrame = self.frame;
    self.maxHeight = FLT_MAX;
    
    UITextView* tv = [[UITextView alloc] initWithFrame:self.bounds];
    tv.editable = NO;
    tv.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:tv];
    
    self.textView = tv;
    [tv release];
    
    UITapGestureRecognizer* g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toggle)];
    [self addGestureRecognizer:g];
    [g release];
    
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initVars];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _initVars];
    }
    return self;
}


- (void)setText:(NSString *)aText
{
    if (text != aText) {
        [text release];
        text = [aText copy];
        
        [self update];
    }
}

- (void)update{
    
    
    //UIFont* font = self.textView.font;
    //UITextAlignment a = self.label.textAlignment;
    //CGFloat lineHeight = f.lineHeight;
            
    NSMutableString *resultString = [[self.text mutableCopy] autorelease];
    
    self.textView.text = resultString;
    //CGSize contentSize = self.textView.contentSize;
    
    if(self.textView.contentSize.height <= self.bounds.size.height){
        
        return;

    }
    
    
    NSString* resultStringWithTruncateText = nil;
    float truncatedHeight = self.textView.contentSize.height;
    NSRange range = {resultString.length-1, 1};

    while(truncatedHeight > self.bounds.size.height){
        
        [resultString deleteCharactersInRange:range];
        range.location--;
        
        resultStringWithTruncateText = [resultString stringByAppendingString:kTapText];
        
        self.textView.text = resultStringWithTruncateText;
        CGSize contentSize = self.textView.contentSize;
        truncatedHeight = contentSize.height;

    }
    
    self.textView.text = resultStringWithTruncateText;
    
}

- (void)_calculateVisibleLines{
    
    UIFont* f = self.textView.font;
    CGFloat lineHeight = f.lineHeight;
    
    NSUInteger lines = floor(self.frame.size.height/lineHeight);
    self.numberOfVisibleLines = lines;
    
    NSLog(@"Number of lines in label: %i", lines);

}


- (NSString*)_stringByTruncatingString:(NSString*)string appendingTruncationString:(NSString*)truncationString withFont:(UIFont *)font forSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode {
    
    CGSize unlimitedHeight;
    unlimitedHeight.width = size.width;
    unlimitedHeight.height = FLT_MAX;
    NSMutableString *resultString = [[string mutableCopy] autorelease];
    
    if([resultString sizeWithFont:font constrainedToSize:unlimitedHeight lineBreakMode:lineBreakMode].height < size.height){
        
        return resultString;
    }
    
    NSString* resultStringWithTruncateText = nil;
    
    NSRange range = {resultString.length-1, 1};
    
    CGFloat h = size.height;// - self.textView.font.pointSize;
    
    do {
        
        // delete the last character
        [resultString deleteCharactersInRange:range];
        range.location--;
        
        resultStringWithTruncateText = [resultString stringByAppendingString:truncationString];
        
    } while ([resultStringWithTruncateText sizeWithFont:font constrainedToSize:unlimitedHeight lineBreakMode:lineBreakMode].height > h);
    
    
    return resultStringWithTruncateText;
}

/*
- (NSString*)_stringByTruncatingString:(NSString*)string appendingTruncationString:(NSString*)truncationString withFont:(UIFont *)font forSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode {
    
    CGSize unlimitedHeight;
    unlimitedHeight.width = size.width;
    unlimitedHeight.height = FLT_MAX;
    NSMutableString *resultString = [[string mutableCopy] autorelease];
    
    if([resultString sizeWithFont:font constrainedToSize:unlimitedHeight lineBreakMode:lineBreakMode].height < size.height){
        
        return resultString;
    }
    
    NSString* resultStringWithTruncateText = nil;

    NSRange range = {resultString.length-1, 1};
    
    CGFloat h = size.height;// - self.textView.font.pointSize;
    
    do {
        
        // delete the last character
        [resultString deleteCharactersInRange:range];
        range.location--;

        resultStringWithTruncateText = [resultString stringByAppendingString:truncationString];
        
    } while ([resultStringWithTruncateText sizeWithFont:font constrainedToSize:unlimitedHeight lineBreakMode:lineBreakMode].height > h);
    
    
    return resultStringWithTruncateText;
}
*/

- (void)_toggle{
    
    if(![self.textView.text isEqualToString:self.text]){
        
        self.textView.text = self.text;
        CGSize contentSize = self.textView.contentSize;
        
        if(contentSize.height < self.bounds.size.height){
            
            contentSize.height = self.bounds.size.height;
        }
        
        if(contentSize.height > self.maxHeight){
            
            contentSize.height = self.maxHeight;
            
        }
        
        
        CGRect f;
        f.origin = self.frame.origin;
        f.size.height = contentSize.height;
        f.size.width = self.bounds.size.width;
        
        [UIView beginAnimations:@"expand" context:nil];
        self.frame = f;
        [UIView commitAnimations];
        
        
    }else{
        
        [UIView beginAnimations:@"shrink" context:nil];
        self.frame = originalFrame;
        [self update];
        [UIView commitAnimations];

    }
}



@end
