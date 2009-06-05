//
//  DummyClass.h
//  HSS
//
//  Created by Corey Floyd on 6/5/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DummyClass : NSObject {
    
    NSArray *dummyArray;
    NSDictionary *dummyDictionary;

}
@property(nonatomic,retain)NSArray *dummyArray;
@property(nonatomic,retain)NSDictionary *dummyDictionary;


@end
