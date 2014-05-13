//
//  MPSErrorType.m
//  myPrintston
//
//  Created by Michael J Kim on 4/17/14.
//
//

#import "MPSErrorType.h"

@implementation MPSErrorType

- (id) init {
    return self;
}

// Method to initialize with a JSON entry given by the server
- (id)initWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *fields = dictionary[@"fields"];
    
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        self.errorid = [dictionary[@"pk"] intValue];
        self.admin   = [fields[@"Admin"] boolValue];
        self.eMsg    = [fields objectForKey:@"eMsg"];
        self.eType   = [fields objectForKey:@"eType"];
    }
    
    return self;
}

@end
