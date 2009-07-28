//
//  IFTextCellController.h
//  Thunderbird
//
//	Created by Craig Hockenberry on 1/29/09.
//	Copyright 2009 The Iconfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IFCellController.h"
#import "IFCellModel.h"

@interface IFTextCellController : NSObject <IFCellController, UITextFieldDelegate>
{
	NSString *label;
	NSString *placeholder;
	id<IFCellModel> model;
	NSString *key;
	
	SEL updateAction;
	id updateTarget;
    
    SEL beginEditingAction;
	id beginEditingTarget;
    
	UIKeyboardType keyboardType;
    UIReturnKeyType returnKey;
	UITextAutocapitalizationType autocapitalizationType;
	UITextAutocorrectionType autocorrectionType;
    BOOL adjustsFontSizeToWidth;
	BOOL secureTextEntry;
	NSInteger indentationLevel;
    float fontSize;

}

@property (nonatomic, assign) SEL updateAction;
@property (nonatomic, assign) id updateTarget;
@property(nonatomic,assign)SEL beginEditingAction;
@property(nonatomic,assign)id beginEditingTarget;


@property (nonatomic, assign) UIKeyboardType keyboardType;
@property(nonatomic,assign)UIReturnKeyType returnKey;
@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign) UITextAutocorrectionType autocorrectionType;
@property(nonatomic,assign)BOOL adjustsFontSizeToWidth;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) NSInteger indentationLevel;
@property(nonatomic,assign)float fontSize;


- (id)initWithLabel:(NSString *)newLabel andPlaceholder:(NSString *)newPlaceholder atKey:(NSString *)newKey inModel:(id<IFCellModel>)newModel;

@end
