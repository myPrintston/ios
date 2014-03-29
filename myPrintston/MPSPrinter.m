//
//  MPSPrinter.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSPrinter.h"

int printer_count = 0;

@implementation MPSPrinter

+ (int) count {return printer_count;}

- (id) init {
    printer_count++;
    return self;
}

- (void) dealloc {
    printer_count--;
}

@end
