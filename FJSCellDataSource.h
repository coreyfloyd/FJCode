//
//  IFCellModel.h
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/30/09
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FJSCellDataSource <NSObject>

- (void)setObject:(id)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (int)count;


@optional
- (void)removeObjectForKey:(NSString *)key;

@end


@interface FJSCellDataSource : NSObject <FJSCellDataSource>{
    
    NSMutableDictionary *data;
    
}
- (id)initWithData:(NSDictionary*)someData;


@end