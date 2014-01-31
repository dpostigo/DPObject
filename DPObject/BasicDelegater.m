//
// Created by dpostigo on 8/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicDelegater.h"
#import "NSObject+CallSelector.h"

@implementation BasicDelegater

@synthesize delegates;

- (NSMutableArray *) delegates {
    if (delegates == nil) {
        delegates = [[NSMutableArray alloc] init];
    }
    return delegates;
}

- (BOOL) isDelegate: (id) aDelegate {
    return [self.delegates containsObject: aDelegate];
}

- (void) subscribeDelegate: (id) aDelegate {
    [self.delegates addObject: aDelegate];
}

- (void) unsubscribeDelegate: (id) aDelegate {
    [self.delegates removeObject: aDelegate];
}


- (void) notifyDelegates: (SEL) aSelector object: (id) obj {
    [self notifyDelegates: aSelector object: obj object: nil];
}

- (void) notifyDelegates: (SEL) aSelector object: (id) obj object: (id) obj2 {
    for (id delegate in self.delegates) {
        [self forwardSelector: aSelector delegate: delegate object: obj object: obj2];
    }
}


@end