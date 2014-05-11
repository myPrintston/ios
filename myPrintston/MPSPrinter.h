//
//  MPSPrinter.h
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MPSPrinter : NSObject

@property (nonatomic) int printerid;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) CLLocation *location;
@property (nonatomic) NSString *building;
@property (nonatomic) NSString *room;
@property (nonatomic) int status;
@property (nonatomic) NSString *statusMsg;

- (id)initWithName:(NSString *)new_name;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString*)name;

- (double) distCL:(CLLocation *)userLocation;

- (void) updateStatus;


@end
