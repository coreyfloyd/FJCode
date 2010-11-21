//  --------------------------------------------
//  The MIT License
//  
//  Copyright 2009 Appcorn AB.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  --------------------------------------------
//
//  ACActivityIndicatorQueue.h
//
//  Created by Martin Alléus on 2009-04-19.
//  Copyright 2009 Appcorn AB.
//
//	Class description:
//	--------------------------------------------
//	This class counts a queue of senders that wants to display the
//	activity indicator in the iPhone top bar. When the queue increases
//	from 0, the activity indicator is shown. It's not hidden until
//	the queue decreases to 0 again.
//	
//	Varible description:
//	--------------------------------------------
//	application:	The shared application from UIApplication
//	indicatorQueue:	The integer keeping the current length of queue
//	

#import <Foundation/Foundation.h>


@interface ACActivityIndicatorQueue : NSObject {
	UIApplication *application;
	int indicatorQueue;
}


# pragma mark --- Singleton methods ---

/* Singelton method to access the static, shared instance of the class */

+ (ACActivityIndicatorQueue *)sharedInstance;


# pragma mark --- Static convinience-methods ---

/* Convinience-method to increase the queue.
   See - addToIndicatorQueue for more information */

+ (void)startActivity;

/* Convinience-method to decrease the queue.
   See - addToIndicatorQueue for more information */

+ (void)endActivity;


# pragma mark --- Custom methods ---

/* Show the activity indicator if needed and increase the queue with one */

- (void)addToIndicatorQueue;

/* Decrease the queue with one and hide the activity indicator if needed */

- (void)removeFromIndicatorQueue;

@end
