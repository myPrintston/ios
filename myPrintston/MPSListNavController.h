//
//  MPSListNavController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/19/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>

@interface MPSListNavController : UINavigationController

@property (nonatomic) NSMutableArray *printers;
@property (nonatomic) CLLocationManager *locationManager;

@end
