//
//  MPSPrinterList.h
//  myPrintston
//
//  Created by Michael J Kim on 5/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/Corelocation.h>
#import "MPSPrinter.h"

@interface MPSPrinterList : NSObject

@property (nonatomic) NSMutableArray *printers;
@property (nonatomic) CLLocationManager *locationManager;


+ (MPSPrinterList*) initWithLocationManager:(CLLocationManager*)locationManager;
- (MPSPrinterList*) init;

- (int) count;
- (MPSPrinter*) printer:(int)index;

- (void) load;
- (void) update;
- (void) sort;

@end
