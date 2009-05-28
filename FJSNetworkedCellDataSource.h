//
//  FJSNetworkedDataSourceDelegate.h
//  FJSCode
//
//  Created by Corey Floyd on 5/27/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSCellDataSource.h"

@protocol FJSNetworkedCellDataSourceDelegate

- (void)didReceiveNewData:(id<FJSCellDataSource>)newData;

@end



@protocol FJSNetworkedCellDataSource <FJSCellDataSource>

@property(nonatomic, assign)id<FJSNetworkedCellDataSourceDelegate> delegate;

- (void)updateData;


@end


@interface FJSNetworkedCellDataSource : NSObject <FJSNetworkedCellDataSource>{
    
    
    id<FJSNetworkedCellDataSourceDelegate> delegate;
    NSMutableDictionary *data;
    
}

@end


