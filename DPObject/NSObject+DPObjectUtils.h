//
// Created by Dani Postigo on 2/5/14.
//

#import <Foundation/Foundation.h>

@interface NSObject (DPObjectUtils)

+ (SEL) selectorWithKey: (NSString *) key changeKind: (NSKeyValueChange) kind isPrior: (BOOL) isPriorNotification;
@end