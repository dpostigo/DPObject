//
// Created by Dani Postigo on 2/5/14.
//

#import "DPObjectObserver.h"
#import "NSObject+DPKitObservation.h"
#import "NSObject+DPObjectUtils.h"
#import "NSString+DPKitUtils.h"

@implementation DPObjectObserver

@synthesize objects;
@synthesize objectKeys;

+ (DPObjectObserver *) observer {
    static DPObjectObserver *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (id) init {
    self = [super init];
    if (self) {
        [self subscribeDelegate: self];
    }

    return self;
}


#pragma mark Methods

static char DPObjectObserverContext;

- (void) addObject: (id) object keys: (NSArray *) keys {
    keys = [keys valueForKeyPath: @"@distinctUnionOfObjects.self"];

    if (![self.objects containsObject: object]) {
        [self.objects addObject: object];
        [self.objectKeys addObject: keys];

    } else {

        NSUInteger objectIndex = [self.objects indexOfObject: object];
        NSArray *existingKeys = [self.objectKeys objectAtIndex: objectIndex];

        NSArray *uniqueKeys = [@[existingKeys, keys] valueForKeyPath: @"@distinctUnionOfArrays.self"];
        [self.objectKeys replaceObjectAtIndex: objectIndex withObject: uniqueKeys];

        NSMutableArray *newKeys = [[NSMutableArray alloc] initWithArray: keys];
        [newKeys removeObjectsInArray: existingKeys];
        keys = newKeys;
    }

    for (NSString *key in keys) {
        [object addObserver: self forKeyPath: key options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew) context: &DPObjectObserverContext];
    }

    //    NSLog(@"%s, self.objects = %lu, self.objectKeys = %lu", __PRETTY_FUNCTION__, [self.objects count], [self.objectKeys count]);
}


- (void) removeObject: (id) object {
    if ([self.objects containsObject: object]) {

        NSUInteger index = [self.objects indexOfObject: object];
        NSArray *keys = [self.objectKeys objectAtIndex: index];

        for (NSString *key in keys) {

            @try {
                [object removeObserver: self forKeyPath: key context: &DPObjectObserverContext];
            } @catch (NSException *exception) {
                //                NSLog(@"Caught exception.");
            }

        }

        [self.objects removeObject: object];
        [self.objectKeys removeObjectAtIndex: index];

    }
}



#pragma mark Observer selectors

- (void) objectWillUpdate: (id) object forProperty: (NSString *) property {
    //    NSLog(@"%s, property = %@", __PRETTY_FUNCTION__, property);
}

- (void) objectDidUpdate: (id) object withObject: (id) sentObject forProperty: (NSString *) property {
    //    NSLog(@"%s, property = %@", __PRETTY_FUNCTION__, property);
}

- (void) taskWillUpdate: (id) task forProperty: (NSString *) property {
    //    NSLog(@"%s, property = %@", __PRETTY_FUNCTION__, property);
}

- (void) taskDidUpdate: (id) task withObject: (id) object forProperty: (NSString *) property {
    //    NSLog(@"%s, property = %@", __PRETTY_FUNCTION__, property);
}

- (void) taskDidUpdate: (id) task withJob: (id) object {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (context == &DPObjectObserverContext) {
        NSString *property = keyPath;
        id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
        id newValue = [change objectForKey: NSKeyValueChangeNewKey];


        NSKeyValueChange kind = (NSKeyValueChange) [[change objectForKey: NSKeyValueChangeKindKey] intValue];

        BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];


        NSIndexSet *indexSet = [change objectForKey: NSKeyValueChangeIndexesKey];

        if ([indexSet count] == 1) {
            newValue = [newValue objectAtIndex: 0];
            oldValue = [oldValue objectAtIndex: 0];
        }

        NSString *classTypeString = [NSStringFromClass([object class]) decapitalize];
        NSString *propertyString = [property capitalizedSentence];

        if (kind == NSKeyValueChangeSetting) {
            id secondObject = isPriorNotification ? nil : newValue;

            NSString *format = [@"%@" stringByAppendingString: (isPriorNotification ? @"WillUpdate:withProperty:" : @"DidReset%@:with:")];

            if (isPriorNotification) {
                format = @"%@WillUpdate:forProperty:";
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: format, @"object"]) object: object object: property];
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: format, classTypeString]) object: object object: property];
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: @"%@WillUpdate%@", classTypeString, propertyString]) object: object object: nil];

            } else {
                format = @"%@DidUpdate:withObject:forProperty:";
                NSString *didTypedParameterSelector = [NSString stringWithFormat: @"%@DidUpdate:with%@:", classTypeString, propertyString];
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: format, @"object"]) object: object object: secondObject object: property];
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: format, classTypeString]) object: object object: secondObject object: property];
                [self notifyDelegates: NSSelectorFromString(didTypedParameterSelector) object: object object: secondObject];
            }

            //            NSLog(@"changeKind = %@, selector = %@, firstObject = %@, secondObject = %@", changeKind, NSStringFromSelector(selector), firstObject, secondObject);

        } else {

            NSString *changeKind = [self stringForKeyValueChange: kind];
            NSLog(@"changeKind = %@, classTypeString = %@, propertyString = %@", changeKind, classTypeString, propertyString);
        }
    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (void) notifyDelegates: (SEL) aSelector object: (id) obj object: (id) obj2 object: (id) object3 {
    [super notifyDelegates: aSelector object: obj object: obj2 object: object3];
    //    NSLog(@"%s, aSelector = %@", __PRETTY_FUNCTION__, NSStringFromSelector(aSelector));
}


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



#pragma mark Getters

- (NSMutableArray *) objectKeys {
    if (objectKeys == nil) {
        objectKeys = [[NSMutableArray alloc] init];
    }
    return objectKeys;
}

- (NSMutableArray *) objects {
    if (objects == nil) {
        objects = [[NSMutableArray alloc] init];
    }
    return objects;
}


@end