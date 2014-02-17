//
// Created by Dani Postigo on 2/9/14.
//

#import <Foundation/Foundation.h>

@protocol DPObjectObserverProtocol <NSObject>


#pragma mark Observer selectors

- (void) objectWillUpdate: (id) object forProperty: (NSString *) property;
- (void) objectDidUpdate: (id) object withObject: (id) sentObject forProperty: (NSString *) property;


- (void) taskWillUpdateJob;
- (void) taskWillUpdate: (id) task forProperty: (NSString *) property;
- (void) taskDidUpdate: (id) task withObject: (id) object forProperty: (NSString *) property;
- (void) taskDidUpdate: (id) task withJob: (id) object;

@end