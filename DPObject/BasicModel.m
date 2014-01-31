//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicModel.h"
#import <objc/runtime.h>

@implementation BasicModel {
}

@synthesize payload;

- (id) init {
    self = [super init];
    if (self) {
        self.payload = [self dearchivedPayload];
        [self dearchivePayload];

    }

    return self;
}


- (void) saveWithKeys: (NSArray *) keys {
    NSDictionary *payloadDict = [self payloadForKeys: keys];
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: payloadDict] forKey: @"payload"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) dearchivePayload {
    if (payload) {
        for (NSString *key in payload) {
            id value = [payload valueForKey: key];

            NSString *selectorString = [NSString stringWithFormat: @"set%@:", [key capitalizedString]];
            SEL selector = NSSelectorFromString(selectorString);
            if ([self respondsToSelector: selector]) {
                //                NSLog(@"%@ responds to %@", self, selectorString);
                IMP methodImplementation = class_getMethodImplementation([self class], selector);
                methodImplementation(self, selector, value);
            } else {
                //                NSLog(@"%@ does not respond to %@", self, selectorString);
            }

        }
    }

    [self modelDidDearchive];
}

- (NSDictionary *) dearchivedPayload {
    NSDictionary *ret = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: @"payload"];
    if (data != nil) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    }
    return ret;
}

- (NSDictionary *) payloadForKeys: (NSArray *) keys {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    for (int j = 0; j < [keys count]; j++) {
        NSString *key = [keys objectAtIndex: j];
        id value = [self valueForKey: key];
        [ret setObject: value forKey: key];
    }
    return ret;
}

+ (BasicModel *) sharedBasicModel {
    static BasicModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (NSString *) pathForSearchPath: (NSSearchPathDirectory) searchPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);
    NSString *directoryPath = [paths objectAtIndex: 0];
    return directoryPath;
}

- (NSString *) cacheDirectoryPath {
    return [self pathForSearchPath: NSCachesDirectory];
}

- (NSString *) userDocumentsPath {
    return [self pathForSearchPath: NSDocumentDirectory];
}


- (void) modelDidDearchive {

}

@end