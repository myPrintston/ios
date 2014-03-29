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
    NSString* error;
}

+ (int) count;

@end
