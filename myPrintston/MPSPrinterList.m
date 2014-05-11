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

+ (id) initWithLocationManager:(CLLocationManager*) locationManager {
    MPSPrinterList *printerList = [[MPSPrinterList alloc] init];
    printerList.locationManager = locationManager;
    return printerList;
}

- (id) init {
    self.printers = [[NSMutableArray alloc] init];
    
    return self;
}

- (int) count {
    return (int) [self.printers count];
}

- (MPSPrinter*) printer:(int) index {
    return [self.printers objectAtIndex:index];
}

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
