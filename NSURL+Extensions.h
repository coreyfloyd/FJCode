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

@end
