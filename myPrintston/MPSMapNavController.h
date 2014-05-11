//
//  MPSMapNavController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>
#import "MPSPrinterList.h"

@interface MPSMapNavController : UINavigationController

@property (nonatomic) MPSPrinterList *printerList;
@property (nonatomic) CLLocationManager *locationManager;

@end
