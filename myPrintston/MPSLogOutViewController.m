//
//  MPSLogOutViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import "MPSLogOutViewController.h"

extern BOOL isAdmin;
extern NSString *IP;

@interface MPSLogOutViewController ()

@end

@implementation MPSLogOutViewController

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
    
    self.title = @"Log Out";
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

// Go back to preview view if the user actually is not an admin. Should never happen though.
- (void)viewWillAppear:(BOOL)animated
{
    if (!isAdmin)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method that gets called when the admin presses log out.
- (IBAction)logout {
    UIAlertView *alert;
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/logout/", IP];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];

    // Tell user if could not connect to the server.
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Logout Failure"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Let the admin know if the server rejected the log out for any reason.
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Logout Failure"
                 message:@"Could not logout from server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    isAdmin = NO;
    
    // Create prompt that shows submission success
    alert = [[UIAlertView alloc]
             initWithTitle:@"Logout Success!"
             message:@"You have successfully logged out!"
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];
    
    // Segue to root view.
    [self performSegueWithIdentifier:@"logout" sender:nil];
}

@end
