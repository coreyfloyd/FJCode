//
//  FJSDatePickerController.h
//  FJSCode
//
//  Created by Corey Floyd on 12/22/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

//
//  UIDatePickerController.h
//  UIDatePickerController
//  Copyright (c) 2009 Alberto García Hierro <fiam@rm-fr.net>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



#import <UIKit/UIKit.h>
@class FJSDatePickerController;

@protocol FJSDatePickerControllerDelegate

@required
- (void)datePickerControllerCancelled:(UIDatePickerController *)picker;
- (void)datePickerControllerSaved:(UIDatePickerController *)picker withDate:(NSDate *)theDate;

@end


@interface FJSDatePickerController : UIViewController <UITableViewDelegate, UITableViewDataSource> {	
	UIDatePicker *_picker;
	UITableViewCell *_cell;
	UITableView *_tableView;
	NSDateFormatter *_formatter;
	id <NSObject, UIDatePickerControllerDelegate> _delegate;
}

@property(nonatomic, readonly) UIDatePicker *picker;
@property(nonatomic, readonly) NSDateFormatter *formatter;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, assign) id <NSObject, FJSDatePickerControllerDelegate> delegate;

@end