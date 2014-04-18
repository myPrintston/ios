//
//  MPSErrorType.h
//  myPrintston
//
//  Created by Michael J Kim on 4/17/14.
//
//

#import <Foundation/Foundation.h>

@interface MPSErrorType : NSObject

@property(nonatomic) int errorid;
@property(nonatomic) BOOL admin;
@property(nonatomic) NSString *eMsg;
@property(nonatomic) NSString *eType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
