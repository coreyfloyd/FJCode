//
//  NSURL+Extensions.h
//  FJSCode
//
//  Created by Corey Floyd on 1/10/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL(Extensions)

//returns nil if URLString is nil
+ (id)URLWithStringCanBeNil:(NSString*)URLString;



/*
 * Returns a string of the base of the URL, will contain a trailing slash
 *
 * Example:
 * NSURL is http://www.cnn.com/full/path?query=string&key=value
 * baseString will return: http://www.cnn.com/
 */
- (NSString*)baseString;
@end
