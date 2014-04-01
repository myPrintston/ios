//
//  MPSPrinter.h
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import <Foundation/Foundation.h>

@interface MPSPrinter : NSObject {
    
    int printerid;
    double longitude;
    double latitude;
    NSString* name;
}

@property NSString *name;

- (id)initWithName:(NSString *)new_name;

- (int) printerid;
- (double) longitude;
- (double) latitude;

- (void) setPrinterId: (int) printerid;
- (void) setLongitude: (double) new_longitude;
- (void) setLatitude:  (double) new_latitude;

@end
