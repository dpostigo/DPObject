//
// Created by Dani Postigo on 2/5/14.
//

#import "NSObject+DPObjectUtils.h"

@implementation NSObject (DPObjectUtils)

+ (SEL) selectorWithKey: (NSString *) key changeKind: (NSKeyValueChange) kind isPrior: (BOOL) isPriorNotification {
    NSMutableString *sel = [[NSMutableString alloc] initWithString: key];
    [sel appendString: isPriorNotification ? @"Will" : @"Did"];

    if (kind == NSKeyValueChangeSetting) {
        [sel appendString: isPriorNotification ? @"Reset:" : @"Reset:with:"];

    } else if (kind == NSKeyValueChangeInsertion) {
        [sel appendString: isPriorNotification ? @"Add" : @"Add:"];

    } else if (kind == NSKeyValueChangeRemoval) {
        [sel appendString: @"Remove:"];
    }
    else if (kind == NSKeyValueChangeReplacement) {
        [sel appendString: isPriorNotification ? @"Replace:" : @"Replace:with:"];

    } else {
        [sel appendString: @"Update"];
    }

    SEL selector = NSSelectorFromString(sel);
    return selector;
}


@end