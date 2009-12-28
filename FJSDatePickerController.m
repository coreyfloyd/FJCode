
//  UIDatePickerController.m
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

#import "FJSDatePickerController.h"
#import <QuartzCore/QuartzCore.h>


@implementation FJSDatePickerController

@synthesize picker = _picker;
@synthesize formatter = _formatter;
@synthesize delegate = _delegate;

- (id)init {
    if (self = [super init]) {
		_picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
		[_picker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_formatter = [NSDateFormatter new];
		
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	
    return self;
}

#pragma mark properties

- (NSDate *)date {
	return _picker.date;
}

- (void)setDate:(NSDate *)theDate {
	_picker.date = theDate;
}

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[self.view addSubview:_picker];
	[self.view addSubview:_tableView];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	CGFloat pickerYOrigin = CGRectGetMaxY(self.view.layer.visibleRect) - CGRectGetHeight(_picker.frame);
	_picker.frame = CGRectMake(0, pickerYOrigin, CGRectGetWidth(_picker.frame), CGRectGetHeight(_picker.frame));
	
	CGFloat viewYOrigin = CGRectGetMinX(self.view.bounds);
	CGFloat tableHeight = 65;
	CGFloat tableYOrigin = viewYOrigin + (pickerYOrigin - viewYOrigin - tableHeight) / 2;
	_tableView.frame = CGRectMake(0, tableYOrigin, CGRectGetWidth(self.view.frame), tableHeight);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (_cell == nil) {
        _cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        _cell.font = [UIFont systemFontOfSize:17.0];
        _cell.textColor = [UIColor colorWithRed:62/255.0 green:78/255.0 blue:111/255.0 alpha:1.0];
		_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    _cell.text = [_formatter stringFromDate:_picker.date];
	
	return _cell;
}

- (void)dealloc {
	[_picker release];
	[_tableView release];
	[_formatter release];
    [super dealloc];
}

- (void)save {
	[_delegate datePickerControllerSaved:self withDate:_picker.date];
}

- (void)cancel {
	[_delegate datePickerControllerCancelled:self];
}

- (void)dateDidChange:(UIDatePicker *)picker {
	_cell.text = [_formatter stringFromDate:picker.date];
}

@end
