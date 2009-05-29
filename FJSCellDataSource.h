//
//  IFCellModel.h
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/30/09
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FJSCellDataSource <NSObject>

@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSDate *timeOfLastUpdate;

- (void)setObject:(id)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (int)count;


@optional
- (void)removeObjectForKey:(NSString *)key;

@end
