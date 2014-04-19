//
//  MPSErrorViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/6/14.
//
//

#import <UIKit/UIKit.h>
#import "MPSPrinter.h"
#import "MPSErrorType.h"

@interface MPSErrorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic) MPSPrinter *printer;
@property (retain, nonatomic) IBOutlet UITableView *errorList;
@property (weak, nonatomic) IBOutlet UITextField *netid;

- (IBAction)submit;
@end
