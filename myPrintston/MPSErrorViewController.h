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

@interface MPSErrorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) MPSPrinter *printer;
@property (retain, nonatomic) IBOutlet UITableView *errorList;
@property (weak, nonatomic) IBOutlet UITextField *netid;
@property (weak, nonatomic) IBOutlet UITextView *comment;



- (IBAction)submit;
@end
