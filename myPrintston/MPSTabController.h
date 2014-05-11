//
//  MPSTabController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/19/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>
#import "MPSPrinterList.h"

@interface MPSTabController : UITabBarController <CLLocationManagerDelegate>

- (NSMutableArray*) loadPrinters;
- (void) updatePrinters;

@end
