//
//  MPSErrorViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/6/14.
//
//

#import <UIKit/UIKit.h>

@interface MPSErrorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *errorList;
- (IBAction)submit;

@end
