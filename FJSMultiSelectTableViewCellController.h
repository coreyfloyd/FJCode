//
//  FJSMultiSelectTableViewCellController.h
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJSTableViewCellController.h"


@interface FJSMultiSelectTableViewCellController : FJSTableViewCellController {

    BOOL selected;
    BOOL customEditingViewEnabled;

}
@property(readonly)BOOL selected;
@property(nonatomic,assign)BOOL customEditingViewEnabled;


- (void)setUpCell;
- (void)refreshCell;
- (void)cellTouched;

@end
