//
//  MPSLogInViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import <UIKit/UIKit.h>

@interface MPSLogInViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *userpw;


- (IBAction)login;

@end
