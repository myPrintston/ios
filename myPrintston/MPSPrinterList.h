//
//  MPSPrinterList.h
//  myPrintston
//
//  Created by Michael J Kim on 5/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/Corelocation.h>

@interface MPSPrinterList : NSObject

@property (nonatomic) NSMutableArray *printers;
@property (nonatomic) CLLocationManager *locationManager;

- (int) count;

@end
