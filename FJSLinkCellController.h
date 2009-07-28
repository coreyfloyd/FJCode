//
//  FJSLinkCellController.h
//  GenericTableViews
//
//  Created by Corey Floyd on 7/25/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFLinkCellController.h"


@interface FJSLinkCellController : IFLinkCellController {
    
    NSString *nibFileName;

}
@property(nonatomic,retain)NSString *nibFileName;


@end
