//
//  FJSNetworkedTableViewController.h
//  FJSCode
//
//  Created by Corey Floyd on 5/27/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJSGenericTableViewController.h"
#import "FJSNetworkedCellDataSource.h"


@interface FJSNetworkedTableViewController : FJSGenericTableViewController <FJSNetworkedCellDataSourceDelegate>{

    id<FJSNetworkedCellDataSource> delegate;
    
}

@end
