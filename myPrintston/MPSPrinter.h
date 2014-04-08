//
//  MPSPrinter.h
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import <Foundation/Foundation.h>

@interface MPSPrinter : NSObject

@property (nonatomic) int printerid;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL status;

- (id)initWithName:(NSString *)new_name;
- (double) distance;
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
