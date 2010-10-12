//
//  UIAlertViewHelper.h
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/16/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Convenience method to throw a quick alert to the user
 * Runs LocalizedString() on all strings
 */
void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle);

@interface UIAlertView (Helper)

+ (id)presentAlertViewWithTitle:(NSString*)aTitle message:(NSString*)aMessage delegate:(id)object;
+ (id)presentAlertViewWithTitle:(NSString*)aTitle message:(NSString*)aMessage delegate:(id)object otherButtonTitle:(NSString *)otherButtonTitle;

//Specific Alerts
+ (id)presentNoInternetAlertWithDelegate:(id)object;

+ (id)presentIncorrectPasswordAlertWithDelegate:(id)object;

+ (id)presentDialogForMissingField:(NSString*)fieldName;

+ (id)presentDialogForWifiUnreachabilityWithDelegate:(id)object;

+ (id)presentDialogForWifiRecheckWithDelegate:(id)object;




@end
