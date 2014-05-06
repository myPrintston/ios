//
//  MPSLogInViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import "MPSLogInViewController.h"

extern BOOL isAdmin;

@interface MPSLogInViewController () {
    double keyboardHeight;
    UIGestureRecognizer *tap;
}

@end

@implementation MPSLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.userid.delegate = self;
    self.userpw.delegate = self;
    
    keyboardHeight = 146;
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self action:@selector(dismissKeyboard)];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (isAdmin)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.userid resignFirstResponder];
    [self.userpw resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
    
    if (textField == self.userpw) {
        NSLog(@"userpw editing");
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -keyboardHeight);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:tap];
    
    if (textField == self.userpw) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, keyboardHeight);
        [UIView commitAnimations];
        
        [self.userpw resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login {
    isAdmin = YES;
    [self performSegueWithIdentifier:@"login" sender:nil];
}

@end
