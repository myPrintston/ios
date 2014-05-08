//
//  MPSLogInViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import "MPSLogInViewController.h"

extern NSString *IP;
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
    
    self.title = @"Log In";
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.userid.delegate = self;
    self.userpw.delegate = self;
    
    keyboardHeight = 146;
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self action:@selector(dismissKeyboard)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Log In";
    
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
    UIAlertView *alert;
    
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/login/%@/%@/", IP, self.userid.text, self.userpw.text];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Login Failure"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Login Failure"
                 message:@"Not a valid Username/Password pair"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    alert = [[UIAlertView alloc]
             initWithTitle:@"Login Success!"
             message:@"You have successfully logged in!"
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];
    
    isAdmin = YES;
    [self performSegueWithIdentifier:@"login" sender:nil];
}
@end
