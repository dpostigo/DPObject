//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicDelegater.h"

@interface BasicModel : BasicDelegater {

    NSDictionary *payload;

}

@property(nonatomic, strong) NSDictionary *payload;
- (void) saveWithKeys: (NSArray *) keys;
- (void) dearchivePayload;
- (NSDictionary *) dearchivedPayload;
+ (BasicModel *) sharedBasicModel;


- (NSString *) pathForSearchPath: (NSSearchPathDirectory) searchPath;
- (NSString *) cacheDirectoryPath;
- (NSString *) userDocumentsPath;

- (void) modelDidDearchive;
@end