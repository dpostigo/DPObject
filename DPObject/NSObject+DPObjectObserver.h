//
// Created by Dani Postigo on 2/5/14.
//

#import <Foundation/Foundation.h>

@interface NSObject (DPObjectObserver)

- (void) observeObject: (id) object key: (NSString *) key;
- (void) observeObject: (id) object keys: (NSArray *) keys;
- (void) unobserveObject: (id) object;
@end