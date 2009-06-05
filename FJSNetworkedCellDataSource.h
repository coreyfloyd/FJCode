//
//  FJSNetworkedDataSourceDelegate.h
//  FJSCode
//
//  Created by Corey Floyd on 5/27/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSCellDataSource.h"

@protocol FJSNetworkedCellDataSourceDelegate <NSObject>

@optional
- (void)didUpdateData:(BOOL)isUpdated withError:(NSError*)error;

@end



@protocol FJSNetworkedCellDataSource <FJSCellDataSource>

@property(nonatomic, assign)id<FJSNetworkedCellDataSourceDelegate> delegate;

- (void)updateData;


@end


@interface FJSNetworkedCellDataSource : NSObject <FJSNetworkedCellDataSource>{
    
    
    id<FJSNetworkedCellDataSourceDelegate> delegate;
    NSMutableDictionary *data;
    NSDate *timeOfLastUpdate;
    
}

@end


