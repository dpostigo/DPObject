//
// Created by Dani Postigo on 2/5/14.
//

#import <Foundation/Foundation.h>
#import <DPObject/BasicDelegater.h>

@interface DPObjectObserver : BasicDelegater {
    NSMutableArray *objects;
    NSMutableArray *objectKeys;
}

@property(nonatomic, strong) NSMutableArray *objects;
@property(nonatomic, strong) NSMutableArray *objectKeys;

+ (DPObjectObserver *) observer;

- (void) addObject: (id) object keys: (NSArray *) keys;
- (void) removeObject: (id) object;
@end