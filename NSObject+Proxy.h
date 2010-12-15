//
//  NSObject+Proxy.h
//  
//
//  Created by Corey Floyd.
//  Borrowed From Steve Degutis and Peter Hosey, with a splash of me
//

#import <UIKit/UIKit.h>


@protocol FJNSObjectProxy

- (id)nextRunloopProxy;
- (id)proxyWithDelay:(float)time;
- (id)performOnMainThreadProxy;
- (id)performIfRespondsToSelectorProxy;

@end

@interface NSObject(Proxy) <FJNSObjectProxy> 

- (id)nextRunloopProxy;
- (id)proxyWithDelay:(float)time;
- (id)performOnMainThreadProxy;
- (id)performIfRespondsToSelectorProxy;

@end

