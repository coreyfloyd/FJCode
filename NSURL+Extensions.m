//
//  NSURL+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 1/10/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import "NSURL+Extensions.h"


@implementation NSURL(Extensions)

+ (id)URLWithStringCanBeNil:(NSString*)URLString{
	
	if(URLString == nil)
		return nil;
	
	return [NSURL URLWithString:URLString];
}

@end