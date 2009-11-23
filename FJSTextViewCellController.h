//
//  FJSTextViewCellController.h
//  FJSCode
//
//  Created by Corey Floyd on 11/10/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFCellController.h"
#import "IFCellModel.h"

@interface FJSTextViewCellController : NSObject <IFCellController, UITextFieldDelegate>{
    
    NSString *label;
	id<IFCellModel> model;
	NSString *key;
	
	NSInvocation* message;
}
@property(nonatomic,retain)NSInvocation *message;

- (id)initWithLabel:(NSString *)newLabel atKey:(NSString *)newKey inModel:(id<IFCellModel>)newModel invocation:(NSInvocation*)invocation;


@end
