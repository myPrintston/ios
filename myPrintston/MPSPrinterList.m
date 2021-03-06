//
//  MPSPrinterList.m
//  myPrintston
//
//  Created by Michael J Kim on 5/11/14.
//
//

#import "MPSPrinterList.h"

extern NSString *IP;

@implementation MPSPrinterList

// Create a MPSPrinterList Object with a locationManager to sort by distances
+ (id) initWithLocationManager:(CLLocationManager*) locationManager {
    MPSPrinterList *printerList = [[MPSPrinterList alloc] init];
    printerList.locationManager = locationManager;
    return printerList;
}

- (id) init {
    self.printers = [[NSMutableArray alloc] init];
    
    return self;
}

// Count the number of printers in the MPSPrinterList object
- (int) count {
    return (int) [self.printers count];
}

// Return the printer at the index
- (MPSPrinter*) printer:(int) index {
    return [self.printers objectAtIndex:index];
}

// Load all printers that the server gives
- (void) load {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pall/", IP]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return;
    
    [self.printers removeAllObjects];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *printerInfo in jsonArray) {
        MPSPrinter *printer = [[MPSPrinter alloc] initWithDictionary:printerInfo];
        [self.printers addObject:printer];
    }
}

// Update the statuses of all the pritners stored in the printer list.
- (void) update {
    NSMutableArray *printerids = [[NSMutableArray alloc] init];
    for (MPSPrinter *printer in self.printers)
        [printerids addObject:[NSNumber numberWithInt:printer.printerid]];
    
    NSString *urlstring = [[NSString stringWithFormat:@"%@/pids/", IP] stringByAppendingString:[printerids componentsJoinedByString:@"/"]];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([jsonArray count] == 0) {
        [self load];
    } else {
        for (int i = 0; i < [printerids count]; i++)
        {
            MPSPrinter *printer = [self.printers objectAtIndex:i];
            printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] intValue];
            printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
        }
    }
    
    [self sort];
}

// Sort the printers by distance to the user.
- (void) sort {
    CLLocation *userLocation = self.locationManager.location;
    [self.printers sortUsingComparator:^(id p1, id p2) {
        if ([p1 distCL:userLocation] > [p2 distCL:userLocation])
            return (NSComparisonResult) NSOrderedDescending;
        else
            return (NSComparisonResult) NSOrderedAscending;
    }];
}

@end
