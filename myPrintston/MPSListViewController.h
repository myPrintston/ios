//
//  MPSListViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>
#import "MPSPrinterList.h"

@interface MPSListViewController : UITableViewController

@property (nonatomic) MPSPrinterList *printerList;
@property (nonatomic) CLLocationManager *locationManager;

@end
