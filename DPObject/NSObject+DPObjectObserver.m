//
// Created by Dani Postigo on 2/5/14.
//

#import "NSObject+DPObjectObserver.h"
#import "DPObjectObserver.h"

@implementation NSObject (DPObjectObserver)

- (void) observeObject: (id) object key: (NSString *) key {
    [self observeObject: object keys: @[key]];
}

- (void) observeObject: (id) object keys: (NSArray *) keys {
    [[DPObjectObserver observer] subscribeDelegate: self];
    [[DPObjectObserver observer] addObject: object keys: keys];
}


- (void) unobserveObject: (id) object {
    [[DPObjectObserver observer] removeObject: object];
}


@end