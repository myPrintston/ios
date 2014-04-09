//
//  MPSErrorViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/6/14.
//
//

#import <UIKit/UIKit.h>

@interface MPSErrorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *errorList;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
