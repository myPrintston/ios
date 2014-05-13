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
    
    // Set delegates
    self.userid.delegate = self;
    self.userpw.delegate = self;
    
    keyboardHeight = 146;
    
    // Create tap recognizer to dismiss keyboard when the keyboard is present.
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self action:@selector(dismissKeyboard)];
}

// Go back to preview view if the user actually is an admin. Should never happen though.
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

// Method that dismisses the keyboard.
-(void)dismissKeyboard {
    [self.userid resignFirstResponder];
    [self.userpw resignFirstResponder];
}

// Move the view if the keyboard will cover the textField the user is editing in.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
    
    if (textField == self.userpw) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        
        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -keyboardHeight);
        [UIView commitAnimations];
    }
}

// Move the view back if the keyboard would have covered the textField the user was editing in.
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

// Dismiss the keyboard when the user hits the Return button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Method that gets called when the user hits the login button.
- (IBAction)login {
    UIAlertView *alert;
    
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/login/%@/%@/", IP, self.userid.text, self.userpw.text];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Let user know if connection to server cannot be established.
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Login Failure"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Tell user if the username / password pair is incorrect.
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Login Failure"
                 message:@"Not a valid Username/Password pair"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Tell the user that the login was successful.
    alert = [[UIAlertView alloc]
             initWithTitle:@"Login Success!"
             message:@"You have successfully logged in!"
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];
    
    isAdmin = YES;
    [self performSegueWithIdentifier:@"login" sender:nil];
}
@end
