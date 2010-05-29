//
//  NSString+blocks.h
//  blocks
//
//  Created by Robin Lu on 9/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (BlockExtension)
- (void)each:(void (^)(id))block;
- (NSArray* )select:(BOOL (^)(id))block;
- (NSArray *)map:(id (^)(id))block;
- (id)reduce:(id)initial withBlock:(id (^)(id,id))block;
@end
