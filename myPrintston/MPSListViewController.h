//
//  MPSListViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>

@interface MPSListViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic) NSMutableArray *printers;

- (NSMutableArray*) loadPrinters;

@end
